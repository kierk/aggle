//
//  CustomCell.swift
//  aggle
//
//  Created by Max Li on 4/24/16.
//  Copyright © 2016 Aggle. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var descrip: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var pic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
