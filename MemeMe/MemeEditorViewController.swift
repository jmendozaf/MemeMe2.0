//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Javier Mendoza on 25/8/16.
//  Copyright © 2016 Javier Mendoza. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{

    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // raw values correspond to sender tags
    enum sourceType : Int {
        case PhotoLibrary = 0,Camera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField(topTextField)
        setupTextField(bottomTextField)
        reset()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true     // status bar should be hidden
    }
    
    func reset(){
        memeImage.image=nil
        topTextField.text="TOP"
        bottomTextField.text="BOTTOM"
        shareButton.enabled = false
    }
    
    func setupTextField(textField: UITextField) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -5
        ]
        textField.defaultTextAttributes = memeTextAttributes
        
        textField.textAlignment = .Center
        textField.delegate = self
    }
    

    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        resetViewFrame()
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            resetViewFrame()
        }
    }
    
    func resetViewFrame(){
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func hideToolbar(visible: Bool) {
        toolBar.hidden = visible
        navigationBar.hidden = visible
    }
    
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        let memedImage = generateMemedImage()
        let activity = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activity.completionWithItemsHandler =  { activity, success, items, error in
            if success {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }

        presentViewController(activity, animated: true, completion: nil)
    
    }
    
    func save() {
        _ = Meme(topText: topTextField.text, bottomTextString: bottomTextField.text, originalImage: memeImage.image, memeImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        
        hideToolbar(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        hideToolbar(false)
        return memedImage
    }
    
    @IBAction func cancelMeme(sender: UIBarButtonItem) {
        reset()
    }

    
    @IBAction func pickAnImage(sender: AnyObject) {
        
        memeImage.image=nil
        let imagePicker = UIImagePickerController()
        imagePicker.delegate=self
        
        switch (sourceType(rawValue: sender.tag)!) {
        case .PhotoLibrary:
            imagePicker.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
        case .Camera:
            imagePicker.sourceType=UIImagePickerControllerSourceType.Camera
        }
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImage.image = image
            shareButton.enabled = true
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

}

