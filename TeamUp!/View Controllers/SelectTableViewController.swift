//
//  SelectTableViewController.swift
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

class SelectTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var db:Firestore!
    
    var ProjectArray = [Project]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        db = Firestore.firestore()
        //loadData()
        checkForUpdates()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
    }
    
    func loadData() {
           db.collection("projects").getDocuments() {
               querySnapshot, error in
               if let error = error {
                   print("\(error.localizedDescription)")
               }else{
                self.ProjectArray = querySnapshot!.documents.compactMap({Project(dictionary: $0.data())})
                   DispatchQueue.main.async {
                       self.tableView.reloadData()
                   }
               }
           }
       }
       
       func checkForUpdates() {
           db.collection("projects")
               .addSnapshotListener(includeMetadataChanges: true) {
                   querySnapshot, error in
                   
                   guard let snapshot = querySnapshot else {return}
                   
                   snapshot.documentChanges.forEach {
                       diff in
                       
                       if diff.type == .added {
                           self.ProjectArray.append(Project(dictionary: diff.document.data())!)
                           DispatchQueue.main.async {
                               self.tableView.reloadData()
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
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "selectcell", for: indexPath)
        if cell == nil || cell?.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "selectcell")
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let _addbutton = UITableViewRowAction(style: .normal, title: "Add") { (action, indexPath) in
            // share item at indexPath
            let project = self.ProjectArray[indexPath.row]
            var Name : String = project.Name
            var Description : String = project.Description
            var Organiser : String = project.Organiser
            var ref: DocumentReference? = nil
            ref = self.db.collection("users123").document("nPuJKSBpWBtZ4OnCGf1a").collection("Projects").addDocument(data: [
                "Name": Name,
                "Description": Description,
                "Organiser" : Organiser
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
        _addbutton.backgroundColor = UIColor.blue

        return [_addbutton]
    
    }
    
}
