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
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var findClientsLabel: UILabel!
    @IBOutlet weak var findTrainerLabel: UILabel!
    
    let topView = UIView()
    let bottomView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Add Blur Visual Effect on top of backgroundImageView
//        let blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
//        let effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
//        effectView.frame = self.view.frame
//        effectView.alpha = 0
//        self.backgroundImageView.addSubview(effectView)

        
        // First animation
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            
            let drawLineView = DrawSeperationLineView()
            drawLineView.frame = self.view.frame
            drawLineView.backgroundColor = UIColor.clearColor()
            self.view.addSubview(drawLineView)
            // Bring stackView to front (tap on buttons work fine)
            self.view.bringSubviewToFront(self.buttonsStackView)
            self.view.bringSubviewToFront(self.view)
            self.profileButton.alpha = 1.0
            self.findTrainerButton.alpha = 1.0
            
        }){ (finish:Bool) -> Void in
            UIView.animateWithDuration(0.4, animations: {
                // Second animation
                self.findClientsLabel.alpha = 1.0
                self.findTrainerLabel.alpha = 1.0
                
            }){ (finish:Bool) -> Void in
                UIView.animateWithDuration(0.4, animations: {
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
