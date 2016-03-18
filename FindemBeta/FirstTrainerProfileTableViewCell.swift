//
//  FirstTrainerProfileTableViewCell.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 2/03/2016.
//  Copyright © 2016 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit

class FirstTrainerProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var trainingTypesTextView: UITextView!
    @IBOutlet weak var qualificationsTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var achievementsTextView: UITextView!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var weekdaysLabel: UILabel!
    @IBOutlet weak var weekendsLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var specLabel: UILabel!
    @IBOutlet weak var quaLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var achLabel: UILabel!
    @IBOutlet weak var sesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
