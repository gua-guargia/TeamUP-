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
                return
            }
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
            self.setUpData()
        }
    }
    
    private func setUpData() {
        courseLabel.text = self.profileInfo[0].major
        emailLabel.text = self.profileInfo[0].email
        skillsLabel.text = self.profileInfo[0].skills
        modulesTakenLabel.text = self.profileInfo[0].modules_taken
        userNameLabel.text = self.profileInfo[0].name
        profileImage.setImageForName(self.profileInfo[0].name, backgroundColor: UIColor.black, circular: true, textAttributes: nil, gradient: false)
    }

    @IBAction func signOutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let homeController = HomeViewController()
            let homeNavigationController = UINavigationController(rootViewController: homeController)
            self.present(homeNavigationController, animated: true, completion: nil)
        }catch let err {
            print("Failed to sign out with error", err)
        }
    }
}
