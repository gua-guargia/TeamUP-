//
//  ProjectsTableViewController.swift
//  TeamUp!
//
//  Created by Alicia Ho on 30/5/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import FirebaseFirestore

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
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
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
        
        
        return cell!
    }
    
}
