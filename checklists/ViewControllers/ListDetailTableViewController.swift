//
//  ListDetailTableViewController.swift
//  checklists
//
//  Created by Arsalan Wahid Asghar on 9/19/18.
//  Copyright © 2018 asghar. All rights reserved.
//

import UIKit


    //MARK:- Delegate
protocol ListDetailTableViewControllerDelegate:AnyObject{
    func listTableViewControllerDidcancel(_ controller: ListDetailTableViewController)
    func listTableViewController(_ controller: ListDetailTableViewController, didFinishAdding checkList: CheckList)
    func listTableViewController(_ controller: ListDetailTableViewController, didFinishEditing checkList: CheckList)

}


class ListDetailTableViewController: UITableViewController {

    //MARK:- Properties
    var checkListToEdit:CheckList?
    weak var delegate:ListDetailTableViewControllerDelegate?
    //this will hold the icon name
    var iconName = "Folder"
    
    //MARK:- Outlets
    @IBOutlet weak var addCheckList:UITextField!
    @IBOutlet weak var donebarButton:UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    //MARK:- Actions

    @IBAction func cancel(_ sender: Any) {
        delegate?.listTableViewControllerDidcancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        if let checkList = checkListToEdit{
            checkList.name = addCheckList.text!
            //When edit set icon taken from delegate
            checkList.iconName = iconName
            delegate?.listTableViewController(self, didFinishEditing: checkList)
        }else{
            //make a new checkList and then pass
            let checklist = CheckList(name: addCheckList.text!)
            //Will be folder icon by defaut
            checklist.iconName = iconName
            delegate?.listTableViewController(self, didFinishAdding: checklist)
        }
    }
    
    //MARK:- Life Cycle
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
            iconName = checklist.iconName // when there is a checkList
        }else{
            title = "Add CheckList"
            donebarButton.isEnabled = false
            iconImageView.image = UIImage(named: iconName) //when Adding a checklist icon should be something
        }
      
    }

    
    //MARK:- Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickIcon"{
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
}

    //MARK:- TextFieldDelegate
extension ListDetailTableViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = addCheckList.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string)
        donebarButton.isEnabled = newText.count > 0
        return true
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        //Seciton start with index zero offcourse
        //Allows control over which cell can or cant be tapped
        if indexPath.section == 1{
            return indexPath
        }else{
            return nil
        }
    }
}

    //MARK:- IconPickerViewControllerDelegate
extension ListDetailTableViewController:IconPickerViewControllerDelegate{
    func inconPickerViewController(_ controller: IconPickerViewController, didPick iconName: String) {
        //set the icon name to the one select
        self.iconName = iconName
        //Show it on screen
        self.iconImageView.image = UIImage(named: iconName)
        //Pop the controller
        //This let is need as UInav is an optional
        let _ = navigationController?.popViewController(animated: true)
    }
}
