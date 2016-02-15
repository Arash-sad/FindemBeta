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
    @IBOutlet weak var yearsLabel: UILabel!
    @IBOutlet weak var achievementsTextView: UITextView!
    @IBOutlet weak var charactersLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var years:Int?
    var achievements:String?
    var charCount = 0
    let maxLength = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // hide keyboard if tap on screen
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGestureRecognizer:")
        view.addGestureRecognizer(tapGestureRecognizer)

        
        if self.years == 0 {
            yearsLabel.text = "Less than a year"
        }
        else if self.years == 1 {
            yearsLabel.text = "1 year"
        }
        else {
            yearsLabel.text = ("\(self.years!) years")
        }
        achievementsTextView.delegate = self
        achievementsTextView.text = self.achievements
        stepper.value = Double(self.years!)
        stepper.minimumValue = 0
        stepper.maximumValue = 99
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBarButtonItem(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveBarButtonItem(sender: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("unwindSegueFromOther", sender: saveBarButtonItem)
    }
    @IBAction func stepperValueChanged(sender: UIStepper) {
        if Int(sender.value) == 0 {
            yearsLabel.text = "Less than a year"
        }
        else if Int(sender.value) == 1 {
            yearsLabel.text = "1 year"
        }
        else {
            yearsLabel.text = ("\(Int(sender.value).description) years")
        }
        self.years = Int(sender.value)
    }
 
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveBarButtonItem === sender {
            self.achievements = achievementsTextView.text
            
            //Save Years Experience, Achievements, and Favorite to Parse
            let user = PFUser.currentUser()
            user!.setObject(self.years!, forKey: "yearsExperience")
            user!.setObject(self.achievements!, forKey: "achievements")
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
    
    // MARK: Custom Tap method implementation
    func handleTapGestureRecognizer(tapGestureRecognizer: UITapGestureRecognizer) {
        achievementsTextView.resignFirstResponder()
    }

}
