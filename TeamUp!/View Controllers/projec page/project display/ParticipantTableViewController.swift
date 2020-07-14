//
//  ParticipantTableViewController.swift
//  TeamUp!
//
//  Created by Alicia Ho on 23/6/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class ParticipantTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var _tableView: UITableView!
    
    var db:Firestore!
    
    var ProjectArray = [Project]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _tableView.delegate = self
        _tableView.dataSource = self
        
        db = Firestore.firestore()
        //loadData()
        checkForUpdates()
        
        _tableView.estimatedRowHeight = 100
        _tableView.rowHeight = UITableView.automaticDimension
        
        _tableView.allowsMultipleSelectionDuringEditing = true
        
    }
    var documentID = ""
    /*
    func loadData() {
            
            let db = Firestore.firestore()
        
            //find uid
            var CURRENT_USER_UID: String? {
                if let currentUserUid = Auth.auth().currentUser?.uid {
                    return currentUserUid
                }
                return nil
            }
        
            //check whether the modules is alrdy there
            db.collection("users").whereField("uid", isEqualTo: CURRENT_USER_UID!).getDocuments() { (querySnapshot, error) in
                 if let error = error {
                     print("Error getting documents: \(error.localizedDescription)")
                 } else {
                     for i in querySnapshot!.documents {
                        let id = i.documentID
                        self.documentID = id
                        print("done snapshot, \(self.documentID)")
                        let docRef = db.collection("users").document(self.documentID).collection("projects")
                        
                        docRef.whereField("approval", isEqualTo: true).getDocuments() {
                            querySnapshot, error in
                            if let error = error {
                                print("\(error.localizedDescription)")
                            } else{
                             self.ProjectArray = querySnapshot!.documents.compactMap({Project(dictionary: $0.data())})
                                DispatchQueue.main.async {
                                    self._tableView.reloadData()
                                }
                            }
                        }
                    }
                }
        }
    }*/
       
      func checkForUpdates() {
            let db = Firestore.firestore()
            
                //find uid
                var CURRENT_USER_UID: String? {
                    if let currentUserUid = Auth.auth().currentUser?.uid {
                        return currentUserUid
                    }
                    return nil
                }
            
                //check whether the modules is alrdy there
                db.collection("users").whereField("uid", isEqualTo: CURRENT_USER_UID!).getDocuments() { (querySnapshot, error) in
                     if let error = error {
                         print("Error getting documents: \(error.localizedDescription)")
                     } else {
                         for i in querySnapshot!.documents {
                            let id = i.documentID
                            self.documentID = id
                            print("done snapshot, \(self.documentID)")
                            let docRef = db.collection("users").document(self.documentID).collection("projects")
                            
                            docRef.addSnapshotListener(includeMetadataChanges: true) {
                                querySnapshot, error in
                                guard let snapshot = querySnapshot else {return}
                                snapshot.documentChanges.forEach {
                                    diff in
                       
                                    if diff.type == .added {
                                        self.ProjectArray.append(Project(dictionary: diff.document.data())!)
                                        DispatchQueue.main.async {
                                            self._tableView.reloadData()
                                        }
                                    }
                                }
                   
                            }
                        }
                    }
            }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ProjectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "ProjCell")
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "ParticipantCell", for: indexPath)
        if cell == nil || cell?.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ParticipantCell")
        }
        let project = ProjectArray[indexPath.row]
        
        cell?.textLabel?.text = "\(project.Name) - \(project.Organiser)"
        cell?.detailTextLabel?.text = "\(project.Description)"
        
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.lineBreakMode = .byWordWrapping

        cell?.detailTextLabel?.numberOfLines = 0
        cell?.detailTextLabel?.lineBreakMode = .byWordWrapping
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    if (editingStyle == UITableViewCell.EditingStyle.delete) {
        
            // 2. Now Delete the Child from the database
        let name = ProjectArray[indexPath.row].Name

        let user = Auth.auth().currentUser
       // let projsRef = db.collection("projects")
        let query: Query = db.collection("users123").document("nPuJKSBpWBtZ4OnCGf1a").collection("Projects").whereField("Name", isEqualTo: name)
            query.getDocuments(completion: { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    for document in snapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        self.db.collection("users123").document("nPuJKSBpWBtZ4OnCGf1a").collection("Projects").document("\(document.documentID)").delete()
                }
            }})

        ProjectArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

        }
    }
    
}

