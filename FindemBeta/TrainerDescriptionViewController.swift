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
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var charactersLabel: UILabel!
    
    var descriptionString:String?
    var charCount = 0
    let maxLength = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        descriptionTextView.delegate = self
        descriptionTextView.becomeFirstResponder()
        descriptionTextView.text = self.descriptionString
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
            self.descriptionString = descriptionTextView.text
            
            //MARK: Save Description to Parse
            
            let user = PFUser.currentUser()
            user!.removeObjectForKey("description")
            user!.setObject(self.descriptionString!, forKey: "description")
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
        
        return descriptionTextView.text.characters.count + (text.characters.count - range.length)
            <= maxLength
    }
    
}
