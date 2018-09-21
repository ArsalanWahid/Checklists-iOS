//
//  Helpers.swift
//  checklists
//
//  Created by Arsalan Wahid Asghar on 9/20/18.
//  Copyright © 2018 asghar. All rights reserved.
//

import Foundation


//Used these enums to removes text from code to prevent errors and
// better management

enum UserDefaultKeys:String{
    case CheckListIndex,FirstTime
}

enum segueIdentifiers:String{
    case showCheckList,addList,addItem,editItem
}

enum cellIdentifiers:String{
    case checkList,item
}
