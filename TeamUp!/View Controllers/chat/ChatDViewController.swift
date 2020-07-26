//
//  ChatDViewController.swift
//  TeamUp!
//
//  Created by Alicia Ho on 23/7/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import CoreData

class ChatDViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var ContactsArray = [ContactStruct]()
    var currentContactsArray = [ContactStruct]() //filter
    var documentIDCode = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
           self.table.dataSource = self
           self.table.delegate = self
        
           // Do any additional setup after loading the view.
           print("loaded the view")
        
        var CURRENT_USER_UID: String? {
            if let currentUserUid = Auth.auth().currentUser?.uid {
                return currentUserUid
            }
            return nil
        }
        
           let db = Firestore.firestore()
              // TODO: Check whether this listener is only called once or not
             db.collection("users").whereField("uid", isEqualTo: CURRENT_USER_UID!).getDocuments() { (querySnapshot, error) in
             if let error = error {
                 print("Error getting documents: \(error.localizedDescription)")
             }
             else {
                 for i in querySnapshot!.documents {
                   print("meeee")
                     let id = i.documentID
                     self.documentIDCode = id
                     print("done snapshot, \(self.documentIDCode)")
                     print("current user = \(CURRENT_USER_UID)")
                   
                   db.collection("users").document(self.documentIDCode).collection("waitingList").getDocuments { (snap, err) in
                       // TODO: clear your modulesArray //to make sure the reload data doesn't stuck tgt
                       self.ContactsArray.removeAll()
                       if err != nil {
                               print((err?.localizedDescription)!)
                               return
                       }
                       for i in snap!.documents{
                               let id = i.documentID
                               let name = i.get("name") as! String
                               let user2uid = i.get("uid") as! String
                               let user2type = i.get("type") as! String
                               let user2Proj = i.get("teamname") as! String
                               self.ContactsArray.append(ContactStruct(id: id, name: name, user2uid: user2uid, user2type: user2type, user2Proj: user2Proj))
                               print("done snapshot, \(name), \(user2uid)")
                            //self.table.reloadData()
                       }
                       self.currentContactsArray = self.ContactsArray
                       
                       self.table.reloadData()//to make sure everytime the page is open, the data in the table is updated!
                   }
               
               }
             }
           }
        
           print("initialize finished")
           setUpSearchBar()
           //alterLayout()
           //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style:.plain, target: .nil, acction: nil)
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
    }

    // MARK: - Table view data source


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentContactsArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableViewCell else {
            print("here")
            return UITableViewCell()
        }
        //cell.codeLbl.text = "yes"
        //cell.nameLbl.text = "no"
       // cell.codeLbl.text = currentModuleArray[indexPath.row].code
        cell.nameLbl.text = currentContactsArray[indexPath.row].name
        print("here is for the cell")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func alterLayout() {
        table.tableHeaderView = UIView()
        //search bar in section header
        table.estimatedSectionHeaderHeight = 100
        //search bar in navigation bar
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = false
        searchBar.placeholder = "Search your contacts here"
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentContactsArray = ContactsArray
            table.reloadData()
            return
        }
        currentContactsArray = ContactsArray.filter({ module -> Bool in
            module.name.lowercased().contains(searchText.lowercased())
        })
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let vc = storyboard?.instantiateViewController(withIdentifier: "secondView") as! ChatViewController
        
        vc.user2Name = currentContactsArray[indexPath.row].name
        
        vc.user2UID = currentContactsArray[indexPath.row].user2uid
        
        vc.user2Type = currentContactsArray[indexPath.row].user2type
        
        vc.user2Proj = currentContactsArray[indexPath.row].user2Proj
        
        self.navigationController?.pushViewController(vc, animated: true)
         print("meee")
        
    }

}

