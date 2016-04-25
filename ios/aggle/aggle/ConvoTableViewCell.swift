//
//  ConvoTableViewCell.swift
//  aggle
//
//  Created by Kolodenker, Eugene on 4/24/16.
//  Copyright © 2016 Aggle. All rights reserved.
//

import UIKit

class ConvoTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
