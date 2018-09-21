//
//  ItemTableViewController.swift
//  checklists
//
//  Created by Arsalan Wahid Asghar on 9/18/18.
//  Copyright © 2018 asghar. All rights reserved.
//

import UIKit


protocol ItemTableViewControllerDelegate:AnyObject{
    func itemTableViewController(_ controller: ItemTableViewController, didFinishAdding item: Item)
    func itemTableViewControllerDidCancel(_ controller: ItemTableViewController)
    func itemTableViewController(_ controller: ItemTableViewController, didFinishEditing Item: Item)
    
}

class ItemTableViewController: UITableViewController,UITextFieldDelegate {
    
    //MARK:- PROPERTIES
    var itemToEdit: Item?
    weak var delegate: ItemTableViewControllerDelegate?
    
    
    //MARK:- OUTLETS
    @IBOutlet weak var addItemTextField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    //MARK:- VIEW LIFECYCLE
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
        }else{
            title = "Add Item"
            doneBarButton.isEnabled = false
        }
    }
    
    //MARK:- TABLEVIEW DELEGATE
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    //MARK:- ACTIONS
    @IBAction func cancel(_ sender: Any) {
        delegate?.itemTableViewControllerDidCancel(self)
    }
    
    //Differene Logic based on Edit/ Add condition
    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit{
            // This will update the data model as well since item passed
            // was a class type
            item.name = addItemTextField.text!
            delegate?.itemTableViewController(self, didFinishEditing: item)
        }else{
            let item = Item(name: addItemTextField.text!)
            delegate?.itemTableViewController(self, didFinishAdding: item)
        }
    }
    
    //MARK:- TEXTFILED DELEGATE
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = addItemTextField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string)
        doneBarButton.isEnabled = (newText.count > 0)
        return true
    }
    
}
