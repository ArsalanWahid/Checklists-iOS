//
//  Helpers.swift
//  checklists
//
//  Created by Arsalan Wahid Asghar on 9/20/18.
//  Copyright © 2018 asghar. All rights reserved.
//

import Foundation


//Used these enums to removes text from code to prevent type errors
enum UserDefaultKeys:String{
    case CheckListIndex,FirstTime,CheckListItemID
}

enum segueIdentifiers:String{
    case showCheckList,addList,addItem,editItem
}

enum cellIdentifiers:String{
    case checkList,item
}
