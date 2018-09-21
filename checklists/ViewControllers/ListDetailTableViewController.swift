//
//  ListDetailTableViewController.swift
//  checklists
//
//  Created by Arsalan Wahid Asghar on 9/19/18.
//  Copyright © 2018 asghar. All rights reserved.
//

import UIKit


protocol ListDetailTableViewControllerDelegate:AnyObject{
    
    func listTableViewControllerDidcancel(_ controller: ListDetailTableViewController)
    func listTableViewController(_ controller: ListDetailTableViewController, didFinishAdding checkList: CheckList)
    func listTableViewController(_ controller: ListDetailTableViewController, didFinishEditing checkList: CheckList)

}


class ListDetailTableViewController: UITableViewController,UITextFieldDelegate {

    //MARK:- Properties
    var checkListToEdit:CheckList?
    weak var delegate:ListDetailTableViewControllerDelegate?
    
    //MARK:- Outlets
    @IBOutlet weak var addCheckList:UITextField!
    @IBOutlet weak var donebarButton:UIBarButtonItem!
    
    
    //MARK:- Actions

    @IBAction func cancel(_ sender: Any) {
        delegate?.listTableViewControllerDidcancel(self)
    }
    @IBAction func done(_ sender: Any) {
        if let checkList = checkListToEdit{
            checkList.name = addCheckList.text!
            delegate?.listTableViewController(self, didFinishEditing: checkList)
        }else{
            //make a new checkList and then pass
            let checklist = CheckList(name: addCheckList.text!)
            delegate?.listTableViewController(self, didFinishAdding: checklist)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        addCheckList.becomeFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addCheckList.delegate = self
        if let checklist = checkListToEdit{
            title = "Edit CheckList"
            addCheckList.text = checklist.name
            donebarButton.isEnabled = true
        }else{
            title = "Add CheckList"
            donebarButton.isEnabled = false
        }
      
    }

    // MARK: - Table view data source
    
    //MARK:- Table view delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //MARK:- TextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = addCheckList.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string)
        donebarButton.isEnabled = newText.count > 0
        return true
    }
}
