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

struct kolodaReader {
    var name:String
    var type:String
    var status:Bool
}


struct Project {
    var name:String
    var organiser:String
    var description:String
    var roleNeeded: String
    var uid: String
    
    var dictionary:[String:Any] {
        return [
            "name": name,
            "organiser" : organiser,
            "description" : description,
            "roleNeeded": roleNeeded,
            "uid": uid
        ]
    }
    
}

struct ProjectDisp {
    var name:String
    var approval:Bool
    
    var dictionary:[String:Any] {
        return [
            "name": name,
            "approval": approval
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

struct Modules{
    var name:String
    var code:String
    var teammateNumber:Int
    
    var dictionary:[String:Any] {
        return [
            "name" : name,
            "code" : code,
            "teammateNumber": teammateNumber
        ]
    }
}

struct ContactStruct : Identifiable{
    var id:String
    var name:String
    var user2uid:String
    var user2type:String
    var user2Proj:String
}


struct ProfileInfo{
    var name:String
    var lastName:String
    var firstName:String
    var email:String
    var modules_taken:String
    var skills:String
    var major:String
    var uid:String
}

struct waitingListInfo{
    var name:String
    var major:String
    var uid:String
}

struct Profile {
    var lastname:String
    var firstname:String
    var email:String
    var modules_taken:String
    var skills:String
    var major:String
    var uid:String
    
    var dictionary:[String:Any] {
        return [
            "lastname" : lastname,
            "firstname" : firstname,
            "email" : email,
            "modules_taken": modules_taken,
            "skills":skills,
            "major":major,
            "uid":uid
        ]
    }
}


extension Project : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let organiser = dictionary["organiser"] as? String,
            let description = dictionary ["description"] as? String,
            let uid = dictionary["uid"] as? String,
            let roleNeeded = dictionary["roleNeeded"] as? String else {return nil}
        
        
        self.init(name: name, organiser: organiser, description: description, roleNeeded: roleNeeded, uid:uid)
    }
}

extension ProjectDisp : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let approval = dictionary["approval"] as? Bool else {return nil}
        self.init(name: name, approval: approval)
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

extension Profile : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let lastname = dictionary["lastname"] as? String,
            let firstname = dictionary["firstname"] as? String,
            let email = dictionary ["email"] as? String,
            let skills = dictionary["skills"] as? String,
            let modules_taken = dictionary["modules_taken"] as? String,
            let uid = dictionary["uid"] as? String,
            let major = dictionary["major"] as? String else {return nil}
        
        
        self.init(lastname: lastname, firstname: firstname, email:email, modules_taken:modules_taken, skills:skills, major:major, uid:uid)
    }
}

extension Modules: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let code = dictionary ["code"] as? String,
            let teammateNumber = dictionary["teammateNumber"] as? Int else {return nil}
        
        
        self.init(name: name, code: code, teammateNumber: teammateNumber)
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
