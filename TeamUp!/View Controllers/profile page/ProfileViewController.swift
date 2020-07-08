//
//  ProfileViewController.swift
//  TeamUp!
//
//  Created by apple on 6/30/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import InitialsImageView
import FirebaseFirestore
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController{

    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var courseLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var skillsLabel: UILabel!
    
    @IBOutlet weak var modulesTakenLabel: UILabel!
    
    var profileInfo = [ProfileInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //to get the name information
        
        var CURRENT_USER_UID: String? {
            if let currentUserUid = Auth.auth().currentUser?.uid {
                return currentUserUid
            }
            return nil
        }
        
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isEqualTo: CURRENT_USER_UID!).getDocuments() { (querySnapshot, error) in
            self.profileInfo.removeAll()
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                for i in querySnapshot!.documents {
                    let lastName = i.get("lastname") as! String
                    let firstName = i.get("firstname") as! String
                    let major = i.get("major") as! String
                    let email = i.get("email") as! String
                    let skills = i.get("skills") as! String
                    let modules_taken = i.get("modules_taken") as! String
                    let name = firstName + " " + lastName
                    self.profileInfo.append(ProfileInfo(name: name, lastName: lastName, firstName: firstName, email: email, modules_taken: modules_taken,skills: skills, major: major))
                    print("done snapshot, \(firstName), \(lastName)")
                }
            }
        }
        
        // Do any additional setup after loading the view.
      //  profileImage = UIImageView.init(frame: CGRect(x: self.view.bounds.midX - 40, y: self.view.bounds.midY - 80 - 40, width: 80, height: 80))
        profileImage.setImageForName(profileInfo[0].name, backgroundColor: UIColor.black, circular: true, textAttributes: nil, gradient: false)
        courseLabel.text = profileInfo[0].major
        emailLabel.text = profileInfo[0].email
        skillsLabel.text = profileInfo[0].skills
        modulesTakenLabel.text = profileInfo[0].modules_taken
        userNameLabel.text = profileInfo[0].name
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
