//
//  ModulesViewController.swift
//  TeamUp!
//
//  Created by Alicia Ho on 29/5/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit

class ModulesViewController: UIViewController {
    
    var module: [Module] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        module = createArray()
    }

    func createArray() -> [Module] {
        var tempMods: [Module] = []
        
        let mod1 = Module(Image: interview-app , Title:"CG1112")
        let mod2 = Module(Image: int-overview, Title: "EE2026" )
        
        tempMods.append(mod1)
        tempMods.append(mod2)
        
        return tempMods
        
    }
}

    extension ModulesViewController: UITableViewDataSource, UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return module.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let mod = module[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ModuleTableViewCell") as! ModuleTableViewCell
            
            cell.setMod(mod: mod)
            
            return cell
        }
}

