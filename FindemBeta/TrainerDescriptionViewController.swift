//
//  TrainerDescriptionViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 18/11/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse

class TrainerDescriptionViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var shortDescriptionTextView: UITextView!
    @IBOutlet weak var shortDescCharCountLabel: UILabel!
    @IBOutlet weak var longDescriptionTextView: UITextView!
    @IBOutlet weak var longDescCharCountLabel: UILabel!
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!

    
    var shortDescription:String?
    var longDescription:String?
    var shortDescCharCount = 0
    let shortDescMaxLength = 150
    var longDescCharCount = 0
    let longDescMaxLength = 500
    var isSecondKeyboardUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        shortDescriptionTextView.delegate = self
        shortDescriptionTextView.text = self.shortDescription
        longDescriptionTextView.delegate = self
        longDescriptionTextView.text = self.longDescription
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
            self.shortDescription = shortDescriptionTextView.text
            self.longDescription = longDescriptionTextView.text
            
            //MARK: Save Description to Parse
            let user = PFUser.currentUser()
            user!.setObject(self.shortDescription!, forKey: "shortDescription")
            user!.setObject(self.longDescription!, forKey: "longDescription")
            user!.saveInBackgroundWithBlock(nil)
        }
    }

   
    // MARK: - UITextViewDelegate    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView == longDescriptionTextView {
            isSecondKeyboardUp = true
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.bottomMargin.constant += 80
            })
        }
        if textView == shortDescriptionTextView {
            if self.isSecondKeyboardUp == true {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.bottomMargin.constant -= 80
                    self.isSecondKeyboardUp = false
                })
            }
        }
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        var returnValue = true
        
        // Live characters counting for textViews
        if textView == shortDescriptionTextView {
            if text == "" // Check backspace
            {
                if textView.text.characters.count == 0
                {
                    shortDescCharCount = 0
                    shortDescCharCountLabel.text = String(format: "%i Character(s) left",shortDescMaxLength - shortDescCharCount)
                }
                shortDescCharCount = (textView.text.characters.count - 1)
                shortDescCharCountLabel.text = String(format: "%i Character(s) left",shortDescMaxLength - shortDescCharCount)
            }
            else
            {
                shortDescCharCount = (textView.text.characters.count + 1)
                shortDescCharCountLabel.text = String(format: "%i Character(s) left",shortDescMaxLength - shortDescCharCount)
                
                if shortDescCharCount >= shortDescMaxLength + 1
                {
                    shortDescCharCount = shortDescMaxLength
                    shortDescCharCountLabel.text = String(format: "%i Character(s) left",shortDescMaxLength - shortDescCharCount)
                }
            }
            
            returnValue = shortDescriptionTextView.text.characters.count + (text.characters.count - range.length)
                <= shortDescMaxLength
        }
        if textView == longDescriptionTextView {
//            UIView.animateWithDuration(0.4, animations: { () -> Void in
//                self.bottomMargin.constant -= 300
//                })
            if text == "" // Check backspace
            {
                if textView.text.characters.count == 0
                {
                    longDescCharCount = 0
                    longDescCharCountLabel.text = String(format: "%i Character(s) left",longDescMaxLength - longDescCharCount)
                }
                longDescCharCount = (textView.text.characters.count - 1)
                longDescCharCountLabel.text = String(format: "%i Character(s) left",longDescMaxLength - longDescCharCount)
            }
            else
            {
                longDescCharCount = (textView.text.characters.count + 1)
                longDescCharCountLabel.text = String(format: "%i Character(s) left",longDescMaxLength - longDescCharCount)
                
                if longDescCharCount >= longDescMaxLength + 1
                {
                    longDescCharCount = longDescMaxLength
                    longDescCharCountLabel.text = String(format: "%i Character(s) left",longDescMaxLength - longDescCharCount)
                }
            }
            
            returnValue = longDescriptionTextView.text.characters.count + (text.characters.count - range.length)
                <= longDescMaxLength
        }
     return returnValue
    }
    // MARK: - Tap Gesture
    @IBAction func tapGesture(sender: UITapGestureRecognizer) {
        self.shortDescriptionTextView.resignFirstResponder()
        self.longDescriptionTextView.resignFirstResponder()
            if self.isSecondKeyboardUp == true {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.bottomMargin.constant -= 80
                    self.isSecondKeyboardUp = false
                })
            }
    }
    
}
