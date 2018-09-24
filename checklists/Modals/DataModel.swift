//
//  DataModel.swift
//  checklists
//
//  Created by Arsalan Wahid Asghar on 9/20/18.
//  Copyright © 2018 asghar. All rights reserved.
//

import Foundation

//This is called in the appDelegate
class DataModel{
    
    
    //MARK:Properties
    var indexOfSelectedCheckList:Int{
        get{
            return UserDefaults.standard.integer(forKey: UserDefaultKeys.CheckListIndex.rawValue)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.CheckListIndex.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    var checklists = [CheckList]()
    
    //MARK:- Initializer
    init(){
        loadChecklists()
        registerDefaults()
        handleFirstTime()
        print("\(dataFilePath())")
    }
    
    
    //MARK:- FILE SYSTEM
     func documentDirectory() -> URL{
        let path =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
     func dataFilePath() -> URL{
        return documentDirectory().appendingPathComponent("checklists.plist")
    }
    
     func saveCheckLists(){
        let data  = NSMutableData()
        let archiever = NSKeyedArchiver(forWritingWith: data)
        archiever.encode(checklists, forKey: "checkLists")
        archiever.finishEncoding()
        do{
            try data.write(to: dataFilePath(), options: .atomic)
        }catch{
            
        }
    }
    //Loads the check lists from the plist file
     func loadChecklists(){
        //Pick the file path to load the items from
        let path = dataFilePath()
        //check if there is anything in the path given
        if let data = try? Data(contentsOf: path) {
            sortCheckLists() // to make sure data is sorted
            //now decode the stuff
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            checklists = unarchiver.decodeObject(forKey: "checkLists") as! [CheckList]
            unarchiver.finishDecoding()
        }else{
            print("Could not find data the the specified path")
        }
    }
    
    //MARK:- UserDefaults
    //Allows to set default values for keys in Userdefaults
    func registerDefaults(){
        let dic:[String:Any] = [
            UserDefaultKeys.CheckListIndex.rawValue: -1,
            UserDefaultKeys.FirstTime.rawValue:true,
            UserDefaultKeys.CheckListItemID.rawValue : 0
        ]
        UserDefaults.standard.register(defaults: dic)
    }
    
    //This function will be run the first time the app load on a new device
    func handleFirstTime(){
        let firsTime = UserDefaults.standard.bool(forKey: UserDefaultKeys.FirstTime.rawValue)
        if firsTime{
            //make a checkList
            let checklist = CheckList(name: "List")
            self.checklists.append(checklist)
            indexOfSelectedCheckList = 0
            UserDefaults.standard.set(false, forKey: UserDefaultKeys.FirstTime.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK:- Sorting
    //Function will sort lists
    func sortCheckLists(){
        checklists.sort(by: {
            checkList1,checklist2 in
            return checkList1.name.localizedStandardCompare(checklist2.name) == .orderedAscending
        })
    }
    
    //for every checklist item created this function will run
    //default value for the key has been set to 0
    class func nextCheckListItemID() -> Int{
        let usrdefault = UserDefaults.standard
        let itemID = usrdefault.integer(forKey: UserDefaultKeys.CheckListItemID.rawValue)
        usrdefault.set(itemID + 1, forKey: UserDefaultKeys.CheckListItemID.rawValue)
        usrdefault.synchronize()
        return itemID
        
    }
}

