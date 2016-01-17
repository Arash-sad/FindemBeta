//
//  SeventhTableViewCell.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 14/01/2016.
//  Copyright © 2016 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit

class SeventhTableViewCell: UITableViewCell {

    @IBOutlet weak var morningsWD: UILabel!
    @IBOutlet weak var afternoonsWD: UILabel!
    @IBOutlet weak var eveningsWD: UILabel!
    @IBOutlet weak var morningsWE: UILabel!
    @IBOutlet weak var afternoonsWE: UILabel!
    @IBOutlet weak var eveningsWE: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
