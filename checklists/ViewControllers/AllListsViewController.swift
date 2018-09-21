//
//  AllListsViewController.swift
//  checklists
//
//  Created by Arsalan Wahid Asghar on 9/19/18.
//  Copyright © 2018 asghar. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController,ListDetailTableViewControllerDelegate,UINavigationControllerDelegate {
 
    //will this be affecting the code later on
    //MARK:- PROPERTIES
    var dataModel:DataModel!
    
    //MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        //made some changes
        title = "CheckLists"
        print("This is going to work")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.delegate = self
        let index =  dataModel.indexOfSelectedCheckList  //default value -1
        print("This is the:\(index)")
        if index >= 0 && index < dataModel.checklists.count {
        //This crashed as there was no d
        let checklist = dataModel.checklists[index]
        performSegue(withIdentifier: segueIdentifiers.showCheckList.rawValue, sender: checklist)
        }
    }
    
    //MARK:- TABLEVIEW DATA SOURCE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.checklists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.checkList.rawValue, for: indexPath)
        cell.textLabel?.text = dataModel.checklists[indexPath.row].name
        
        //Logic for improved items user experience
        var count = dataModel.checklists[indexPath.row].unCheckedItems()
        if dataModel.checklists[indexPath.row].items.count == 0{
            cell.detailTextLabel?.text = "No Items"
        }
        else if count == 0 {
            cell.detailTextLabel?.text = "All Done"
        }else{
            cell.detailTextLabel?.text = "\(count) Remaining"
        }
        
        return cell
    }
    
    //MARK:- TABLEVIEW DELEGATE
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedCheckList = indexPath.row
        let checklist = dataModel.checklists[indexPath.row]
        performSegue(withIdentifier: segueIdentifiers.showCheckList.rawValue, sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.checklists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let nvc = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        let controller = nvc.topViewController as! ListDetailTableViewController
        controller.delegate = self
        let checklist = dataModel.checklists[indexPath.row]
        controller.checkListToEdit = checklist
        present(nvc, animated: true, completion: nil)
    }
    
    //MARK:-NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifiers.showCheckList.rawValue{
            let controller = segue.destination as! CheckListViewController
            //Here the sender is from the perform segue method
            controller.checklist = sender as? CheckList
            print("WHEN user taps:\(dataModel.indexOfSelectedCheckList)")
        }else if segue.identifier == segueIdentifiers.addList.rawValue{
            let nvc = segue.destination as! UINavigationController
            let controller = nvc.topViewController as! ListDetailTableViewController
            controller.delegate = self
        }//the edit methods was done using tableview delegate method
        }
    


    //MARK:- ListDetail tableview delegate
    func listTableViewControllerDidcancel(_ controller: ListDetailTableViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func listTableViewController(_ controller: ListDetailTableViewController, didFinishAdding checkList: CheckList) {
        dataModel.checklists.append(checkList)
        dataModel.sortCheckLists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func listTableViewController(_ controller: ListDetailTableViewController, didFinishEditing checkList: CheckList) {
        if let index = dataModel.checklists.firstIndex(where: {$0 === checkList}){
            let indexpath = IndexPath(item: index, section: 0)
            if let cell = tableView.cellForRow(at: indexpath){
                cell.textLabel?.text = dataModel.checklists[indexpath.row].name
            }
        dataModel.sortCheckLists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK:- UINavigationcontroller delegate
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self{
            dataModel.indexOfSelectedCheckList = -1
        }
    }

}

