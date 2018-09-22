//
//  IconPickerViewController.swift
//  checklists
//
//  Created by Arsalan Wahid Asghar on 9/22/18.
//  Copyright © 2018 asghar. All rights reserved.
//

import Foundation
import UIKit

protocol IconPickerViewControllerDelegate:AnyObject {
    func inconPickerViewController(_ controller:IconPickerViewController, didPick iconName:String)
}


class IconPickerViewController: UITableViewController{
    weak var delegate: IconPickerViewControllerDelegate?
    
    let icons = [
        "No Icon",
        "Appointments",
        "Birthdays",
        "Chores",
        "Drinks",
        "Folder",
        "Groceries",
        "Inbox",
        "Photos",
        "Trips" ]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "icon", for: indexPath)
        cell.textLabel?.text = icons[indexPath.row]
        cell.imageView?.image = UIImage(named: icons[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.inconPickerViewController(self, didPick: icons[indexPath.row])
    }
    
    
}
