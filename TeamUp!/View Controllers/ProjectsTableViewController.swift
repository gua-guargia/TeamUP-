//
//  ProjectsTableViewController.swift
//  TeamUp!
//
//  Created by Alicia Ho on 30/5/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class ProjectsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var db:Firestore!
    
    var ProjectArray = [Project]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        db = Firestore.firestore()
        loadData()
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
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "ProjCell", for: indexPath)
        if cell == nil || cell?.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ProjCell")
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            
                // 2. Now Delete the Child from the database
            let name = ProjectArray[indexPath.row].Name

            let user = Auth.auth().currentUser
           // let projsRef = db.collection("projects")
            let query: Query = db.collection("projects").whereField("Name", isEqualTo: name)
                query.getDocuments(completion: { (snapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        for document in snapshot!.documents {
                            //print("\(document.documentID) => \(document.data())")
                            self.db.collection("projects").document("\(document.documentID)").delete()
                    }
                }})

                ProjectArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)

            }
        }
}
