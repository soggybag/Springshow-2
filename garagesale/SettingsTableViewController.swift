//
//  SettingsTableViewController.swift
//  garagesale
//
//  Created by mitchell hudson on 2/14/15.
//  Copyright (c) 2015 mitchell hudson. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: PFUser!
    var profile: PFObject!
    
    @IBOutlet weak var loginTableViewCell: UITableViewCell!
    @IBOutlet weak var userDetailsTableViewCell: UITableViewCell!
    
    
    @IBAction func setProfileImageButtonTapped(sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: { () -> Void in
            
        })
    }
    
    
    
    func displayUser() {
        if let username = user.username {
            userDetailsTableViewCell.textLabel?.text = username
        }
        
        if let firstName = profile.objectForKey("firstName") as? String {
            if let lastName = profile.objectForKey("lastName") as? String {
                if let studentId = profile.objectForKey("studentId") as? String {
                    userDetailsTableViewCell.detailTextLabel?.text = "\(firstName) \(lastName) \(studentId)"
                }
            }
        }
    }
    
    
    func getUser() {
        user = PFUser.currentUser()
        if user != nil {
            if let profileImage: PFFile = user["profileImage"] as? PFFile {
                profileImage.getDataInBackgroundWithBlock({ (imageData: NSData!, error: NSError!) -> Void in
                    if error == nil {
                        println("settings user image loaded")
                        let image = UIImage(data: imageData)
                        self.userDetailsTableViewCell.imageView?.image = image
                    } else {
                        println("user image error: \(error.description)")
                    }
                })
            }
        }
        
        var query = PFQuery(className: "Profile")
        query.whereKey("user", equalTo: PFUser.currentUser())
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if objects.count > 0 {
                    self.profile = objects[0] as PFObject
                }
            } else {
                println("settings profile query error:\(error)")
            }
            
            self.displayUser()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // println("Settings view did load")
        getUser()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if PFUser.currentUser() == nil {
            println("Not logged in")
            loginTableViewCell.textLabel?.text = "Log in"
        } else {
            println("\(PFUser.currentUser().username) is logged in")
            loginTableViewCell.textLabel?.text = "Log out"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Image Picker
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary!) {
        let pickedImage: UIImage = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        let scaledImage = self.scaleImageWith(pickedImage, and: CGSizeMake(100, 100))
        let imageData = UIImagePNGRepresentation(scaledImage)
        let imageFile: PFFile = PFFile(data: imageData)
        PFUser.currentUser().setObject(imageFile, forKey: "profileImage")
        PFUser.currentUser().saveInBackground()
        picker.dismissViewControllerAnimated(true, nil)
    }
    
    
    func scaleImageWith(image: UIImage, and size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    
    // MARK: - Table view data source

    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "toLoginSegue" {
            // Check the login status
            if PFUser.currentUser() != nil {
                // Logged in, so log out
                println("Logging out")
                PFUser.logOut()
            }
        }
    }
   

}
