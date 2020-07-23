//
//  participantDisplayViewController.swift
//  TeamUp!
//
//  Created by apple on 7/21/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class participantDisplayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    var projectArray = [ProjectDisp]()
    var documentID = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        
        //loadData()
        //checkForUpdates()
        loadProject()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        
    }
    
    @objc func handleAdd() {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = storyboard?.instantiateViewController(identifier: "koloda")as! KolodaViewController
            vc.passInfo = kolodaReader(name:"", type: "participants", status: true)
            self.navigationController?.pushViewController(vc, animated: true)
            print("done, I'm pushing the display module page")
        }
    }
       
    func loadProject() {
        let db = Firestore.firestore()
        var documentID = ""
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
                    documentID = id
                    self.documentID = documentID
                    //get the project approved
                    let docRef = db.collection("users").document(documentID).collection("individualParticipant")
                    
                    docRef.getDocuments() { (document, error) in
                        if let error = error {
                            print("Error getting documents: \(error.localizedDescription)")
                        } else {
                            for i in document!.documents {
                                let name = i.get("name") as! String
                                let approval = i.get("approval") as! Bool
                                self.projectArray.append(ProjectDisp(name:name, approval:approval))
                                print("done snapshot, \(name), \(approval)")
                                self.table.reloadData()
                            }
                        }
                    }
                 }
            }
        }
    }
    
      func checkForUpdates() {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(self.documentID).collection("individualParticipant")
                            
        docRef.addSnapshotListener(includeMetadataChanges: true) {
                querySnapshot, error in
                    guard let snapshot = querySnapshot else {
                        print("error fetching snapshots: \(error!)")
                        return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                                        self.projectArray.append(ProjectDisp(dictionary: diff.document.data())!)
                                        DispatchQueue.main.async {
                                            self.table.reloadData()
                        }
                    }
                }
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantCell") as? projectDisplayCell else {
           print("here")
           return UITableViewCell()
       }
        cell.nameLbl.text = projectArray[indexPath.row].name
        let approval = projectArray[indexPath.row].approval
        if (approval == true) {
            cell.backgroundColor = UIColor.getRandomColor(index:indexPath.row)
        }
        else {
            cell.backgroundColor = UIColor.gray
        }
       print("here is for the cell")
       
       return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    if (editingStyle == UITableViewCell.EditingStyle.delete) {
        // 2. Now Delete the Child from the database
        let name = projectArray[indexPath.row].name
        let db = Firestore.firestore()
        let query: Query = db.collection("users").document(self.documentID).collection("individualParticipant").whereField("name", isEqualTo: name)
            query.getDocuments(completion: { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    for document in snapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        db.collection("users").document(self.documentID).collection("individualParticipant").document("\(document.documentID)").delete()}}})
        //need to add the code to change the creator side, to delete the participant from the creator's list
        
        projectArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
