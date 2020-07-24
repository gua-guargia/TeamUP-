//
//  SearchCompetitionViewController.swift
//  TeamUp!
//
//  Created by apple on 7/8/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class SearchCompetitionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    var competitionArray = [Competition]()
    var currentCompetitionArray = [Competition]() //filter
    
    
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
        db.collection("competition").getDocuments { (snap, err) in
            // TODO: clear your modulesArray //to make sure the reload data doesn't stuck tgt
            self.competitionArray.removeAll()
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            for i in snap!.documents{
                let Name = i.get("Name") as! String
                let Organiser = i.get("Organiser") as! String
                let Description = i.get("Description") as! String
                let WebLink = i.get("WebLink") as! String
                self.competitionArray.append(Competition(Name: Name, Organiser: Organiser, Description: Description, WebLink: WebLink))
                print("done snapshot, \(Name), \(WebLink)")
                //self.table.reloadData()
            }
            self.currentCompetitionArray = self.competitionArray
            
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
        return currentCompetitionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CompetitionCell") as? CompetitionTableCell else {
            print("here")
            return UITableViewCell()
        }
        cell.organiserLbl.text = currentCompetitionArray[indexPath.row].Organiser
        cell.webLbl.text = currentCompetitionArray[indexPath.row].WebLink
        cell.nameLbl.text = currentCompetitionArray[indexPath.row].Name
        cell.descriptionLbl.text = currentCompetitionArray[indexPath.row].Description
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
        searchBar.placeholder = "Search the competition name/organiser/category here"
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    //set up the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentCompetitionArray = competitionArray
            table.reloadData()
            return
        }
        currentCompetitionArray = competitionArray.filter({ competition -> Bool in
            competition.Name.lowercased().contains(searchText.lowercased()) || competition.Organiser.lowercased().contains(searchText.lowercased()) || competition.Description.lowercased().contains(searchText.lowercased())
        })
        table.reloadData()
    }
    
    
    func checkSelect(name:String, cell:CompetitionTableCell) {
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
