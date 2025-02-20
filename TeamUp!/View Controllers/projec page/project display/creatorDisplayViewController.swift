//
//  creatorDisplayViewController.swift
//  TeamUp!
//
//  Created by apple on 7/21/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class creatorDisplayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var moduleArray = [String]()
    
    @IBOutlet weak var table: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("the viewWillAppear run")
        loadProject()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        
        //loadData()
        //checkForUpdates()
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        //print("creator display page")
        loadProject()
        alterLayout()
    }
    
    @objc func handleAdd() {
        let vc = storyboard?.instantiateViewController(identifier: "projectCreation")as! ProjectsCreationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
  /*  @objc func handleCancel() {
        print("cancel")
        self.dismiss(animated: true, completion: nil) //for modal view only
        //for push view controller
        //navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }*/
       
    func loadProject() {
        let db = Firestore.firestore()
        var CURRENT_USER_UID: String? {
            if let currentUserUid = Auth.auth().currentUser?.uid {
                return currentUserUid
            }
            return nil
        }
        //check whether the modules is alrdy there
        db.collection("users").document(CURRENT_USER_UID ?? "").collection("individualCreator").getDocuments(){ (document, error) in
                        self.moduleArray.removeAll()
                        if let error = error {
                            print("Error getting documents: \(error.localizedDescription)")
                        } else {
                            for i in document!.documents {
                                let name = i.get("name") as! String
                                self.moduleArray.append(name)
                                print("done snapshot, \(name)")
                                print("print \(self.moduleArray)")
                                self.table.reloadData()
                            }
                        }
                    }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func alterLayout() {
        table.tableHeaderView = UIView()
        table.estimatedSectionHeaderHeight = 100
        table.rowHeight = 200
    }
    
  /*  func checkForUpdates() {
        let db = Firestore.firestore()
        var CURRENT_USER_UID: String? {
            if let currentUserUid = Auth.auth().currentUser?.uid {
                return currentUserUid
            }
            return nil
        }
        let docRef = db.collection("users").document(self.documentID).collection("individualCreator")
                            
        docRef.addSnapshotListener(includeMetadataChanges: true) {
                querySnapshot, error in
                    guard let snapshot = querySnapshot else {
                        print("error fetching snapshots: \(error!)")
                        return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        let data = diff.document.data()
                        let code = data["name"] as? String ?? ""
                        self.moduleArray.append(code)
                                        DispatchQueue.main.async {
                                            self.table.reloadData()
                        }
                    }
                }
            }
    }*/

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moduleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "creatorCell") as? creatorProjectDisplayCell else {
           print("here")
           return UITableViewCell()
       }
        cell.nameLbl.text = moduleArray[indexPath.row]
        cell.backgroundColor = UIColor.getRandomColor(index:indexPath.row)
        //print("here is for the cell, \(cell.nameLbl.text)")
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
        // 2. Now Delete the Child from the database
            let name = moduleArray[indexPath.row]
            let db = Firestore.firestore()
            var CURRENT_USER_UID: String? {
                if let currentUserUid = Auth.auth().currentUser?.uid {
                    return currentUserUid
                }
                return nil
            }
            let query: Query = db.collection("users").document(CURRENT_USER_UID ?? "").collection("individualCreator").whereField("name", isEqualTo: name)
            query.getDocuments(completion: { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    for document in snapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        db.collection("users").document(CURRENT_USER_UID ?? "").collection("individualCreator").document("\(document.documentID)").delete()}}})
            
            //TODO: need the code for delete the project from the project list
            
            //TODO: need the code for delete the project from the participant's list
            moduleArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "koloda")as! KolodaViewController
        vc.passInfo = kolodaReader(name: moduleArray[indexPath.row], type: "creator", status: true)
        self.navigationController?.pushViewController(vc, animated: true)
        print("done, I'm pushing the display module page")
    }
}
