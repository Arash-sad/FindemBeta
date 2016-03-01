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
                
                // Set Expiration Date (used in In-App Purchases)
                user!.setObject(NSDate(), forKey: "expirationDate")
                // Set Session times (weekdays only)
                user!.setObject("ABC", forKey: "sessionTimes")
                
                let fbRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,gender,picture.type(large)"])
                fbRequest.startWithCompletionHandler({ (FBSDKGraphRequestConnection, result, error) -> Void in
                    
                    if (error == nil && result != nil) {
                        let facebookData = result as! NSDictionary //FACEBOOK DATA IN DICTIONARY
                        let firstName = (facebookData.objectForKey("first_name") as! String)
                        user!.setObject(firstName, forKey: "firstName")
                        
                        let gender = (facebookData.objectForKey("gender") as! String)
                        user!.setObject(gender, forKey: "gender")
                        
                        let pictureURL = ((facebookData["picture"] as! NSDictionary)["data"] as! NSDictionary) ["url"] as! String
                        let url = NSURL(string: pictureURL)
                        let session = NSURLSession.sharedSession()
                        let request = NSURLRequest(URL: url!)
                        //NSURLConnection.sendAsynchronousRequest deprecated in iOS9
                        let task = session.dataTaskWithRequest(request, completionHandler: {
                            (data, response, error) -> Void in
                                let imageFile = PFFile(name: "avatar.jpg", data: data!)
                                user!.setObject(imageFile, forKey: "picture")
                                user!.saveInBackgroundWithBlock(nil)
                        })
                        
                        task.resume()
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
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FinderHomeNavController")
                self.presentViewController(vc, animated: true, completion: nil)
            }
            
        })
    }

}
