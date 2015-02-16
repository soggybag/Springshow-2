//
//  ViewController.swift
//  garagesale
//
//  Created by mitchell hudson on 1/24/15.
//  Copyright (c) 2015 mitchell hudson. All rights reserved.
//


// Google Client ID 
// 1034915895741-1jdtge43ha0s6orfkcpledsk4n0pjoer.apps.googleusercontent.com

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.setObject("user1", forKey: "username")
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            if success {
                
            } else {
                
            }
        }
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            if success {
                println("Object ")
            } else {
                println("Error: \(error.description)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

