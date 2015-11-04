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

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
//    Find the way to have below lines under viewDidLoad
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        nameLabel.hidden = false
        imageView.hidden = false
        nameLabel.text = currentUser()?.name
        currentUser()?.getPhoto({
            image in
            self.imageView.layer.masksToBounds = true
            self.imageView.contentMode = .ScaleAspectFill
            self.imageView.image = image
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBarButtonItem(sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StartUpVC") as? UIViewController
        self.presentViewController(vc!, animated: true, completion: nil)
    }

    @IBAction func logOutBarButtonItem(sender: UIBarButtonItem) {
        logOutAlertView()
        
    }
    
    //Log out AlertView
    func logOutAlertView() {
        let logOutAlertController = UIAlertController(title: "Logging out", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.Alert)
        logOutAlertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (logOutAlertController) -> Void in
            //Logging out user from Facebook account
            PFUser.logOut()
            //Go to the StartUpViewController
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StartUpVC") as? UIViewController
            self.presentViewController(vc!, animated: true, completion: nil)
        }))
        logOutAlertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(logOutAlertController, animated: true, completion: nil)
    }
}
