//
//  TrainerTrainingTypesViewController
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 10/11/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse

class TrainerTrainingTypesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    
    let trainingArray = ["Bootcamp", "Core Strength", "Diet & Nutrition", "Functional Training", "Group Exercise", "Lifestyle Coach", "Massage Therapy", "Physiotherapist", "Pre & Post Baby", "Rehab", "Sport Specific", "Strength & Conditioning", "Weight Loss"]
    let trainingDictionary = [0:"Bootcamp",1:"Core Strength",2:"Diet & Nutrition",3:"Functional Training",4:"Group Exercise",5:"Lifestyle Coach",6:"Massage Therapy",7:"Physiotherapist",8:"Pre & Post Baby",9:"Rehab",10:"Sport Specific",11:"Strength & Conditioning",12:"Weight Loss"]
    var tempDict:[Int:String] = [:]
    var tempArray:[String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Checkmark the saved selected row and also add them to tempDict
    override func viewDidAppear(animated: Bool) {
        for (index,cell) in tableView.visibleCells.enumerate() {
            for item in tempArray! {
                if self.trainingArray[index] == item {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    tempDict[index] = trainingDictionary[index]
                }
                
            }
        }
    }
    
    @IBAction func cancelBarButtonItemPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveBarButtonItem === sender {
            
            // Set the trainings to be passed to TrainerProfileViewController after the unwind segue.
            self.tempArray = self.tempDict.values.sort()
            
            //MARK: Save TrainingTypes to Parse
            let user = PFUser.currentUser()
            user!.setObject(self.tempArray!, forKey: "trainingTypes")
            user!.saveInBackgroundWithBlock(nil)
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "trainingCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TrainingTableViewCell
        
        cell.tintColor = UIColor(red: 245/255, green: 7/255, blue: 55/255, alpha: 1.0)
        cell.trainingLabel.text = self.trainingArray[indexPath.row]

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
            tempDict[indexPath.row] = trainingDictionary[indexPath.row]
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
