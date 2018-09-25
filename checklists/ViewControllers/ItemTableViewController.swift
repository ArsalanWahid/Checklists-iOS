//
//  ItemTableViewController.swift
//  checklists
//
//  Created by Arsalan Wahid Asghar on 9/18/18.
//  Copyright © 2018 asghar. All rights reserved.
//



/*
 
    how to make the date picker menu when date is clicked
 */
import UIKit
import UserNotifications
//MARK:- Delegate
protocol ItemTableViewControllerDelegate:AnyObject{
    func itemTableViewController(_ controller: ItemTableViewController, didFinishAdding item: Item)
    func itemTableViewControllerDidCancel(_ controller: ItemTableViewController)
    func itemTableViewController(_ controller: ItemTableViewController, didFinishEditing Item: Item)
    
}

class ItemTableViewController: UITableViewController {
    
    //MARK:- Properties
    var itemToEdit: Item?
    weak var delegate: ItemTableViewControllerDelegate?
    //will hold the date from the UI
    var dueDate = Date()
    var datePickerVisable = false
    
    
    
    //MARK:- Outlets
    @IBOutlet weak var addItemTextField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDatelabel:UILabel!
    @IBOutlet var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //MARK:- View LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addItemTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addItemTextField.delegate = self
        
        if let item = itemToEdit{
            title = "Edit Item"
            addItemTextField.text = item.name
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate!
        }else{
            //Add an Item
            title = "Add Item"
            doneBarButton.isEnabled = false
        }
        updateDueDateLabel()
    }
    
    //MARK:- TableviewDelegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.section == 1 && indexPath.row == 1{
            return indexPath
        }else{
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2{
            return 217
        }else{
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        addItemTextField.resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1{
            if !datePickerVisable{
                showDatePicker()
            }else{
                hideDatePicker()
            }
        }
    }
    
    //MARK:- Custom Tableview DataSource
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisable {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
        
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView,
                               indentationLevelForRowAt: newIndexPath)
    }
    

    
    //MARK:- Actions
    @IBAction func cancel(_ sender: Any) {
        delegate?.itemTableViewControllerDidCancel(self)
    }
    
    //Differene Logic based on Edit/ Add condition
    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit{
            // This will update the data model as well since item passed
            // was a class type
            item.name = addItemTextField.text!      // pass the name of item added
            item.shouldRemind = shouldRemindSwitch.isOn  // pass the switch status
            item.dueDate = dueDate                  //pass the date to be notified
            item.scheduleNotification()
            delegate?.itemTableViewController(self, didFinishEditing: item)
        }else{
            //Make a new item
            let item = Item(name: addItemTextField.text!)
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            print("IS the value being set\(item.shouldRemind)")
            item.scheduleNotification()
            delegate?.itemTableViewController(self, didFinishAdding: item)
        }
    }
    @IBAction func updatedate(_ sender: Any) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    @IBAction func shouldRemindToggle(_ sender: Any) {
        addItemTextField.resignFirstResponder()
        if shouldRemindSwitch.isOn{
            //ask once for user notification permissin her
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {
                granted, error in /* do nothing */
            }
        }
    
    }
    
}

  //MARK:- TextFieldDelegate
extension ItemTableViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = addItemTextField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string)
        doneBarButton.isEnabled = (newText.count > 0)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
}

//MARK:- DatePicker methods
extension ItemTableViewController{
    //Just sets the format of the date
    func updateDueDateLabel(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDatelabel.text = formatter.string(from: dueDate)
    }
    
    //MARK:- Date Picker
    func showDatePicker() {
        datePickerVisable = true
        
        let indexPathDateRow = IndexPath(row: 1, section: 1)
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        
        datePicker.setDate(dueDate, animated: false)
    }
    
    func hideDatePicker() {
        if datePickerVisable {
            datePickerVisable = false
            
            let indexPathDateRow = IndexPath(row: 1, section: 1)
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            
            if let cell = tableView.cellForRow(at: indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }

}
