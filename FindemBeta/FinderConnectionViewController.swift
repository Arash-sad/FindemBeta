//
//  FinderConnectionViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 23/02/2016.
//  Copyright © 2016 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse

class FinderConnectionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    
    var trainer: Trainer?
    var isConnected = false
    var userImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Setup imageView and userImageView
        self.imageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.imageView.layer.borderWidth = 2.0
        self.imageView.layer.cornerRadius = self.imageView.frame.height / 2
        self.imageView.layer.masksToBounds = true
        self.userImageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.userImageView.layer.borderWidth = 2.0
        self.userImageView.layer.cornerRadius = self.userImageView.frame.height / 2
        self.userImageView.layer.masksToBounds = true
        
        //Setup Buttons
        self.messageButton.layer.cornerRadius = self.messageButton.frame.height / 3
        self.messageButton.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        self.messageButton.layer.borderWidth = 1.0
        self.goBackButton.layer.cornerRadius = self.goBackButton.frame.height / 3
        self.goBackButton.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        self.goBackButton.layer.borderWidth = 1.0
        
            if self.isConnected == true {
                self.connectionLabel.text = "You and \(trainer!.name) are already connected."
            }
            else {
                self.connectionLabel.text = "You and \(trainer!.name) are now connected."
            }
        self.trainer!.getPhoto({
            image in
            self.imageView.image = image
        })
        
        self.userImageView.image = userImage
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMessageButtonTapped(sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("navFinderMessages")
        let transition = CATransition()
        transition.type = kCATransitionFade
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.window?.setRootViewController(vc,transition: transition)
    }

    @IBAction func goBackButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
