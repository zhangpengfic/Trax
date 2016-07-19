//
//  EditWaypointViewController.swift
//  Trax
//
//  Created by Alfred on 16/7/18.
//  Copyright © 2016年 WanXunAlfred. All rights reserved.
//

import UIKit

class EditWaypointViewController: UIViewController,UITextFieldDelegate {
    
    
    var waypointToEdit:EditableWaypoint? {didSet{updateUI()}}
    
    @IBOutlet weak var nameTextField: UITextField!{didSet{nameTextField.delegate=self}}
    
    @IBOutlet weak var infoTextField: UITextField!{didSet{infoTextField.delegate=self}}
    @IBAction func Done(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateUI(){
        nameTextField?.text=waypointToEdit?.name
        infoTextField?.text=waypointToEdit?.info
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        observeTextFields()
    }
    
    var ntfObserver: NSObjectProtocol?
    var itfObserver: NSObjectProtocol?
    
    func observeTextFields() {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        ntfObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: nameTextField, queue: queue) { (NSNotification) in
            if let waypoint = self.waypointToEdit {
                waypoint.name = self.nameTextField.text
            }
        }
        itfObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: infoTextField, queue: queue) { (NSNotification) in
            if let waypoint = self.waypointToEdit {
                waypoint.info = self.infoTextField.text
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        if let observer = ntfObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
        if let observer = itfObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
        updateUI()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
