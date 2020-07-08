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
                        let Name = i.get("Name") as! String
                        let Organiser = i.get("Organiser") as! String
                        let Description = i.get("Description") as! String
                        let Role = i.get("roleNeed") as! String
                        self.projectArray.append(Project(Name: Name, Organiser: Organiser, Description: Description, Role: Role))
                        print("done snapshot, \(Name), \(Role)")
                    //self.table.reloadData()
                }
                self.currentProjectArray = self.projectArray
                
                self.table.reloadData()//to make sure everytime the page is open, the data in the table is updated!
            }
            print("initialize finished")
            setUpSearchBar()
         //   alterLayout()
            //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style:.plain, target: .nil, acction: nil)
            
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
            cell.organiserLbl.text = currentProjectArray[indexPath.row].Organiser
            cell.roleLbl.text = currentProjectArray[indexPath.row].Role
            cell.nameLbl.text = currentProjectArray[indexPath.row].Name
            cell.descriptionLbl.text = currentProjectArray[indexPath.row].Description
            print("here is for the cell")
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 300
        }
        
        //keep the search bar at the top of the screen
/*       func alterLayout() {
            table.tableHeaderView = UIView()
            //search bar in section header
            table.estimatedSectionHeaderHeight = 100
            //search bar in navigation bar
            navigationItem.titleView = searchBar
            searchBar.showsScopeBar = false
            searchBar.placeholder = "Search your modules here"
            self.navigationController?.hidesBarsOnSwipe = true
        }
*/
        //set up the search bar
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            guard !searchText.isEmpty else {
                currentProjectArray = projectArray
                table.reloadData()
                return
            }
            currentProjectArray = projectArray.filter({ project -> Bool in
                project.Name.lowercased().contains(searchText.lowercased())
            })
            table.reloadData()
        }

}
