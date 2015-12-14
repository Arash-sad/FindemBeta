//
//  TrainerHomeViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 2/11/2015.
//  Copyright (c) 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse

class TrainerHomeViewController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
//    Find the way to have below lines under viewDidLoad
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBarButtonItem(sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StartUpVC")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func profileButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("showProfileSegue", sender: nil)
    }
    @IBAction func MessagesButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("showMessagesSegue", sender: nil)
    }
    @IBAction func settingsButtonPressed(sender: UIButton) {
    }
    
}
