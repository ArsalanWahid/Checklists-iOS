//
//  ViewController.swift
//  checklists
//
//  Created by Arsalan Wahid Asghar on 9/18/18.
//  Copyright © 2018 asghar. All rights reserved.
//

import UIKit



class CheckListViewController: UITableViewController,ItemTableViewControllerDelegate {

    //MARK:- Properties
    var checklist:CheckList!
    
    
    //MARK:- LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }
    
    
    
    //MARK:- TABLEVIEW DATASOURCE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.item.rawValue, for: indexPath)
        let text = cell.viewWithTag(1) as! UILabel
        let checkmark = cell.viewWithTag(2) as! UILabel
        text.text = checklist.items[indexPath.row].name
        
        if checklist.items[indexPath.row].isChecked{
            checkmark.text = "√"
        }else{
            checkmark.text = ""
        }
        return cell
    }
    
    //MARK:- TABLEVIEW DELEGATE
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let checkmark = cell?.viewWithTag(2) as! UILabel
        if checklist.items[indexPath.row].isChecked{
            checkmark.text = ""
            checklist.items[indexPath.row].isChecked = false
        }else{
            checkmark.text = "√"
            checklist.items[indexPath.row].isChecked = true
        }
        ()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        ()
    }
    


    
    
    //MARK:- ItemTableViewController Delegate
    
    func itemTableViewControllerDidCancel(_ controller: ItemTableViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemTableViewController(_ controller: ItemTableViewController, didFinishAdding item: Item) {
 //       let itemCount = checklist.items.count
        checklist.items.append(item)
//        let index = IndexPath(item: itemCount, section: 0)
//        tableView.insertRows(at: [index], with: .automatic)
        sortItems()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    
    }
    
    func itemTableViewController(_ controller: ItemTableViewController, didFinishEditing Item: Item) {
        if let index = checklist.items.firstIndex(where: {$0 === Item}){
            let indexPath = IndexPath(item: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                //update the cell text
                let name = cell.viewWithTag(1) as! UILabel
                name.text = checklist.items[indexPath.row].name
            }
        }
    
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifiers.addItem.rawValue{
            let nvc = segue.destination as! UINavigationController
            let controller = nvc.topViewController as! ItemTableViewController
            controller.delegate = self
        }else if segue.identifier == segueIdentifiers.editItem.rawValue{
            let nvc = segue.destination as! UINavigationController
            let controller = nvc.topViewController as! ItemTableViewController
            controller.delegate = self
            //Find the indexpath for the cell 
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    //Will sort items by name
    func sortItems(){
        checklist.items.sort(by: {
            item1,item2 in
            return item1.name.localizedStandardCompare(item2.name) == .orderedAscending
        })
    }

}

