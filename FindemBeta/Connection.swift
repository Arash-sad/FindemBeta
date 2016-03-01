//
//  Connection.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 11/12/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import Foundation
import Parse

struct Action {
    let id: String
    var userAction: String
    var trainerAction: String
    var lastMessage: NSDate
    var userLastSeenAt: NSDate
    var trainerLastSeenAt: NSDate
    var lastMessageString: String
}

struct Connection {
    var action: Action
    let user: User
}

func fetchConnectionsForTrainers (callBack: ([Connection]) -> ()) {
    PFQuery(className: "Action")
        .whereKey("toTrainer", equalTo: PFUser.currentUser()!.objectId!)
        .whereKey("trainerAction", notContainedIn: ["deleted","gameOver"])
        .findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> () in
            if error == nil {
                if let connections = objects {
                    let connectedUsers = connections.map({
                        (object)->(action: Action, userID: String) in
                        (Action(id: object.objectId!, userAction: object.objectForKey("userAction") as! String, trainerAction: object.objectForKey("trainerAction") as! String, lastMessage: object.objectForKey("lastMessageAt") as! NSDate, userLastSeenAt: object.objectForKey("userLastSeenAt") as! NSDate, trainerLastSeenAt: object.objectForKey("trainerLastSeenAt") as! NSDate, lastMessageString: object.objectForKey("lastMessageString") as! String), object.objectForKey("byUser") as! String)
                    })
                    let userIDs = connectedUsers.map({$0.userID})
                    
                    PFUser.query()!
                        .whereKey("objectId", containedIn: userIDs)
                        .findObjectsInBackgroundWithBlock({
                            (objects: [PFObject]?, error: NSError?) -> () in
                            
                            if let users = objects as? [PFUser] {
                                // Warning: reverse is not available in Swift 2.0
                                // used users.reverse() instead of reverse(users) 
                                // Attention: deleted reverse() from below
                                //let users = users.reverse()
                                let users = users
                                var m = Array<Connection>()
                                // Warning: enumerate is not a global function anymore in Swift 2.0
                                // Below used users.enumerate() instead of enumerate(users)
                                for (_, user) in users.enumerate() {
                                    var action: Action = Action(id: "", userAction: "", trainerAction: "", lastMessage: NSDate(), userLastSeenAt: NSDate(), trainerLastSeenAt: NSDate(), lastMessageString: "")
                                    for connectedUser in connectedUsers {
                                        if connectedUser.userID == user.objectId {
                                            action = connectedUser.action
                                            break
                                        }
                                    }
                                     m.append(Connection(action: action, user: pfUserToUser(user)))
//                                    m.append(Connection(id: connectedUsers[index].connectionID, user: pfUserToUser(user)))
                                }
                                callBack(m)
                            }
                        })
                }
            }
            else {
                // Log details of the failure
                print("Error-FetchConnections: \(error!) \(error!.userInfo)")
            }
            
        })
}

func fetchConnectionsForUsers (callBack: ([Connection]) -> ()) {
    PFQuery(className: "Action")
        .whereKey("byUser", equalTo: PFUser.currentUser()!.objectId!)
        .whereKey("userAction", notContainedIn: ["deleted","gameOver"])
        .findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> () in
            if error == nil {
                if let connections = objects {
                    let connectedUsers = connections.map({
                        (object)->(action: Action, userID: String) in
                        (Action(id: object.objectId!, userAction: object.objectForKey("userAction") as! String, trainerAction: object.objectForKey("trainerAction") as! String, lastMessage: object.objectForKey("lastMessageAt") as! NSDate, userLastSeenAt: object.objectForKey("userLastSeenAt") as! NSDate, trainerLastSeenAt: object.objectForKey("trainerLastSeenAt") as! NSDate, lastMessageString: object.objectForKey("lastMessageString") as! String), object.objectForKey("toTrainer") as! String)
                    })
                    let userIDs = connectedUsers.map({$0.userID})
                    
                    PFUser.query()!
                        .whereKey("objectId", containedIn: userIDs)
                        .findObjectsInBackgroundWithBlock({
                            (objects: [PFObject]?, error: NSError?) -> () in
                            
                            if let users = objects as? [PFUser] {
                                // Warning: reverse is not available in Swift 2.0
                                // used users.reverse() instead of reverse(users)
                                // Attention: deleted reverse() from below
                                //let users = users.reverse()
                                let users = users
                                var m = Array<Connection>()
                                // Warning: enumerate is not a global function anymore in Swift 2.0
                                // Below used users.enumerate() instead of enumerate(users)
                                for (_, user) in users.enumerate() {
                                    var action: Action = Action(id: "", userAction: "", trainerAction: "", lastMessage: NSDate(), userLastSeenAt: NSDate(), trainerLastSeenAt: NSDate(), lastMessageString: "")
                                    for connectedUser in connectedUsers {
                                        if connectedUser.userID == user.objectId {
                                            action = connectedUser.action
                                            break
                                        }
                                    }
                                    m.append(Connection(action: action, user: pfUserToUser(user)))
                                    //                                    m.append(Connection(id: connectedUsers[index].connectionID, user: pfUserToUser(user)))
                                }
                                callBack(m)
                            }
                        })
                }
            }
            else {
                // Log details of the failure
                print("Error-FetchConnections: \(error!) \(error!.userInfo)")
            }
            
        })
}

func deleteConnection(connectionId: String) {
    let query = PFQuery(className: "Action")
    query.getObjectInBackgroundWithId(connectionId) { (object, err) -> Void in
        if err != nil {
            //Error: Can't find the connectionID in Parse (Class: Action)
        } else {
            object!.deleteInBackground()
        }
    }
}
