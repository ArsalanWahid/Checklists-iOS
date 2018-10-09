//
//  ItemModal.swift
//  checklists
//
//  Created by Arsalan Wahid Asghar on 9/18/18.
//  Copyright © 2018 asghar. All rights reserved.
//

import Foundation
import UserNotifications


class Item:NSObject, NSCoding{

    //Properties
    var name:String
    var isChecked:Bool
    var shouldRemind:Bool
    var dueDate:Date?
    var itemID:Int

    //Decodes the the data from Plist for usable format in App
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Text") as! String
        isChecked = aDecoder.decodeBool(forKey: "Checked")
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        //super.init()
    }


    init(name: String , isChecked: Bool, shouldRemind: Bool){
        self.name = name
        self.isChecked = isChecked
        self.shouldRemind = shouldRemind
        self.itemID = DataModel.nextCheckListItemID()
    }
    
    convenience init(name:String){
        self.init(name: name, isChecked: false, shouldRemind: false)
    }
    
    deinit {
        removeNotification()
    }

    //Function make Class properties eligiable for encoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Text")
        aCoder.encode(isChecked, forKey: "Checked")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
        aCoder.encode(itemID, forKey: "ItemID")
        aCoder.encode(dueDate, forKey: "DueDate")
    }
    
    
    //MARK:- Item Notification
    //Schedule notification for individual Item
    func scheduleNotification() {
        removeNotification()
        if (self.shouldRemind) && (self.dueDate! > Date()) {

            // Create Notificaion
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = name
            content.sound = UNNotificationSound.default

            // Get Date information from local calender based on Date provided
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(
                [.month, .day, .hour, .minute], from: dueDate!)
            print("\(components)")

            //Create Trigger based on calender information
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components, repeats: false)

            // Make a Request To Notification Center to make the notificaion
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request)
            print("Scheduled notification \(request) for itemID \(itemID)")
        }else{
            print("Notifications not working")
            print("DueDate:\(dueDate) vs Date:\(Date())")
        }
        
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
}
