//
//  CheckListModal.swift
//  checklists
//
//  Created by Arsalan Wahid Asghar on 9/19/18.
//  Copyright © 2018 asghar. All rights reserved.
//

import Foundation


class CheckList: NSObject,NSCoding {

    //MARK:- Properties
    var name:String
    var items = [Item]()
    var iconName:String

    //Retrieve data from the Plist file
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [Item]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
        super.init()
    }

    init(name:String, iconName:String){
        self.name = name
        self.iconName = iconName
    }

    //When Ever iconName is not Provided default icon will be assigned
    convenience init(name:String) {
        self.init(name: name, iconName: "No Icon")
    }

    
    //Encodes the data for storage
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "IconName")
    }

    //Counts the number of unchecked items in the checkList
    func unCheckedItems() -> Int{
        //Here $0 is the sum/count , use $1 for the item
        return items.reduce(0){$0 + ($1.isChecked ? 0 : 1)}
    }
}
