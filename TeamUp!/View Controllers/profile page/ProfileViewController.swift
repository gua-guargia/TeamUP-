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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "").getDocument{ (querySnapshot, error) in
            self.profileInfo.removeAll()
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                return
            }
            guard let snap = querySnapshot else {return}
            //let data = i.data()
            //let lastName = data("lastname") as? String ?? "anoymous"
            let lastName = snap.get("lastname") as? String ?? "no lastname"
            let firstName = snap.get("firstname") as? String ?? "no firstname"
            let major = snap.get("major") as? String ?? "no major"
            let email = snap.get("email") as? String ?? "no email"
            let skills = snap.get("skills") as? String ?? "no skills"
            let modules_taken = snap.get("modules_taken") as? String ?? "no modules taken"
            let name = firstName + " " + lastName
            let newProfileInfo = ProfileInfo(name: name, lastName: lastName, firstName: firstName, email: email, modules_taken: modules_taken,skills: skills, major: major, uid: Auth.auth().currentUser?.uid ?? "")
            self.profileInfo.append(newProfileInfo)
            print("done snapshot, \(firstName), \(lastName)")
            self.setUpData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        //self.navigationItem.title = "Profile"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleAddContact))
        view.backgroundColor = .gray
        //self.setUpData()
    }
    
    //func
    @objc func handleAddContact() {
        let vc = storyboard?.instantiateViewController(identifier: "editProfile")as! EditProfileViewController
        vc.passInfo = profileInfo[0]
        self.navigationController?.pushViewController(vc, animated: true)
        print("done, I'm pushing the display module page")
    }
    
    //set up data
    private func setUpData() {
        courseLabel.text = self.profileInfo[0].major
        emailLabel.text = self.profileInfo[0].email
        skillsLabel.text = self.profileInfo[0].skills
        modulesTakenLabel.text = self.profileInfo[0].modules_taken
        userNameLabel.text = self.profileInfo[0].name
        profileImage.setImageForName(self.profileInfo[0].name, backgroundColor: UIColor.black, circular: true, textAttributes: nil, gradient: false)
        print("\(self.profileInfo)")
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
