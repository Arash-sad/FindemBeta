//
//  LoginViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 2/11/2015.
//  Copyright (c) 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Facebook Login
    @IBAction func facebookLoginButtonPressed(sender: UIButton) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "user_about_me", "user_birthday"], block: {
            user, error in
            if user == nil {
                print("Uh oh. The user cancelled the Facebook Login.")
                //TODO: Add an alert and then navigate back to StartUpViewController
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StartUpVC")
                
                self.presentViewController(vc, animated: true, completion: nil)
                return
            }
            else if user!.isNew {
                print("User signed up and logged in through Facebook!")
                
                let fbRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,picture.type(large)"])
                fbRequest.startWithCompletionHandler({ (FBSDKGraphRequestConnection, result, error) -> Void in
                    
                    if (error == nil && result != nil) {
                        let facebookData = result as! NSDictionary //FACEBOOK DATA IN DICTIONARY
                        let firstName = (facebookData.objectForKey("first_name") as! String)
                        user!.setObject(firstName, forKey: "firstName")
                        
                        let pictureURL = ((facebookData["picture"] as! NSDictionary)["data"] as! NSDictionary) ["url"] as! String
                        let url = NSURL(string: pictureURL)
                        let request = NSURLRequest(URL: url!)
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                            response, data, error in
                            
                            let imageFile = PFFile(name: "avatar.jpg", data: data!)
                            user!.setObject(imageFile, forKey: "picture")
                            user!.saveInBackgroundWithBlock(nil)
                        })
                    }
                    })
            }
            else {
                print("User logged in through Facebook!")
            }
            
            // Check which pageToGo
            if pageToGo == "Trainer" {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TrainerHomeNavController")
                
                self.presentViewController(vc, animated: true, completion: nil)
            }
            else if pageToGo == "Findem" {
                let vc = FinderContainerViewController()
                self.presentViewController(vc, animated: true, completion: nil)
            }
            
        })
    }

}
