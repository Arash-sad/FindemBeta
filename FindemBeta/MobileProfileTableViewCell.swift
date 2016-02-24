//
//  MobileProfileTableViewCell.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 24/02/2016.
//  Copyright © 2016 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit

class MobileProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
