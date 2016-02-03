//
//  FinderMessagesViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 6/01/2016.
//  Copyright © 2016 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4

class FinderMessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var connections:[Connection] = []
    var slidingMenu = UIView.loadFromNibNamed("SlidingMenu")
    var menuIsVisible = false
    var menuHeight:CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        slidingMenu?.frame.size.width = self.view.frame.size.width
        slidingMenu?.center = CGPoint(x: self.view.frame.size.width/2, y: -170)
        view.addSubview(slidingMenu!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchConnectionsForUsers({
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
        let cell = tableView.dequeueReusableCellWithIdentifier("finderMessageCell", forIndexPath: indexPath) as! FinderMessageTableViewCell
        
        // Configure the cell...
        let user = connections[indexPath.row].user
        
        cell.nameLabel.text = user.name
        user.getPhoto({
            image in
            cell.avatarImageView.image = image
        })
        cell.dateLabel.text = lastMessageDateToString(connections[indexPath.row].action.lastMessage)
        // Show new message label
        if connections[indexPath.row].action.lastMessage.timeIntervalSince1970 >= connections[indexPath.row].action.userLastSeenAt.timeIntervalSince1970 {
            cell.newMessageLabel.hidden = false
        }
        else {
            cell.newMessageLabel.hidden = true
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if menuIsVisible == false {
            let vc = ChatViewController()
            // Pass connectionID to chatViewController and set its title to user's name
            let connection = connections[indexPath.row]
            vc.connectionID = connection.action.id
            vc.userAction = connection.action.userAction
            vc.trainerAction = connection.action.trainerAction
            vc.userType = "user"
            vc.title = connection.user.name
//            vc.recipient = connection.user
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let connectionId = self.connections[indexPath.row].action.id
        let userAction = self.connections[indexPath.row].action.userAction
        //        let blockedList = self.connections[indexPath.row].user.blockedList
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: {
            (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Alert : Delete confirmation
            let alert = UIAlertController(title: "Alert", message: "Are you sure ?!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: {
                (action: UIAlertAction!) in
                // Find userAction and Save new userAction to Parse
                let query = PFQuery(className: "Action")
                query.whereKey("objectId", equalTo: connectionId)
                query.getObjectInBackgroundWithId(connectionId) { (object, err) -> Void in
                    if err != nil || object == nil {
                        print("Delete Connection: The request failed.")
                    } else {
                        // The find succeeded.
                        if object!.objectForKey("trainerAction") as? String ?? "" == "deleted" {
                            //Remove all messages from Firebase if both user and trainer delete the message row
                            removeAllMessages(connectionId)
                            if object!.objectForKey("userAction") as? String ?? "" == "blocked" {
                                object!.setObject("gameOver", forKey: "userAction")
                                object!.saveInBackgroundWithBlock(nil)
                            }
                            else {
                                //Remove connection from Parse (Action class)
                                deleteConnection(connectionId)
                            }
                        }
                        else {
                            if object!.objectForKey("userAction") as? String ?? "" == "blocked" {
                                object!.setObject("gameOver", forKey: "userAction")
                            }
                            else {
                                object!.setObject("deleted", forKey: "userAction")
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
        
        let blockAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Block", handler: {
            (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Alert: Block confirmation
            let alert = UIAlertController(title: "Alert", message: "Are you sure ?!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Block", style: UIAlertActionStyle.Default, handler: {
                (action: UIAlertAction!) in
                // Find userAction and Save new userAction to Parse
                let query = PFQuery(className: "Action")
                query.whereKey("objectId", equalTo: connectionId)
                query.getFirstObjectInBackgroundWithBlock {
                    (object: PFObject?, error: NSError?) -> Void in
                    if error != nil || object == nil {
                        print("Block Connection: The request failed.")
                    } else {
                        // The find succeeded.
                        object!.setObject("blocked", forKey: "userAction")
                        object!.saveInBackgroundWithBlock(nil)
                    }
                }
                self.connections[indexPath.row].action.userAction = "blocked"
                tableView.reloadData()
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        })
        blockAction.backgroundColor =  UIColor.orangeColor()
        
        let unBlockAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Unblock", handler: {
            (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Alert: Block confirmation
            let alert = UIAlertController(title: "Alert", message: "Are you sure ?!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Unblock", style: UIAlertActionStyle.Default, handler: {
                (action: UIAlertAction!) in
                // Find userAction and Save new userAction to Parse
                let query = PFQuery(className: "Action")
                query.whereKey("objectId", equalTo: connectionId)
                query.getFirstObjectInBackgroundWithBlock {
                    (object: PFObject?, error: NSError?) -> Void in
                    if error != nil || object == nil {
                        print("Block Connection: The request failed.")
                    } else {
                        // The find succeeded.
                        object!.setObject("unblocked", forKey: "userAction")
                        object!.saveInBackgroundWithBlock(nil)
                    }
                }
                self.connections[indexPath.row].action.userAction = "unblocked"
                tableView.reloadData()
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        })
        unBlockAction.backgroundColor =  UIColor.orangeColor()
        
        if userAction != "blocked" {
            return [deleteAction,blockAction]
        }
        else {
            return [deleteAction,unBlockAction]
        }
    }
    
    // reload tableView when data fetched
    func reload() {
        if self.connections.count > 0 {
            self.tableView.reloadData()
        }
        else {
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("reload"), userInfo: nil, repeats: false)
        }
    }

    @IBAction func menuBarButtonItemTapped(sender: UIBarButtonItem) {
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.TransitionNone, animations: {
            
            self.menuIsVisible = !self.menuIsVisible
            var height:CGFloat = self.menuHeight
            if self.menuIsVisible == false {
                height = -self.menuHeight
            }
            self.slidingMenu?.center = CGPoint(x: self.view.frame.size.width/2, y: height)
            
            }, completion: { finished in
                
                
        })
    }

}

