//
//  FinderSearchViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 23/11/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse

@objc protocol FinderSearchViewControllerDelegate {
    optional func toggleRightPanel()
}

class FinderSearchViewController: UIViewController, FinderSlideOutMenuViewControllerDelegate {

    var delegate: FinderSearchViewControllerDelegate?
    
    //TEMP
//    var nameArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backBarButtonItemPressed(sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StartUpVC")
        self.presentViewController(vc, animated: true, completion: nil)
    }

    @IBAction func MenuBarButtonItemPressed(sender: UIBarButtonItem) {
        if let d = delegate {
            d.toggleRightPanel?()
        }
    }

    @IBAction func searchButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("showSearchResult", sender: nil)
    }

}

