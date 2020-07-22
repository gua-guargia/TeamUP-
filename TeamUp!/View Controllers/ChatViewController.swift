//
//  ChatViewController.swift
//  TeamUp!
//
//  Created by Alicia Ho on 8/7/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import InputBarAccessoryView
import Firebase
import MessageKit
import FirebaseFirestore
import FirebaseAuth
import SDWebImage
import CoreData

class ChatViewController: MessagesViewController,InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    var currentUser: User = Auth.auth().currentUser!
    private var docReference: DocumentReference?
    var messages: [Message] = []
    
    var user2Name: String?
    var user2ImgUrl: String?
    var user2UID: String? 
    var documentIDCode = ""
    
    
     var db:Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = user2Name ?? "Chat"
        print("\(user2UID)")

        navigationItem.largeTitleDisplayMode = .never
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .blue
        messageInputBar.sendButton.setTitleColor(.blue, for: .normal)
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        loadChat()
    }
    
    func createNewChat() {
        let users = [self.currentUser.uid, self.user2UID]
        let data: [String: Any] = [
            "users":users
            ]
        var CURRENT_USER_UID: String? {
                   if let currentUserUid = Auth.auth().currentUser?.uid {
                       return currentUserUid
                   }
                   return nil
        }
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isEqualTo: CURRENT_USER_UID!).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            }
            else {
                for i in querySnapshot!.documents {
                    let id = i.documentID
                    self.documentIDCode = id
                    print("done snapshot, \(self.documentIDCode)")
                    print("current user = \(CURRENT_USER_UID)")

                    db.collection("users").document(self.documentIDCode).collection("chats").addDocument(data: data) { (error) in
                        if let error = error {
                            print("Unable to create chat! \(error)")
                            return
                        } else {
                            db.collection("users").whereField("uid", isEqualTo: self.user2UID!).getDocuments() { (querySnapshot, error) in
                             if let error = error {
                                 print("Error getting documents: \(error.localizedDescription)")
                             }
                             else {
                                 for i in querySnapshot!.documents {
                                     let id = i.documentID
                                     self.documentIDCode = id
                                     print("done snapshot, \(self.documentIDCode)")

                                     db.collection("users").document(self.documentIDCode).collection("chats").addDocument(data: data) { (error) in
                                         if let error = error {
                                             print("Unable to create chat! \(error)")
                                             return
                                         } else {
                                             self.loadChat()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

    func loadChat() {

        var CURRENT_USER_UID: String? {
            if let currentUserUid = Auth.auth().currentUser?.uid {
                return currentUserUid
            }
            return nil
        }
    //Fetch all the chats which has current user in it
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isEqualTo: CURRENT_USER_UID!).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            }
            else {
                for i in querySnapshot!.documents {
                    let id = i.documentID
                    self.documentIDCode = id
                    print("done snapshot, \(self.documentIDCode)")
                    print("current user = \(CURRENT_USER_UID)")

                    db.collection("users").document(self.documentIDCode).collection("chats").getDocuments(){ (chatQuerySnap, error) in

                        if let error = error {
                            print("Error: \(error)")
                            return
                        }
                        else {

                            //Count the no. of documents returned
                            guard let queryCount = chatQuerySnap?.documents.count else {
                                return
                            }

                            if queryCount == 0 {
                                //If documents count is zero that means there is no chat available and we need to create a new instance
                                self.createNewChat()
                            }
                            else if queryCount >= 1 {
                                //Chat(s) found for currentUser
                                for doc in chatQuerySnap!.documents {

                                    let chat = Chat(dictionary: doc.data())
                                    //Get the chat which has user2 id
                                    if (chat?.users.contains(self.user2UID!))! {

                                        self.docReference = doc.reference
                                        //fetch it's thread collection
                                        doc.reference.collection("thread")
                                            .order(by: "created", descending: false)
                                            .addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                                                if let error = error {
                                                    print("Error: \(error)")
                                                    return
                                                }
                                                else {
                                                    self.messages.removeAll()
                                                    for message in threadQuery!.documents {

                                                        let msg = Message(dictionary: message.data())
                                                        self.messages.append(msg!)
                                                        print("Data: \(msg?.content ?? "No message found")")
                                                    }
                                                    self.messagesCollectionView.reloadData()
                                                    self.messagesCollectionView.scrollToBottom(animated: true)
                                                }
                                            })
                                        return
                                    } //end of if
                                } //end of for
                                self.createNewChat()
                            } else {
                                print("Let's hope this error never prints!")
                            }
                        }
                    }
                }
            }
        }
    }


    private func insertNewMessage(_ message: Message) {
    //add the message to the messages array and reload it
        messages.append(message)
        messagesCollectionView.reloadData()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }

    private func save(_ message: Message) {
    //Preparing the data as per our firestore collection
        let data: [String: Any] = [
            "content": message.content,
            "created": message.created,
            "id": message.id,
            "senderID": message.senderID,
            "senderName": message.senderName
        ]
    //Writing it to the thread using the saved document reference we saved in load chat function
       /* docReference?.collection("thread").addDocument(data: data, completion: { (error) in
            if let error = error {
                print("Error Sending message: \(error)")
                return
            }
            else{
            let db = Firestore.firestore()
            db.collection("users").whereField("uid", isEqualTo: self.user2UID!).getDocuments() {(querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error.localizedDescription)")
                }
                else {
                    for i in querySnapshot!.documents {
                        let id = i.documentID
                        self.documentIDCode = id
                        print("done snapshot, \(self.documentIDCode)")

                        db.collection("users").document(self.documentIDCode).collection("chats").getDocuments(){ (chatQuerySnap, error) in
                                if let error = error {
                                    print("Error: \(error)")
                                    return
                                }
                                else {
                                    for doc in chatQuerySnap!.documents {

                                        let chat = Chat(dictionary: doc.data())
                                        //Get the chat which has user2 id
                                        if ((chat?.users.contains(self.currentUser.uid)) != nil) {

                                            self.docReference = doc.reference
                                            self.docReference?.collection("thread").addDocument(data: data, completion: { (error) in
                                                if let error = error {
                                                    print("Error Sending message: \(error)")
                                                    return
                                                }
                                            })
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            }
        })*/
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isEqualTo: self.currentUser.uid).getDocuments() {(querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            }
            else {
                for i in querySnapshot!.documents {
                    let id = i.documentID
                    self.documentIDCode = id
                    print("done snapshot, \(self.documentIDCode)")

                    db.collection("users").document(self.documentIDCode).collection("chats").getDocuments(){ (chatQuerySnap, error) in
                            if let error = error {
                                print("Error: \(error)")
                                return
                            }
                            else {
                                for doc in chatQuerySnap!.documents {

                                    let chat = Chat(dictionary: doc.data())
                                    //Get the chat which has user2 id
                                    if ((chat?.users.contains(self.user2UID!)) != nil) {

                                        self.docReference = doc.reference
                                        self.docReference?.collection("thread").addDocument(data: data, completion: { (error) in
                                            if let error = error {
                                                print("Error Sending message: \(error)")
                                                return
                                            }
                                            else{
                                                db.collection("users").whereField("uid", isEqualTo: self.user2UID!).getDocuments() {(querySnapshot, error) in
                                                    if let error = error {
                                                        print("Error getting documents: \(error.localizedDescription)")
                                                    }
                                                    else {
                                                        for i in querySnapshot!.documents {
                                                            let id = i.documentID
                                                            self.documentIDCode = id
                                                            print("done snapshot, \(self.documentIDCode)")

                                                            db.collection("users").document(self.documentIDCode).collection("chats").getDocuments(){ (chatQuerySnap, error) in
                                                                    if let error = error {
                                                                        print("Error: \(error)")
                                                                        return
                                                                    }
                                                                    else {
                                                                        for doc in chatQuerySnap!.documents {

                                                                            let chat = Chat(dictionary: doc.data())
                                                                            //Get the chat which has user2 id
                                                                            if ((chat?.users.contains(self.currentUser.uid)) != nil) {

                                                                                self.docReference = doc.reference
                                                                                self.docReference?.collection("thread").addDocument(data: data, completion: { (error) in
                                                                                    if let error = error {
                                                                                        print("Error Sending message: \(error)")
                                                                                        return
                                                                                    }
                                                                                })
                                                                            }
                                                                        }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        })
                                    }
                                }
                        }
                    }
                }
            }
        }
            self.messagesCollectionView.scrollToBottom()
        }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isEqualTo: currentUser.uid).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            }
            else {
                for i in querySnapshot!.documents {
                    let myDisplayName = i.get("firstname") as! String
                    let message = Message(id: self.currentUser.uid, content: text, created: Timestamp(), senderID: self.currentUser.uid, senderName: myDisplayName)
                
                      //messages.append(message)
                    self.insertNewMessage(message)
                    self.save(message)
                }
                
            }
        }
            
       /* let message = Message(id: currentUser.uid, content: text, created: Timestamp(), senderID: currentUser.uid, senderName: myDisplayName)
        
            
              //messages.append(message)
              insertNewMessage(message)
              save(message)*/

              inputBar.inputTextView.text = ""
              messagesCollectionView.reloadData()
              messagesCollectionView.scrollToBottom(animated: true)
    }

    func currentSender() -> SenderType {
        
        return Sender(id: Auth.auth().currentUser!.uid, displayName: Auth.auth().currentUser?.displayName ?? "Name not found")
        
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
        
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        if messages.count == 0 {
            print("No messages to display")
            return 0
        } else {
            return messages.count
        }
    }
    
    
    // MARK: - MessagesLayoutDelegate
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    // MARK: - MessagesDisplayDelegate
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue: .lightGray
    }

    /*func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        if message.sender.senderId == currentUser.uid {
            SDWebImageManager.shared.loadImage(with: currentUser.photoURL, options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                avatarView.image = image
            }
        } else {
            SDWebImageManager.shared.loadImage(with: URL(string: user2ImgUrl!), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                avatarView.image = image
            }
        }
    }*/

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)

    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
      let name = message.sender.displayName
      return NSAttributedString(
        string: name,
        attributes: [
          .font: UIFont.preferredFont(forTextStyle: .caption1),
          .foregroundColor: UIColor(white: 0.3, alpha: 1)
        ]
      )
    }
    
}

