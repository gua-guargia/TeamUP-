//
//  ProjectTableCell.swift
//  TeamUp!
//
//  Created by apple on 7/8/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ProjectTableCell: UITableViewCell {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var organiserLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var roleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    var documentID = ""
    var documentIDCode = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addTapped(_ sender: UIButton) {
        if(addButton.title(for: UIControl.State()) == "+"){
            print("selected already")
            return
        }
        else {
            addButton.setTitle("selected", for: UIControl.State())
        
            //update the selected modules
            var CURRENT_USER_UID: String? {
                if let currentUserUid = Auth.auth().currentUser?.uid {
                    return currentUserUid
                }
                return nil
            }
        
            let organiser = self.organiserLbl.text!
            let name = self.nameLbl.text!
        
            //update the info about modules in user
            let db = Firestore.firestore()
            db.collection("users").whereField("uid", isEqualTo: CURRENT_USER_UID!).getDocuments() { (querySnapshot, error) in
                if let error = error {
                     print("Error getting documents: \(error.localizedDescription)")
                 } else {
                     for i in querySnapshot!.documents {
                        let id = i.documentID
                        self.documentID = id
                        print("modules added for \(self.documentID)")
                        //should add the second query into the first query, so that it can run in series, instead of parallel. if it runs in parallel manner, it will come across the problem which the documentID is still empty.
                        let docRef = db.collection("users")
                        docRef.document(self.documentID).collection("individualParticipant").document(name).setData(["name": name, "organiser": organiser]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                     }
                }
        }
        
        //uodate the info about students in modules
        db.collection("projects").whereField("Name", isEqualTo: name).getDocuments() { (querySnapshot, error) in
                 if let error = error {
                     print("Error getting documents: \(error.localizedDescription)")
                 } else {
                     for i in querySnapshot!.documents {
                        let id = i.documentID
                        self.documentIDCode = id
                        print("done snapshot, \(self.documentIDCode)")
                        db.collection("projects").document(self.documentIDCode).collection("paticipant").document(CURRENT_USER_UID!).setData([
                            "uid": CURRENT_USER_UID!]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                     }
                }
            }
        }
    }
    
}
