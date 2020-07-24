//
//  KolodaViewController.swift
//  TeamUp!
//
//  Created by Alicia Ho on 24/6/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import Koloda
import pop
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

private let numberOfCards: Int = 5
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1


class KolodaViewController: UIViewController {
    
    var db:Firestore!
    @IBOutlet weak var kolodaView: KolodaView!
    var ProjectArray = [Project]()
    var CompetitionArray = [Competition]()
    var profileArray = [Profile]()
    var moduleArray = [Modules]()
    var passInfo = kolodaReader(name: "", type: "", status: true)
    var userInfo = waitingListInfo(name: "", major: "", uid: "")
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("\(passInfo)")
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = KolodaViewAnimator(koloda: kolodaView)
        
        db = Firestore.firestore()
        
        //checkForUpdates()
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        currentUserInfo()
        checkForUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // kolodaView.layer.cornerRadius = 20
        // kolodaView.clipsToBounds = true
        
        // Do any additional setup after loading the view.
        //  kolodaView.dataSource = self
        // kolodaView.delegate = self
        print("\(passInfo)")
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = KolodaViewAnimator(koloda: kolodaView)
        
        db = Firestore.firestore()
        
        //checkForUpdates()
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
    
    @IBAction func revertButton(_ sender: Any) {
        kolodaView?.revertAction()
        //print(ProjectArray.count)
    }
    
    func currentUserInfo() {
        var CURRENT_USER_UID: String? {
            if let currentUserUid = Auth.auth().currentUser?.uid {
                return currentUserUid
            }
            return nil
        }
        db.collection("users").document(CURRENT_USER_UID ?? "").getDocument{ (querySnapshot, error) in
          //  self.profileInfo.removeAll()
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                return
            }
            guard let snap = querySnapshot else {return}
            //let data = i.data()
            //let lastName = data("lastname") as? String ?? "anoymous"
            let lastName = snap.get("lastname") as? String ?? "no lastname"
            let firstName = snap.get("firstname") as? String ?? "no firstname"
            let major = snap.get("major") as? String ?? "no major"
            let uid = CURRENT_USER_UID ?? "no uid"
            let name = firstName + " " + lastName
            self.userInfo = waitingListInfo(name: name, major: major, uid: uid)
            print("done snapshot, \(name)")
        }
        
    }
    
    func checkForUpdates() {
        if(passInfo.type == "module") {
            db.collection("NUS modules").document(passInfo.name).collection("students").addSnapshotListener(includeMetadataChanges: true) {
                querySnapshot, error in
                guard let snapshot = querySnapshot else {return}
                snapshot.documentChanges.forEach {
                    diff in
                    if diff.type == .added {
                        self.profileArray.append(Profile(dictionary: diff.document.data())!)
                        DispatchQueue.main.async {
                            self.kolodaView.reloadData()
                        }}}}
        }
        else if(passInfo.type == "competition") {
            db.collection("competition").document(passInfo.name).collection("students").addSnapshotListener(includeMetadataChanges: true) {
                querySnapshot, error in
                guard let snapshot = querySnapshot else {return}
                snapshot.documentChanges.forEach {
                    diff in
                    if diff.type == .added {
                        self.profileArray.append(Profile(dictionary: diff.document.data())!)
                        DispatchQueue.main.async {
                            self.kolodaView.reloadData()
                        }}}}
        }
        else if(passInfo.type == "creator") {
            db.collection("projects").document(passInfo.name).collection("participant").addSnapshotListener(includeMetadataChanges: true) {
                querySnapshot, error in
                guard let snapshot = querySnapshot else {return}
                snapshot.documentChanges.forEach {
                    diff in
                    if diff.type == .added {
                        self.profileArray.append(Profile(dictionary: diff.document.data())!)
                        DispatchQueue.main.async {
                            self.kolodaView.reloadData()
                        }}}}
        }
            //change the format to project selection
        else if(passInfo.type == "project") {
            db.collection("projects")
                .addSnapshotListener(includeMetadataChanges: true) {
                    querySnapshot, error in
                    guard let snapshot = querySnapshot else {return}
                    snapshot.documentChanges.forEach {
                        diff in
                        if diff.type == .added {
                            self.ProjectArray.append(Project(dictionary: diff.document.data())!)
                            DispatchQueue.main.async {
                                self.kolodaView.reloadData()
                            }
                        }}}
        }
        else {
            print("error")
            
        }
        
    }
    
    
    
}

extension KolodaViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        let alert = UIAlertController(title: "Congratulation!", message: "You're now matched", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation?.springBounciness = frameAnimationSpringBounciness
        animation?.springSpeed = frameAnimationSpringSpeed
        return animation
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if(direction == .right){
            //alicia's code
            let alert = UIAlertController(title: nil , message: nil, preferredStyle: .alert)
            // alert.addAction(UIAlertAction(title: "OK", style: .default))
            var imageView = UIImageView(frame: CGRect(x: 10, y: 50, width: 250, height: 230))
            imageView.image = #imageLiteral(resourceName: "tick")
            alert.view.addSubview(imageView)
            let height = NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320)
            let width = NSLayoutConstraint(item: alert.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
            alert.view.addConstraint(height)
            alert.view.addConstraint(width)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                // your actions here...
            }))
            self.present(alert, animated: true, completion: nil)
            
            if(passInfo.type == "project") {
                var project = self.ProjectArray[index]
                var name : String = project.name
                var description : String = project.description
                var organiser : String = project.organiser
                var uid:String = project.uid
                
                //to add the project into the participant's list
                self.db.collection("users").document(self.userInfo.uid).collection("individualParticipants").document(name).setData([
                    "name": name,
                    "description": description,
                    "organiser" : organiser,
                    "organiser uid": uid,
                    "approval" : false])
                
                //to add the participant info into the project creator's list
                self.db.collection("users").document(uid).collection("waitingList").addDocument(data:[
                    "uid":self.userInfo.uid,
                    "name":self.userInfo.name,
                    "type":passInfo.type,
                    "teamname":passInfo.name])
            }
            else {
                let human = self.profileArray[index]
                let uid = human.uid
                //so the user only sent friend request but cannot sent them message
                self.db.collection("users").document(uid).collection("waitingList").addDocument(data:["uid":self.userInfo.uid, "teamname":passInfo.name, "type": passInfo.type, "name":self.userInfo.name])
            }
        }
        if(direction == .left) {
            print("rejected the user!!")
        }
    }
}

extension KolodaViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return ProjectArray.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = UILabel()
        
        view.frame = CGRect.init(x: 0, y: 0, width: 300, height: 300)
        if(passInfo.type == "project") {
            view.text = "\(ProjectArray[index].name) - \(ProjectArray[index].description) - \(ProjectArray[index].roleNeeded)"
        }
        else{
            view.text = "\(profileArray[index].firstname) \(profileArray[index].lastname) - \(profileArray[index].major)"
        }
        return view
    }
    
    /*func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
     return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
     }*/
}



/*
     if(passInfo.type == "module") {
         //add the human under waiting list (sent friend request)
         self.db.collection("users").document(human.uid).collection("module").document(passInfo.name).collection("waitingList").document(uid).setData([
             "name":self.userInfo.name,
             "uid": self.userInfo.uid,
             "major" : self.userInfo.major])
         //add the sent friend request
         self.db.collection("users").document(self.userInfo.uid).collection("module").document(passInfo.name).collection("sentFriendRequest").document(human.uid).setData(["name":name,
         "uid": uid,
         "major" : major])
         
         //easier for alicia
         self.db.collection("users").document(human.uid).collection("waitingList").addDocument(data:["uid":self.userInfo.uid, "teamname":passInfo.name, "type": passInfo.type, "name":self.userInfo.name])
     }
     else if(passInfo.type == "creator") {
         self.db.collection("users").document(human.uid).collection("individualParticipant").document(passInfo.name).setData([
         "organiser":self.userInfo.name,
         "uid": self.userInfo.uid,
         "major" : self.userInfo.major,"project name":passInfo.name])
         
         self.db.collection("users").document(human.uid).collection("waitingList").addDocument(data:["uid":self.userInfo.uid, "teamname":passInfo.name, "type": passInfo.type, "name":self.userInfo.name])
     }
     else {
         self.db.collection("users").document(human.uid).collection("competition").document(passInfo.name).collection("waitingList").document(uid).setData([
         "name":self.userInfo.name,
         "uid": self.userInfo.uid,
         "major" : self.userInfo.major])
     }*/
