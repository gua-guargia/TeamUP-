//
//  TableCell.swift
//  TeamUp!
//
//  Created by apple on 6/26/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {

    @IBOutlet var codeLbl: UILabel!
    
    @IBOutlet var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
