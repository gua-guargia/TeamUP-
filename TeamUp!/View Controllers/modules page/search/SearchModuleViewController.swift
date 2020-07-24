//
//  SearchModuleViewController.swift
//  TeamUp!
//
//  Created by apple on 6/26/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase


/* some lessons
 
 *UIViewController: it is a class
 *UITableViewDataSource and UITableViewDelegate is an interface/protocol, it contains the method to do stuff, but you can code the specific steps to compete this method
 *the idea of protocol is similar to the relationship of students as a protocol and human as a class.
    *so that, we are both instance of human, but to be identified as students, we have to complete modules and works. the specific details of how to complete can varies, which needed to be code.
 */

class SearchModuleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //to initialize the page
    var modulesArray = [ModulesStruct]()
    var currentModuleArray = [ModulesStruct]() //filter
    
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
        db.collection("NUS modules").getDocuments { (snap, err) in
            // TODO: clear your modulesArray //to make sure the reload data doesn't stuck tgt
            self.modulesArray.removeAll()
            if err != nil {
                    print((err?.localizedDescription)!)
                    return
            }
            for i in snap!.documents{
                    let id = i.documentID
                    let name = i.get("name") as! String
                    let code = i.get("code") as! String
                    let teammateNumber = i.get("teammateNumber") as! String
                    self.modulesArray.append(ModulesStruct(id: id, name: name, code: code,teammateNumber: teammateNumber))
                     print("done snapshot, \(name), \(code)")
                //self.table.reloadData()
            }
            self.currentModuleArray = self.modulesArray
            
            self.table.reloadData()//to make sure everytime the page is open, the data in the table is updated!
        }
        print("initialize finished")
        setUpSearchBar()
        alterLayout()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
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
        return currentModuleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableCell else {
            print("here")
            return UITableViewCell()
        }
        //cell.codeLbl.text = "yes"
        //cell.nameLbl.text = "no"
        cell.codeLbl.text = currentModuleArray[indexPath.row].code
        cell.nameLbl.text = currentModuleArray[indexPath.row].name
        cell.backgroundColor = UIColor.getRandomColor(index:indexPath.row)
        checkSelect(code: cell.codeLbl.text!, cell: cell)
        //print("here is for the cell")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //to select the modules

    
    
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
    
 /*   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }
    
    //search bar in section header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDismension
    }
*/
    //set up the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentModuleArray = modulesArray
            table.reloadData()
            return
        }
        currentModuleArray = modulesArray.filter({ module -> Bool in
            module.code.lowercased().contains(searchText.lowercased()) || module.name.lowercased().contains(searchText.lowercased())
        })
        table.reloadData()
    }
    
    
    func checkSelect(code:String, cell:TableCell) {
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
                        print("done snapshot, \(documentID), \(code)")
                        let docRef = db.collection("users").document(documentID).collection("modules").document(code)
                        
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
