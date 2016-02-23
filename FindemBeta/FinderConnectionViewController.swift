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
    
    var trainer: PFUser?
    var isConnected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Setup imageView
        self.imageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.imageView.layer.borderWidth = 2.0
        self.imageView.layer.cornerRadius = self.imageView.frame.height / 2
        self.imageView.layer.masksToBounds = true
        
        if let name = self.trainer!.objectForKey("firstName") as? String {
            if self.isConnected == true {
                self.connectionLabel.text = "You and \(name) are already connected."
            }
            else {
                self.connectionLabel.text = "You and \(name) are now connected."
            }
        }
        let imageFile = self.trainer!.objectForKey("picture") as? PFFile
        imageFile!.getDataInBackgroundWithBlock({
            data, error in
            if let data = data {
                self.imageView.image = UIImage(data: data)!
            }
        })
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
