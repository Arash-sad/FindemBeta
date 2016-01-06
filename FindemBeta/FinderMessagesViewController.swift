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
    var menuVisible = false
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
            self.tableView.reloadData()
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
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = ChatViewController()
        
        // Pass connectionID to chatViewController and set its title to user's name
        let connection = connections[indexPath.row]
        vc.connectionID = connection.id
        vc.title = connection.user.name
        vc.recipient = connection.user
        
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    @IBAction func menuBarButtonItemTapped(sender: UIBarButtonItem) {
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.TransitionNone, animations: {
            
            self.menuVisible = !self.menuVisible
            var height:CGFloat = self.menuHeight
            if self.menuVisible == false {
                height = -self.menuHeight
            }
            self.slidingMenu?.center = CGPoint(x: self.view.frame.size.width/2, y: height)
            
            }, completion: { finished in
                
                
        })
    }

}

