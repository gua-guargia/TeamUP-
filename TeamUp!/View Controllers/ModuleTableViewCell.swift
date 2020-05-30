//
//  ModuleTableViewCell.swift
//  TeamUp!
//
//  Created by Alicia Ho on 29/5/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit

class ModuleTableViewCell: UITableViewCell {

    @IBOutlet weak var ModTitle: UILabel!
    @IBOutlet weak var ModImageView: UIImageView!
    
    func setMod(mod: Module) {
        modImageView.image = Module.Image
        modTitleLabel.text = Module.Title
    }
}
