//
//  ProjectTableCell.swift
//  TeamUp!
//
//  Created by apple on 7/8/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit

class ProjectTableCell: UITableViewCell {

    @IBOutlet weak var organiserLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var roleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
