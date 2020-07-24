//
//  SearchProjectViewController.swift
//  TeamUp!
//
//  Created by apple on 7/8/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class SearchProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    var projectArray = [Project]()
    var currentProjectArray = [Project]() //filter
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //viewDidLoad will only be called once to get the information at the start
    //NOTE: the firebase is running at the background which causes the two printing statement appears before the snapshot statement, because it finishes the running for other parts in ViewDidLoad first
    override func viewDidLoad() {
        
        //this part is necessary as it assign the data source and delegate to the 'table' i created under this view controller
        self.table.dataSource = self
        self.table.delegate = self
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded the view")
        let db = Firestore.firestore()
        // TODO: Check whether this listener is only called once or not
        db.collection("projects").getDocuments { (snap, err) in
            // TODO: clear your modulesArray //to make sure the reload data doesn't stuck tgt
            self.projectArray.removeAll()
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            for i in snap!.documents{
                let name = i.get("name") as! String
                let organiser = i.get("organiser") as! String
                let description = i.get("description") as! String
                let roleNeeded = i.get("roleNeed") as! String
                let uid = i.get("uid") as! String
                self.projectArray.append(Project(name: name, organiser: organiser, description: description, roleNeeded: roleNeeded, uid:uid))
                print("done snapshot, \(name), \(roleNeeded)")
                self.table.reloadData()
            }
            self.currentProjectArray = self.projectArray
            
            self.table.reloadData()//to make sure everytime the page is open, the data in the table is updated!
        }
        print("initialize finished")
        setUpSearchBar()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        alterLayout()
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style:.plain, target: .nil, acction: nil)
        
    }
    @objc func handleCancel() {
        print("cancel")
        //self.dismiss(animated: true, completion: nil) //for modal view only
        //for push view controller
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    //set up the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentProjectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell") as? ProjectTableCell else {
            print("here")
            return UITableViewCell()
        }
        cell.organiserLbl.text = currentProjectArray[indexPath.row].organiser
        cell.roleLbl.text = currentProjectArray[indexPath.row].roleNeeded
        cell.nameLbl.text = currentProjectArray[indexPath.row].name
        cell.descriptionLbl.text = currentProjectArray[indexPath.row].description
        cell.backgroundColor = UIColor.getRandomColor(index:indexPath.row)
        checkSelect(name: cell.nameLbl.text!, cell: cell)
        print("here is for the cell")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    //keep the search bar at the top of the screen
    func alterLayout() {
        table.tableHeaderView = UIView()
        //search bar in section header
        table.estimatedSectionHeaderHeight = 100
        //search bar in navigation bar
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = false
        searchBar.placeholder = "Search your modules here"
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    //set up the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentProjectArray = projectArray
            table.reloadData()
            return
        }
        currentProjectArray = projectArray.filter({ project -> Bool in
            project.name.lowercased().contains(searchText.lowercased()) || project.organiser.lowercased().contains(searchText.lowercased()) || project.description.lowercased().contains(searchText.lowercased())
        })
        table.reloadData()
    }
    
    func checkSelect(name:String, cell:ProjectTableCell) {
        var documentID = ""
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
                    documentID = id
                    print("done snapshot, \(documentID), \(name)")
                    let docRef = db.collection("users").document(documentID).collection("projects").document(name)
                    
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            print("true, the doc exists")
                            cell.addButton.setTitle("selected", for: UIControl.State())
                        } else {
                            print("false, the doc doesn't exist")
                            cell.addButton.setTitle("+", for: UIControl.State())
                        }
                    }
                }
            }
        }
    }
    
}
