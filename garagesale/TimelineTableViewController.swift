//
//  TimelineTableViewController.swift
//  garagesale
//
//  Created by mitchell hudson on 1/24/15.
//  Copyright (c) 2015 mitchell hudson. All rights reserved.
//

// TODO: Lazy loading images: https://github.com/rs/SDWebImage 
//      http://www.theappguruz.com/ios/ios-lazy-loading-images/

// TODO: Change to PFLogInViewController
// TODO: Change to PFQueryTableViewController
// TODO: PFImageView
// TODO: PFTableViewCell

import UIKit

class TimelineTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var timelineData = [PFObject]()
    let dateFormatter = NSDateFormatter()
    
    // MARK: IBActions
    
    @IBAction func loadData() {
        timelineData = [PFObject]()
        
        let data = PFQuery(className: "Comment")
        data.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if error == nil {
                println("Success!")
                for object in objects {
                    self.timelineData.append(object as PFObject)
                    // self.timelineData.addObject(object)
                }
            } else {
                println("Error Load Data \(error.description) \(error.userInfo!)")
            }
            
            self.timelineData = self.timelineData.reverse()
            self.tableView.reloadData()
        }
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
    
    // MARK: - Setup 
    
    func setup() {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    }
    
    // MARK: - Log Out 
    
    func logout(sender: UIButton) {
        PFUser.logOut()
        // loginSignup()
    }
    
    func settingsBarButtonItemTapped(sender: UIBarButtonItem) {
        performSegueWithIdentifier("showSettingsSegue", sender: self)
    }
    
    func addBarButtonItemTapped(sender: UIBarButtonItem) {
        println("Add bar button item")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidAppear(animated: Bool) {
        // Create and set right bar button items 
        let addImage = UIImage(named: "add-icon")
        let addBarButtonItem = UIBarButtonItem(image: addImage, style: UIBarButtonItemStyle.Plain, target: self, action: "addBarButtonItemTapped:")
        let settingsImage = UIImage(named: "gear-icon")
        let settingsBarButtonItem = UIBarButtonItem(image: settingsImage, style: UIBarButtonItemStyle.Plain, target: self, action: "settingsBarButtonItemTapped:")
        
        navigationItem.rightBarButtonItems = [addBarButtonItem, settingsBarButtonItem]
        
        setup()
        self.loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineData.count
    }
    
    /*
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return height
    }
    */
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TimelineTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as TimelineTableViewCell
        
        cell.alpha = 0
        
        let comment = timelineData[indexPath.row]
        
        cell.messageText.text = comment.objectForKey("comment") as String
        cell.timestampLabel.text = dateFormatter.stringFromDate(comment.createdAt)
        
        // Get the image
        if let imageFile: PFFile = comment.objectForKey("image")as? PFFile {
            imageFile.getDataInBackgroundWithBlock({ (imageData: NSData!, error: NSError!) -> Void in
                if error == nil {
                    let theImage = UIImage(data: imageData)
                    cell.commentImage.image = theImage
                } else {
                    println("comment image error: \(error.description)")
                }
            })
        }
        
        let findUser = PFUser.query()
        findUser.whereKey("objectId", equalTo: comment.objectForKey("author").objectId)
        findUser.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if let user: PFUser = objects.last as? PFUser {
                cell.userNameLabel.text = user.username
                // Profile image 
               
                if let profileImage: PFFile = user["profileImage"] as? PFFile {
                    profileImage.getDataInBackgroundWithBlock({ (imageData: NSData!, error: NSError!) -> Void in
                        if error == nil {
                            let image = UIImage(data: imageData)
                            cell.profileImageView.image = image
                        } else {
                            println("user image error: \(error.description)")
                        }
                    })
                    UIView.animateWithDuration(0.4, animations: { () -> Void in
                        cell.alpha = 1
                    })
                }
            }
        }
        
        
        return cell
    }


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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Utilitie Functions
    
}
