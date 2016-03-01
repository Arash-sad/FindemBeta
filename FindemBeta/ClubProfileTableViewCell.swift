//
//  ClubProfileTableViewCell.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 8/02/2016.
//  Copyright © 2016 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit

class ClubProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var clubLabel: UILabel!
    @IBOutlet weak var firstAddressLabel: UILabel!
    @IBOutlet weak var secondAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
