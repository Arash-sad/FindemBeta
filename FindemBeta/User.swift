//
//  User.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 4/11/2015.
//  Copyright (c) 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import Foundation
import Parse

struct User {
    let id: String
    let name: String
    private let pfUser: PFUser
    
    //Nested Function-Use callback: (UIImage) because make the call asynchronously
    func getPhoto(callback:(UIImage) -> ()) {
        let imageFile = pfUser.objectForKey("picture") as! PFFile
        imageFile.getDataInBackgroundWithBlock({
            data, error in
            if let data = data {
                callback(UIImage(data: data)!)
            }
        })
    }
}

func pfUserToUser(user: PFUser) -> User {
    return User(id: user.objectId!, name: user.objectForKey("firstName") as! String, pfUser: user)
}

func currentUser() -> User? {
    if let user = PFUser.currentUser() {
        return pfUserToUser(user)
    }
    return nil 
}

func saveConnection(trainer: Trainer) {
    let action = PFObject(className: "Action")
    action.setObject(PFUser.currentUser()!.objectId!, forKey: "byUser")
    action.setObject(trainer.id, forKey: "toTrainer")
    action.setObject("connected", forKey: "userAction")
    action.setObject("connected", forKey: "trainerAction")
    action.setObject(NSDate(), forKey: "userLastSeenAt")
    action.setObject(NSDate(), forKey: "trainerLastSeenAt")
    action.setObject(NSDate(), forKey: "lastMessageAt")
    action.setObject("", forKey: "lastMessageString")
    action.saveInBackgroundWithBlock(nil)
}

