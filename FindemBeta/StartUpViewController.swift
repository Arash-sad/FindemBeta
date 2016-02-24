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

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var findTrainerButton: UIButton!
    @IBOutlet weak var profileDescriptionLabel: UILabel!
    @IBOutlet weak var findTrainerDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // First animation
        UIView.animateWithDuration(2.0, delay: 0.3, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.profileButton.alpha = 1.0
            self.findTrainerButton.alpha = 1.0
            }){ (finish:Bool) -> Void in
                UIView.animateWithDuration(2.0, animations: { () -> Void in
                    // Second animation
                    self.profileDescriptionLabel.alpha = 1.0
                    self.findTrainerDescriptionLabel.alpha = 1.0
                })
        }
        
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

    @IBAction func findTrainerButtonPressed(sender: UIButton) {
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
