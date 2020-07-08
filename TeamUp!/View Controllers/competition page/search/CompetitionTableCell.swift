//
//  CompetitionTableCell.swift
//  TeamUp!
//
//  Created by apple on 7/8/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit

class CompetitionTableCell: UITableViewCell {

    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var webLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var organiserLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
