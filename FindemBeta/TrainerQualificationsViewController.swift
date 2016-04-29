//
//  TrainerQualificationsViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 12/11/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse

class TrainerQualificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    var qualificationsArray = [String]()
    var tempArray:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBarButtonItemTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addButtonTapped(sender: UIButton) {
        if textField.text?.isEmptyOrWhitespace() == false {
            self.qualificationsArray.append(textField.text!)
            self.textField.resignFirstResponder()
            self.textField.text = ""
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveBarButtonItem === sender {
            
            // Set the qualifications to be passed to TrainerProfileViewController after the unwind segue.
            self.tempArray = self.qualificationsArray
            
            //MARK: Save Qualifications to Parse
            let user = PFUser.currentUser()
            user!.setObject(self.qualificationsArray, forKey: "qualifications")
            user!.saveInBackgroundWithBlock(nil)
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.qualificationsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "qualificationCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! QualificationsTableViewCell
        cell.qualificationLabel.text = self.qualificationsArray[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.qualificationsArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


}

// Check white space or empty text
extension String {
    func isEmptyOrWhitespace() -> Bool {
        
        if(self.isEmpty)
        {
            return true
        }
        
        return (self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "")
    }
}
