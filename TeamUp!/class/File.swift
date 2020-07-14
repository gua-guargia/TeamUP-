//
//  File.swift
//  TeamUp!
//
//  Created by Alicia Ho on 30/5/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol DocumentSerializable  {
    init?(dictionary:[String:Any])
}


struct Project {
    var Name:String
    var Organiser:String
    var Description:String
    var Role: String
    
    var dictionary:[String:Any] {
        return [
            "Name": Name,
            "Organiser" : Organiser,
            "Description" : Description,
            "Role": Role
        ]
    }
    
}

struct Competition {
    var Name:String
    var Organiser:String
    var Description:String
    var WebLink: String
    
    var dictionary:[String:Any] {
        return [
            "Name": Name,
            "Organiser" : Organiser,
            "Description" : Description,
            "WebLink": WebLink
        ]
    }
    
}

struct ModulesStruct : Identifiable{
    var id:String
    var name:String
    var code:String
    var teammateNumber:String
}

struct ProfileInfo{
    var name:String
    var lastName:String
    var firstName:String
    var email:String
    var modules_taken:String
    var skills:String
    var major:String
}

extension Project : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let Name = dictionary["Name"] as? String,
            let Organiser = dictionary["Organiser"] as? String,
            let Description = dictionary ["Description"] as? String,
            let Role = dictionary["role"] as? String else {return nil}
        
        
        self.init(Name: Name, Organiser: Organiser, Description: Description, Role: Role)
    }
}


extension Competition : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let Name = dictionary["Name"] as? String,
            let Organiser = dictionary["Organiser"] as? String,
            let Description = dictionary ["Description"] as? String,
            let WebLink = dictionary["WebLink"] as? String else {return nil}
        
        
        self.init(Name: Name, Organiser: Organiser, Description: Description, WebLink: WebLink)
    }
}

extension UIColor {
    class func getRandomColor(index: Int) -> UIColor {
        let c1 = UIColor.init(red: 133/255, green: 190/255, blue: 176/255, alpha: 1)
        let c2 = UIColor.init(red: 122/255, green: 187/255, blue: 196/255, alpha: 1)
        let c3 = UIColor.init(red: 109/255, green: 189/255, blue: 165/255, alpha: 1)
        let c4 = UIColor.init(red: 181/255, green: 230/255, blue: 218/255, alpha: 1)
        let c5 = UIColor.init(red: 180/255, green: 165/255, blue: 226/255, alpha: 1)
        let c6 = UIColor.init(red: 250/255, green: 126/255, blue: 126/255, alpha: 1)
        let c7 = UIColor.init(red: 246/255, green: 167/255, blue: 167/255, alpha: 1)
        let c8 = UIColor.init(red: 248/255, green: 180/255, blue: 204/255, alpha: 1)
        let c9 = UIColor.init(red: 177/255, green: 209/255, blue: 133/255, alpha: 1)
        let c10 = UIColor.init(red: 239/255, green: 214/255, blue: 156/255, alpha: 1)
        let colors = [c3, c1, c4, c2, c5, c6, c7, c8, c9, c10]
        
        return colors[index%10]
    }
    
}
