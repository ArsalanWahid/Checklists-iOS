//
//  ItemModal.swift
//  checklists
//
//  Created by Arsalan Wahid Asghar on 9/18/18.
//  Copyright © 2018 asghar. All rights reserved.
//

import Foundation

//Prepped this class so it can work is NSCODER
class Item:NSObject, NSCoding{
    
    var name:String
    var isChecked:Bool
    var shouldRemind:Bool
    var dueDate:Date
    var itemID:Int
    
    convenience init(name:String){
        self.init(name: name, isChecked: false, shouldRemind: false, date: Date.init())
    }
    init(name: String,isChecked:Bool,shouldRemind:Bool,date:Date){
        self.name = name
        self.isChecked = isChecked
        self.shouldRemind = shouldRemind
        self.itemID = DataModel.nextCheckListItemID()
        self.dueDate = date
        
    }
    
    //This method is for unfreezing the items when needed
    //Basically decoeds the binary to make useable in the app
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Text") as! String
        isChecked = aDecoder.decodeBool(forKey: "Checked")
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        //super.init()
    }
    
    //This make the proeprties compatible for encoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Text")
        aCoder.encode(isChecked, forKey: "Checked")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
        aCoder.encode(itemID, forKey: "ItemID")
        aCoder.encode(dueDate, forKey: "DueDate")
    }
}
