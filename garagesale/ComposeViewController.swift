//
//  ComposeViewController.swift
//  garagesale
//
//  Created by mitchell hudson on 1/24/15.
//  Copyright (c) 2015 mitchell hudson. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var characterRemainingLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    
    // MARK: - IBActions
    
    @IBAction func sendMessage(sender: UIBarButtonItem) {
        let message = PFObject(className: "Comment")
        message["comment"] = textView.text
        message["author"] = PFUser.currentUser()
        
        message.saveInBackground()
        
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: - View Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.becomeFirstResponder()
        textView.delegate = self
        // Get rid of that extra space at the top of the text view
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(animated: Bool) {
        let user = PFUser.currentUser()
        if user != nil {
            userLabel.text = user.username
        } else {
            
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newLength = (textView.text as NSString).length + (text as NSString).length - range.length
        let remainingCharacters = 140 - newLength
        characterRemainingLabel.text = "\(remainingCharacters)"
        
        if newLength > 130 {
            characterRemainingLabel.textColor = UIColor.redColor()
        } else {
            characterRemainingLabel.textColor = UIColor.lightGrayColor()
        }
        
        if newLength < 140 {
            return true
        } else {
            return false
        }
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
