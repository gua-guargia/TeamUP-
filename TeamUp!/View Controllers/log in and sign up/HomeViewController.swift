//
//  HomeViewController.swift
//  TeamUp!
//
//  Created by apple on 7/10/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var signinButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }
    
    func setUpElements() {
        
        Utilities.styleFilledButton(signinButton)
        Utilities.styleHollowButton(loginButton)
    }

}
