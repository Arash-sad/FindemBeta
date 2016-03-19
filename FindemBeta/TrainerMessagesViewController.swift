//
//  TrainerMessagesViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 11/12/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse

class TrainerMessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var connections:[Connection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            fetchConnectionsForTrainers({
                connections in
                self.connections = connections
                // Sort Messages by lastMessage
                self.connections.sortInPlace{ $0.action.lastMessage.timeIntervalSince1970 > $1.action.lastMessage.timeIntervalSince1970 }
                self.reload()
            })
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return connections.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath) as! MessagesTableViewCell
        
        // Configure the cell...
        let user = connections[indexPath.row].user
        
        cell.nameLabel.text = user.name
        user.getPhoto({
            image in
            cell.avatarImageView.image = image
        })
        cell.dateLabel.text = lastMessageDateToString(connections[indexPath.row].action.lastMessage)
        cell.lastMessageLabel.text = connections[indexPath.row].action.lastMessageString ?? ""
        // Show new message label
        if connections[indexPath.row].action.lastMessage.timeIntervalSince1970 >= connections[indexPath.row].action.trainerLastSeenAt.timeIntervalSince1970 {
            cell.circleImageView.hidden = false
        }
        else {
            cell.circleImageView.hidden = true
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = ChatViewController()
        
        // Pass connectionID to chatViewController and set its title to user's name
        let connection = connections[indexPath.row]
        vc.connectionID = connection.action.id
        vc.userAction = connection.action.userAction
        vc.trainerAction = connection.action.trainerAction
        vc.userType = "trainer"
        vc.title = connection.user.name
//        vc.recipient = connection.user
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let connectionId = self.connections[indexPath.row].action.id
        let trainerAction = self.connections[indexPath.row].action.trainerAction
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete", handler: {
            (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Alert : Delete confirmation
            let alert = UIAlertController(title: "Alert", message: "Are you sure ?!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: {
                (action: UIAlertAction!) in
                // Find trainerAction and Save new trainerAction to Parse
                let query = PFQuery(className: "Action")
                query.whereKey("objectId", equalTo: connectionId)
                query.getFirstObjectInBackgroundWithBlock {
                    (object: PFObject?, error: NSError?) -> Void in
                    if error != nil || object == nil {
                        print("Delete Connection: The request failed.")
                    }
                    else {
                        // The find succeeded.
                        if object!.objectForKey("userAction") as? String ?? "" == "deleted" {
                            //Remove all messages if both user and trainer delete the message row
                            removeAllMessages(connectionId)
                            if object!.objectForKey("trainerAction") as? String ?? "" == "blocked" {
                                object!.setObject("gameOver", forKey: "trainerAction")
                                object!.saveInBackgroundWithBlock(nil)
                            }
                            else {
                                //Remove connection from Parse (Action class)
                                deleteConnection(connectionId)
                            }
                        }
                        else {
                            if object!.objectForKey("trainerAction") as? String ?? "" == "blocked" {
                                object!.setObject("gameOver", forKey: "trainerAction")
                            }
                            else {
                                object!.setObject("deleted", forKey: "trainerAction")
                            }
                            object!.saveInBackgroundWithBlock(nil)
                        }
                    }
                }
                // Remove deleted row from tableView
                self.connections.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        })
        
        let blockAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Block", handler: {
            (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Alert: Block confirmation
            let alert = UIAlertController(title: "Block", message: "Are you sure ?!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Block", style: UIAlertActionStyle.Default, handler: {
                (action: UIAlertAction!) in
                // Find trainerAction and Save new trainerAction to Parse
                let query = PFQuery(className: "Action")
                query.whereKey("objectId", equalTo: connectionId)
                query.getFirstObjectInBackgroundWithBlock {
                    (object: PFObject?, error: NSError?) -> Void in
                    if error != nil || object == nil {
                        print("Block Connection: The request failed.")
                    } else {
                        // The find succeeded.
                        object!.setObject("blocked", forKey: "trainerAction")
                        object!.saveInBackgroundWithBlock(nil)
                    }
                }
                self.connections[indexPath.row].action.trainerAction = "blocked"
                tableView.reloadData()
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        })
        blockAction.backgroundColor =  UIColor.orangeColor()
        
        let unBlockAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Unblock", handler: {
            (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Alert: Block confirmation
            let alert = UIAlertController(title: "Alert", message: "Are you sure ?!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Unblock", style: UIAlertActionStyle.Default, handler: {
                (action: UIAlertAction!) in
                // Find trainerAction and Save new trainerAction to Parse
                let query = PFQuery(className: "Action")
                query.whereKey("objectId", equalTo: connectionId)
                query.getFirstObjectInBackgroundWithBlock {
                    (object: PFObject?, error: NSError?) -> Void in
                    if error != nil || object == nil {
                        print("Block Connection: The request failed.")
                    } else {
                        // The find succeeded.
                        object!.setObject("unblocked", forKey: "trainerAction")
                        object!.saveInBackgroundWithBlock(nil)
                    }
                }
                self.connections[indexPath.row].action.trainerAction = "unblocked"
                tableView.reloadData()
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        })
        unBlockAction.backgroundColor =  UIColor.orangeColor()
        
        if trainerAction != "blocked" {
            return [deleteAction,blockAction]
        }
        else {
            return [deleteAction,unBlockAction]
        }
    }
    
    // reload tableView when data fetched
    func reload() {
        // Display Activity Indicator
        let loadView = UIView.loadFromNibNamed("LoadView")
        loadView?.center = view.center
        view.addSubview(loadView!)
        
        if self.connections.count > 0 {
            self.tableView.reloadData()
            
            // Remove Activity Indicator
            loadView!.removeFromSuperview()
        }
        else {
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("reload"), userInfo: nil, repeats: false)
        }
    }

}
