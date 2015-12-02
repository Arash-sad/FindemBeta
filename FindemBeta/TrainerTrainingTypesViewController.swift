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
    
    //TODO: TEMP 
    // trainingArray is global -> AppDelegate 
//    let trainingArray = ["Core Strength","Weight Loss","Functional Training","Small Group Training","Pre and Post Baby","Rehab"]
    let trainingDictionary = [0:"Core Strength",1:"Weight Loss",2:"Functional Training",3:"Small Group Training",4:"Pre and Post Baby",5:"Rehab"]
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
    
    //Checkmark the saved selected row and also add them to tempDict
    override func viewDidAppear(animated: Bool) {
        for (index,cell) in tableView.visibleCells.enumerate() {
            for item in tempArray! {
                if trainingArray[index] == item {
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
            //TODO: TEMP
            self.tempArray = self.tempDict.values.sort()
            
            //MARK: Save TrainingTypes to Parse
            let user = PFUser.currentUser()
            user!.removeObjectForKey("trainingTypes")
            user!.setObject(self.tempArray!, forKey: "trainingTypes")
            user!.saveInBackgroundWithBlock(nil)
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "trainingCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TrainingTableViewCell
        cell.trainingLabel.text = trainingArray[indexPath.row]

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
    }

}
