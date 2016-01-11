//
//  FifthTableViewCell.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 18/11/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit

class FifthTableViewCell: UITableViewCell {

    @IBOutlet weak var shortDescriptionTextView: UITextView!
    @IBOutlet weak var longDescriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
