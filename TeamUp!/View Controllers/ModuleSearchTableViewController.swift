//
//  ModuleSearchTableViewController.swift
//  TeamUp!
//
//  Created by apple on 6/23/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import FirebaseDatabase
//try

class ModuleSearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        //update the search result
        filterContent(searchText: self.searchController.searchBar.text!)
    }
    

    @IBOutlet var ModulesTableView: UITableView!
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var modulesArray = [NSDictionary?]()
    var filterModules = [NSDictionary?]()
    
    var databaseRef = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        databaseRef.child("NUS modules").queryOrdered(byChild: "code").observe(.childAdded, with: { (snapshot) in
            self.modulesArray.append(snapshot.value as? NSDictionary)
            //insert the rows
            self.ModulesTableView.insertRows(at: [IndexPath(row:self.modulesArray.count-1,section:0)], with: UITableView.RowAnimation.automatic)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            return filterModules.count
        }
        return self.modulesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let module : NSDictionary?
        if searchController.isActive && searchController.searchBar.text != "" {
            module = filterModules[indexPath.row]
        }
        else{
            module = self.modulesArray[indexPath.row]
        }
        cell.textLabel?.text = module?["code"] as? String
        cell.detailTextLabel?.text = module?["name"] as? String

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func dismissModuleSearch(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func filterContent(searchText:String)
    {
        self.filterModules = self.modulesArray.filter{ module in
            let moduleCode = module!["code"] as? String
            return(moduleCode?.lowercased().contains(searchText.lowercased()))!
        }
        tableView.reloadData()
    }
    
}
