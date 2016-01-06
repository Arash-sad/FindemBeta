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
    var messageListener = MessageListener?()
    var recipient: User!
//    var senderAvatar: UIImage!
//    var recipientAvatar: UIImage!
    
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    
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
        let m = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        self.messages.append(m)
        // Save message to Firebase
        if let id = connectionID {
            saveMessage(id, message: Message(message: text, senderID: senderId, date: date))
        }
        finishSendingMessage()
    }
    
}