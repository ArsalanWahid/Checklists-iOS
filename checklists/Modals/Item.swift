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
    
    convenience init(name:String){
        self.init(name: name, isChecked: false)
    }
    init(name: String,isChecked:Bool){
        self.name = name
        self.isChecked = isChecked
    }
    
    //This method is for unfreezing the items when needed
    //Basically decoeds the binary to make useable in the app
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Text") as! String
        isChecked = aDecoder.decodeBool(forKey: "Checked")
        //super.init()
    }
    
    //This make the proeprties compatible for encoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Text")
        aCoder.encode(isChecked, forKey: "Checked")
    }
}
