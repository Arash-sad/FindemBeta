//
//  FinderSlideOutMenuViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 23/11/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit

protocol FinderSlideOutMenuViewControllerDelegate {
    //  e.g. func chartSelected(parameters: Parameters)
}

class FinderSlideOutMenuViewController: UIViewController {

    var delegate: FinderSlideOutMenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
