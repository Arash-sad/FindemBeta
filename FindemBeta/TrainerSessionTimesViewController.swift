//
//  TrainerSessionTimesViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 14/01/2016.
//  Copyright © 2016 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse

protocol TrainerSessionTimesViewControllerDelegate {
    func saveSessionTimes(sessions: String)
}

class TrainerSessionTimesViewController: UIViewController {

    @IBOutlet weak var morningsWDButton: UIButton!
    @IBOutlet weak var afternoonsWDButton: UIButton!
    @IBOutlet weak var eveningsWDButton: UIButton!
    @IBOutlet weak var morningsWEButton: UIButton!
    @IBOutlet weak var afternoonsWEButton: UIButton!
    @IBOutlet weak var eveningsWEButton: UIButton!
    
    var sessionTimes:String?
    var char:Character?
    var tempSessionTimes = "ABC"
    var delegate: TrainerSessionTimesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.sessionTimes != "" {
            self.tempSessionTimes = self.sessionTimes!
        }

        if tempSessionTimes.uppercaseString.characters.contains("A") {
            morningsWDButton.selected = true
        }
        if tempSessionTimes.uppercaseString.characters.contains("B") {
            afternoonsWDButton.selected = true
        }
        if tempSessionTimes.uppercaseString.characters.contains("C") {
            eveningsWDButton.selected = true
        }
        if tempSessionTimes.uppercaseString.characters.contains("X") {
            morningsWEButton.selected = true
        }
        if tempSessionTimes.uppercaseString.characters.contains("Y") {
            afternoonsWEButton.selected = true
        }
        if tempSessionTimes.uppercaseString.characters.contains("Z") {
            eveningsWEButton.selected = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBarButtonItemTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func saveBarButtonItemTapped(sender: UIBarButtonItem) {
        if let delegate = self.delegate {
            delegate.saveSessionTimes(self.tempSessionTimes)
        }
        //MARK: Save Session Times to Parse
        let user = PFUser.currentUser()
        user!.setObject(self.tempSessionTimes, forKey: "sessionTimes")
        user!.saveInBackgroundWithBlock(nil)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func morningsWDButtonTapped(sender: UIButton) {
        morningsWDButton.selected = !morningsWDButton.selected
        char = "A"
        if morningsWDButton.selected == false {
        tempSessionTimes.removeAtIndex(tempSessionTimes.characters.indexOf("A")!)
        }
        else  {
            self.tempSessionTimes.append(char!)
        }
    }
    @IBAction func afternoonsWDButtonTapped(sender: UIButton) {
        afternoonsWDButton.selected = !afternoonsWDButton.selected
        char = "B"
        if afternoonsWDButton.selected == false {
        tempSessionTimes.removeAtIndex(tempSessionTimes.characters.indexOf("B")!)
        }
        else  {
            self.tempSessionTimes.append(char!)
        }
    }
    @IBAction func eveningsWDButtonTapped(sender: UIButton) {
        eveningsWDButton.selected = !eveningsWDButton.selected
        char = "C"
        if eveningsWDButton.selected == false {
        tempSessionTimes.removeAtIndex(tempSessionTimes.characters.indexOf("C")!)
        }
        else  {
            self.tempSessionTimes.append(char!)
        }
    }
    @IBAction func morningsWEButtonTapped(sender: UIButton) {
        morningsWEButton.selected = !morningsWEButton.selected
        char = "X"
        if morningsWEButton.selected == false {
        tempSessionTimes.removeAtIndex(tempSessionTimes.characters.indexOf("X")!)
        }
        else  {
            self.tempSessionTimes.append(char!)
        }
    }
    @IBAction func afternoonsWEButtonTapped(sender: UIButton) {
        afternoonsWEButton.selected = !afternoonsWEButton.selected
        char = "Y"
        if afternoonsWEButton.selected == false {
        tempSessionTimes.removeAtIndex(tempSessionTimes.characters.indexOf("Y")!)
        }
        else  {
            self.tempSessionTimes.append(char!)
        }
    }
    @IBAction func eveningsWEButtonTapped(sender: UIButton) {
        eveningsWEButton.selected = !eveningsWEButton.selected
        char = "Z"
        if eveningsWEButton.selected == false {
        tempSessionTimes.removeAtIndex(tempSessionTimes.characters.indexOf("Z")!)
        }
        else  {
            self.tempSessionTimes.append(char!)
        }
    }

}
