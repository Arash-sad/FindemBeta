//
//  Message.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 16/12/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import Foundation

struct Message {
    let message: String
    let senderID: String
    let date: NSDate
}

// Realtime updates to messages
class MessageListener {
    var currentHandle: UInt?
    init (connectionID: String, startDate: NSDate, callback: (Message)->()) {
        let handle = ref.childByAppendingPath(connectionID).queryOrderedByKey().queryStartingAtValue(dateFormatter().stringFromDate(startDate)).observeEventType(FEventType.ChildAdded, withBlock: {
            snapshot in
            let message = snapshotToMessage(snapshot)
            callback(message)
        })
        self.currentHandle = handle
    }
    func stop() {
        if let handle = currentHandle {
            ref.removeObserverWithHandle(handle)
            currentHandle = nil
        }
    }
}

// Setup Firebase and store Firebase reference
private let ref = Firebase(url: "https://findem.firebaseio.com/messages")

private let dateFormat = "yyyyMMddHHmmss"

private func dateFormatter() -> NSDateFormatter {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter
}

func saveMessage(connectionID: String, message: Message) {
    ref.childByAppendingPath(connectionID).updateChildValues([dateFormatter().stringFromDate(message.date) : ["message" : message.message, "sender" : message.senderID]])
}

private func snapshotToMessage(snapshot: FDataSnapshot) -> Message {
    let date = dateFormatter().dateFromString(snapshot.key)
    let sender = snapshot.value["sender"] as? String
    let text = snapshot.value["message"] as? String
    return Message(message: text!, senderID: sender!, date: date!)
}

// Fetching data asynchronously using callback
// Fetch last 30 messages
func fetchMessages(connectionID: String, callback: ([Message]) ->()) {
    ref.childByAppendingPath(connectionID).queryLimitedToFirst(30).observeSingleEventOfType(FEventType.Value, withBlock: {
        snapshot in
        var messages = Array<Message>()
        let enumerator = snapshot.children
        while let data = enumerator.nextObject() as? FDataSnapshot {
            messages.append(snapshotToMessage(data))
        }
        callback(messages)
    })
}

func removeAllMessages(connectionID: String) {
    ref.childByAppendingPath(connectionID).removeValue()
}
