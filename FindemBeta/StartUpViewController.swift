//
//  StartUpViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 2/11/2015.
//  Copyright (c) 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse

class StartUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func profileButtonPressed(sender: UIButton) {
        pageToGo = "Trainer"
        if currentUser() != nil {
            performSegueWithIdentifier("TrainerHomeSegue", sender: nil)
        }
        else {
            performSegueWithIdentifier("LoginSegue", sender: nil)
        }
    }

    @IBAction func FindemButtonPressed(sender: UIButton) {
        pageToGo = "Findem"
        if currentUser() != nil {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FinderHomeNavController")
            self.presentViewController(vc, animated: true, completion: nil)
        }
        else {
            performSegueWithIdentifier("LoginSegue", sender: nil)
        }
    }
}
