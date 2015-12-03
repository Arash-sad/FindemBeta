//
//  TrainerOtherViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 19/11/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse

class TrainerOtherViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var yearsTextField: UITextField!
    @IBOutlet weak var achievementsTextView: UITextView!
    @IBOutlet weak var favoriteTextField: UITextField!
    @IBOutlet weak var charactersLabel: UILabel!
    
    var years:String?
    var achievements:String?
    var favorite:String?
    var charCount = 0
    let maxLength = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        yearsTextField.text = self.years
        achievementsTextView.delegate = self
        achievementsTextView.text = self.achievements
        favoriteTextField.text = self.favorite
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBarButtonItem(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

 
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveBarButtonItem === sender {
            self.years = yearsTextField.text
            self.achievements = achievementsTextView.text
            self.favorite = favoriteTextField.text
            
            //Save Years Experience, Achievements, and Favorite to Parse
            let user = PFUser.currentUser()
            user!.setObject(self.years!, forKey: "yearsExperience")
            user!.setObject(self.achievements!, forKey: "achievements")
            user!.setObject(self.favorite!, forKey: "favorite")
            user!.saveInBackgroundWithBlock(nil)
        }
    }
    
    // MARK: - UITextViewDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // Live characters counting
        if text == "" // Check backspace
        {
            if textView.text.characters.count == 0
            {
                charCount = 0
                charactersLabel.text = String(format: "%i Character(s) left",maxLength - charCount)
            }
            charCount = (textView.text.characters.count - 1)
            charactersLabel.text = String(format: "%i Character(s) left",maxLength - charCount)
        }
        else
        {
            charCount = (textView.text.characters.count + 1)
            charactersLabel.text = String(format: "%i Character(s) left",maxLength - charCount)
            
            if charCount >= maxLength + 1
            {
                charCount = maxLength
                charactersLabel.text = String(format: "%i Character(s) left",maxLength - charCount)
            }
        }
        
        return achievementsTextView.text.characters.count + (text.characters.count - range.length)
            <= maxLength
    }
    

}
