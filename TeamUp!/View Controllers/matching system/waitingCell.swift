//
//  waitingCell.swift
//  TeamUp!
//
//  Created by apple on 7/22/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
/*
class waitingCell: UITableViewCell {

    @IBOutlet weak var majorLbl: UILabel!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func addTaped(_ sender: UIButton) {
        if(addButton.title(for: UIControl.State()) != "+"){
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
        
            
            let name = self.nameLbl.text!
            let major = self.majorLbl.text!
        
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
                        docRef.document(self.documentID).collection("modules").document(code).setData(["name": name, "code": code]) { err in
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
        db.collection("NUS modules").whereField("code", isEqualTo: code).getDocuments() { (querySnapshot, error) in
                 if let error = error {
                     print("Error getting documents: \(error.localizedDescription)")
                 } else {
                     for i in querySnapshot!.documents {
                        let id = i.documentID
                        self.documentIDCode = id
                        print("done snapshot, \(self.documentIDCode)")
                        db.collection("NUS modules").document(self.documentIDCode).collection("students").document(CURRENT_USER_UID!).setData([
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
    
}*/
