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
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
        updateUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        observeTextFields()
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
    
    //MARK: - Image
    var imageView = UIImageView()
    
    @IBOutlet weak var imageViewContainer: UIView!{
        didSet{
            imageViewContainer.addSubview(imageView)
        }
    }
    
    
    //MARK: - TextField
    
    @IBOutlet weak var nameTextField: UITextField!{didSet{nameTextField.delegate=self}}
    
    @IBOutlet weak var infoTextField: UITextField!{didSet{infoTextField.delegate=self}}
    @IBAction func Done(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateUI(){
        nameTextField?.text=waypointToEdit?.name
        infoTextField?.text=waypointToEdit?.info
        updateImage()
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
    
  
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension EditWaypointViewController {
    func updateImage() {
        if let url = waypointToEdit?.imageURL {
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { [weak self] in
                if let imageData = NSData(contentsOfURL: url) {
                    if url == self?.waypointToEdit?.imageURL {
                        if let image = UIImage(data: imageData) {
                            dispatch_async(dispatch_get_main_queue()) {
                                self?.imageView.image = image
                                self?.makeRoomForImage()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func makeRoomForImage() {
        var extraHeight: CGFloat = 0
        if imageView.image?.aspectRatio > 0 {
            if let width = imageView.superview?.frame.size.width {
                let height = width / imageView.image!.aspectRatio
                extraHeight = height - imageView.frame.height
                imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            }
        } else {
            extraHeight = -imageView.frame.height
            imageView.frame = CGRectZero
        }
        
        preferredContentSize = CGSize(width: preferredContentSize.width, height: preferredContentSize.height + extraHeight)
    }
    
    
}

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}
