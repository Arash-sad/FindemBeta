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

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var findTrainerButton: UIButton!
    @IBOutlet weak var profileDescriptionLabel: UILabel!
    @IBOutlet weak var findTrainerDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // Setup Profil and FindTrainer Buttons
        self.profileButton.layer.cornerRadius = self.profileButton.frame.height / 3
        self.findTrainerButton.layer.cornerRadius = self.profileButton.frame.height / 3
        self.profileButton.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        self.profileButton.layer.borderWidth = 1.0
        self.findTrainerButton.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        self.findTrainerButton.layer.borderWidth = 1.0
        
        // Add Blur Visual Effect on top of backgroundImageView
        let blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = self.view.frame
        effectView.alpha = 0
        self.backgroundImageView.addSubview(effectView)
        
        // First animation
        UIView.animateWithDuration(2.5, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            
            effectView.alpha = 0.8
            
            }){ (finish:Bool) -> Void in
                UIView.animateWithDuration(2.0, animations: {
                    // Second animation
                    let drawLineView = DrawSeperationLineView()
                    drawLineView.frame = self.view.frame
                    drawLineView.backgroundColor = UIColor.clearColor()
                    self.view.addSubview(drawLineView)
                    
                    self.view.bringSubviewToFront(self.profileButton)
                    self.view.bringSubviewToFront(self.findTrainerButton)
                    self.profileButton.alpha = 1.0
                    self.findTrainerButton.alpha = 1.0
                    
                    }){ (finish:Bool) -> Void in
                        UIView.animateWithDuration(2.0, animations: { () -> Void in
                            // Third animation
                            self.profileDescriptionLabel.alpha = 1.0
                            self.findTrainerDescriptionLabel.alpha = 1.0
                        })
                }
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
