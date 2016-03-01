//
//  ChatViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 14/12/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import Foundation
import Parse

class ChatViewController : JSQMessagesViewController {
    
    var messages: [JSQMessage] = []
    var connectionID: String?
    var userAction: String?
    var trainerAction: String?
    var userType: String?
    var messageListener = MessageListener?()
//    var recipient: User!
//    var senderAvatar: UIImage!
//    var recipientAvatar: UIImage!
    
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.darkGrayColor())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Remove avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        // Disable attachment Button
        self.inputToolbar!.contentView!.leftBarButtonItem = nil
        
        self.senderId = currentUser()!.id
        self.senderDisplayName = currentUser()!.name
        
        //Fetch messages from Firebase
        if let id = connectionID {
            fetchMessages(id, callback: {
                messages in
                for m in messages {
                    self.messages.append(JSQMessage(senderId: m.senderID, senderDisplayName: m.senderID, date: m.date, text: m.message))
                }
                self.finishReceivingMessage()
            })
        }
    }
    
    // MARK: Realtime updates to messages
    override func viewWillAppear(animated: Bool) {
        if let id = connectionID {
            messageListener = MessageListener(connectionID: id, startDate: NSDate(), callback: {
                message in
                if message.senderID != currentUser()?.id {
                    self.messages.append(JSQMessage(senderId: message.senderID, senderDisplayName: message.senderID, date: message.date, text: message.message))
                }
                self.finishReceivingMessage()
            })
        }
    }
    
    // MARK: Stop realtime updates to messages
    override func viewWillDisappear(animated: Bool) {
        messageListener!.stop()
        
        // Save lastMessage time in Parse Action class
        if let id = connectionID {
            let query = PFQuery(className: "Action")
            query.getObjectInBackgroundWithId(id) { (object, err) -> Void in
                if err != nil || object == nil {
                    print("Save lastMessage date: The request failed.")
                }
                else {
                    if PFUser.currentUser()?.objectId == object!.objectForKey("byUser") as? String {
                        object!.setObject(NSDate(), forKey: "userLastSeenAt")
                        object!.saveInBackgroundWithBlock(nil)
                    }
                    else if PFUser.currentUser()?.objectId == object!.objectForKey("toTrainer") as? String {
                        object!.setObject(NSDate(), forKey: "trainerLastSeenAt")
                        object!.saveInBackgroundWithBlock(nil)
                    }
                }
            }
        }
    }
    
//    func chatSenderDisplayName() -> String! {
//        return currentUser()!.name
//    }
//    func chatSenderId() -> String! {
//        return currentUser()!.id
//    }

    //MARK: Helper function to update avatar
//    func updateAvatarImageForIndexPath( indexPath: NSIndexPath, avatarImage: UIImage) {
//        let cell: JSQMessagesCollectionViewCell = self.collectionView!.cellForItemAtIndexPath(indexPath) as! JSQMessagesCollectionViewCell
//        cell.avatarImageView!.image = JSQMessagesAvatarImageFactory.circularAvatarImage( avatarImage, withDiameter: 60 )
//    }
    
    // MARK: - Setup Chat CollectionView
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        
        let data = self.messages[indexPath.row]
        return data
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    // Select incoming and outgoing message bubble color
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let data = self.messages[indexPath.row]
        if data.senderId == PFUser.currentUser()!.objectId {
            return outgoingBubble
        }
        else {
            return incomingBubble
        }
    }
    
//    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
//        var imgAvatar = JSQMessagesAvatarImage.avatarWithImage( JSQMessagesAvatarImageFactory.circularAvatarImage( UIImage(named: "defaultPhoto"), withDiameter: 60 ) )
//        if (self.messages[indexPath.row].senderId == self.senderId)
//        {
//            if (self.senderAvatar == nil)
//            {
//                currentUser()!.getPhoto({ (image) -> () in
//                    self.senderAvatar = image
//                    self.updateAvatarImageForIndexPath( indexPath, avatarImage: image)
//                })
//                
//            }
//            else
//            {
//                imgAvatar = JSQMessagesAvatarImage.avatarWithImage( JSQMessagesAvatarImageFactory.circularAvatarImage( self.senderAvatar, withDiameter: 60 ) )
//            }
//        }
//        else
//        {
//            if (self.recipientAvatar == nil)
//            {
//                self.recipient.getPhoto({ (image) -> () in
//                    self.updateAvatarImageForIndexPath( indexPath, avatarImage: image)
//                })
//                
//            }
//            else
//            {
//                imgAvatar = JSQMessagesAvatarImage.avatarWithImage( JSQMessagesAvatarImageFactory.circularAvatarImage( self.recipientAvatar, withDiameter: 60 ) )
//            }
//        }
//        return imgAvatar
//    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        // Check if user has blocked by trainer or vice versa
        if (userType == "user" && userAction == "blocked") || (userType == "trainer" && trainerAction == "blocked") {
            alert("Blocked user", message: "In order to send a message you need to unblock the user.")
        }
        else if (userType == "user" && (trainerAction == "blocked" || trainerAction == "gameOver")) || (userType == "trainer" && (userAction == "blocked" || userAction == "gameOver")){
            alert("Blocked", message: "You are not able to send a message to this user.")
        }
        else {
            let m = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
            self.messages.append(m)
            // Save message to Firebase
            if let id = connectionID {
                saveMessage(id, message: Message(message: text, senderID: senderId, date: date))
                
                // Save lastMessage and its time in Parse Action class
                let query = PFQuery(className: "Action")
                query.getObjectInBackgroundWithId(id) { (object, err) -> Void in
                    if err != nil || object == nil {
                        print("Save lastMessage date: The request failed.")
                    }
                    else {
                        object!.setObject(NSDate(), forKey: "lastMessageAt")
                        object!.setObject(text, forKey: "lastMessageString")
                        //                    object!.saveInBackgroundWithBlock(nil)
                        object!.saveInBackgroundWithBlock {
                            (success, error) -> Void in
                            if success == true {
                                
                            } else {
                                print("Error: Couldn't save last message date")
                            }
                        }
                    }
                }
            }
            finishSendingMessage()
        }
    }
    
    //MARK: - Alert
    func alert(messageTitle: String, message: String) {
        let alert = UIAlertController(title: messageTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}