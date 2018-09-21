//
//  CheckListModal.swift
//  checklists
//
//  Created by Arsalan Wahid Asghar on 9/19/18.
//  Copyright © 2018 asghar. All rights reserved.
//

import Foundation


class CheckList: NSObject,NSCoding {
    
    var name:String
    var items = [Item]()
    
    init(name:String) {
        self.name = name
    }
    
    //Encodes the data
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [Item]
        super.init()
    }
}
