//
//  SecondTrainerProfileTableViewCell.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 2/03/2016.
//  Copyright © 2016 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit

class SecondTrainerProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var clubNameLabel: UILabel!
    @IBOutlet weak var clubAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var clubDetailLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
