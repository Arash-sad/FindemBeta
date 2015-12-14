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
    
    //make qualificationsArray global ?
    let qualificationsArray = ["Diploma excersize science","Level 2 Fitness Australia fitness trainer","Core essential fit ball training ","Bosu Certification  course","Punch fit  trainer course level 1/2","Boxing for fitness certification","Metabolic Nutrition","Level 1/2 rehabilitation certification","Physiotherapy","Diploma of massage therapy"]
    let qualificationsDictionary = [0:"Diploma excersize science",1:"Level 2 Fitness Australia fitness trainer",2:"Core essential fit ball training ",3:"Bosu Certification  course",4:"Punch fit  trainer course level 1/2",5:"Boxing for fitness certification",6:"Metabolic Nutrition",7:"Level 1/2 rehabilitation certification",8:"Physiotherapy",9:"Diploma of massage therapy"]
    var tempDict:[Int:String] = [:]
    var tempArray:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        for (index,cell) in tableView.visibleCells.enumerate() {
            for item in tempArray! {
                if qualificationsArray[index] == item {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    tempDict[index] = qualificationsDictionary[index]
                }
                
            }
        }
    }
    
    @IBAction func cancelBarButtonItem(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveBarButtonItem === sender {
            
            // Set the qualifications to be passed to TrainerProfileViewController after the unwind segue.
            self.tempArray = self.tempDict.values.sort()
            
            //MARK: Save Qualifications to Parse
            let user = PFUser.currentUser()
            user!.setObject(self.tempArray!, forKey: "qualifications")
            user!.saveInBackgroundWithBlock(nil)
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "qualificationCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! QualificationsTableViewCell
        cell.qualificationLabel.text = qualificationsArray[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if (cell?.accessoryType == UITableViewCellAccessoryType.Checkmark){
            cell!.accessoryType = UITableViewCellAccessoryType.None;
            tempDict.removeValueForKey(indexPath.row)
        }
        else {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark;
            tempDict[indexPath.row] = qualificationsDictionary[indexPath.row]
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


}
