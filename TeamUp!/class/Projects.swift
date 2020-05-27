//
//  Projects.swift
//  TeamUp!
//
//  Created by Alicia Ho on 26/5/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import Foundation

class Project{
    var Picture: String
    var Name: String
    var Organiser: String
    var Description: String
    
    init(Picture: String, Name: String, Organiser: String, Description: String) {
        self.Picture = Picture
        self.Name = Name
        self.Organiser = Organiser
        self.Description = Description
    }
}
