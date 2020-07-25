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
    var organiserUID = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        if(addButton.title(for: UIControl.State()) == "selected"){
            print("selected already")
            return
        }
        else {
            addButton.setTitle("selected", for: UIControl.State())
            let db = Firestore.firestore()
            //update the selected modules
            var CURRENT_USER_UID: String? {
                if let currentUserUid = Auth.auth().currentUser?.uid {
                    return currentUserUid
                }
                return nil
            }
            
            let organiser = self.organiserLbl.text!
            let name = self.nameLbl.text!
            
            var lastName = ""
            var firstName = ""
            var major = ""
            var email = ""
            var modules_taken = ""
            var skills = ""
            
            db.collection("users").document(Auth.auth().currentUser?.uid ?? "").getDocument{ (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error.localizedDescription)")
                    return
                }
                guard let snap = querySnapshot else {return}
                lastName = snap.get("lastname") as? String ?? "no lastname"
                firstName = snap.get("firstname") as? String ?? "no firstname"
                major = snap.get("major") as? String ?? "no major"
                email = snap.get("email") as? String ?? "no email"
                skills = snap.get("skills") as? String ?? "no skills"
                modules_taken = snap.get("modules_taken") as? String ?? "no modules taken"
            }
            
            //update the info about modules in user
            db.collection("users").document(CURRENT_USER_UID ?? "").collection("individualParticipant").document(name).setData(["name": name, "organiser": organiser]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            
            //uodate the info about students in modules
            db.collection("projects").whereField("name", isEqualTo: name).getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error.localizedDescription)")
                } else {
                    for i in querySnapshot!.documents {
                        let id = i.documentID
                        self.documentIDCode = id
                        print("done snapshot, \(self.documentIDCode)")
                        db.collection("projects").document(self.documentIDCode).collection("waitingList").document(CURRENT_USER_UID!).setData([
                            "uid": CURRENT_USER_UID!, "major": major, "firstname": firstName, "lastname":lastName,"major":major,"email":email,"modules_taken":modules_taken,"skills":skills]) { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                } else {
                                    print("Document successfully written!")
                                }
                        }
                        db.collection("users").document(CURRENT_USER_UID ?? "").getDocument{ (querySnapshot, error) in
                            if let error = error {
                                print("Error getting documents: \(error.localizedDescription)")
                                return
                            }
                            guard let snap = querySnapshot else {return}
                            let lastName = snap.get("lastname") as? String ?? "no lastname"
                            let firstName = snap.get("firstname") as? String ?? "no firstname"
                            let username = firstName + " " + lastName
                            db.collection("users").document(self.organiserUID).collection("waitingList").addDocument(data: ["id":CURRENT_USER_UID ?? "", "name": username ,"teamname":name, "type": "project"] )
                        }
                    }
                }
            }
            
        }
    }
    
}
