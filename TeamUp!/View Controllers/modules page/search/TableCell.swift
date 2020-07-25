//
//  TableCell.swift
//  TeamUp!
//
//  Created by apple on 6/26/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class TableCell: UITableViewCell {
    
    @IBOutlet var codeLbl: UILabel!
    
    @IBOutlet var nameLbl: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    var documentID = ""
    var documentIDCode = ""
    var code = ""
    var name = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        //show selected
        if(addButton.title(for: UIControl.State()) != "+"){
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
            
            code = codeLbl.text as? String ?? ""
            name = nameLbl.text as? String ?? ""
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
                
                //uPdate the info about students in modules
                db.collection("NUS modules").document(self.code).collection("students").document(CURRENT_USER_UID ?? "").setData([
                    "uid": CURRENT_USER_UID!,
                    "major": major,
                    "firstname": firstName,
                    "lastname":lastName,
                    "email":email,
                    "modules_taken":modules_taken,
                    "skills":skills]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                }
            }
            
            //update the info about modules in user
            db.collection("users").document(CURRENT_USER_UID ?? "").collection("modules").document(code).setData(["name": name, "code": code]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
    }
    
}
