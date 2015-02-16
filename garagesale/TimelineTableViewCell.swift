//
//  TimelineTableViewCell.swift
//  garagesale
//
//  Created by mitchell hudson on 1/24/15.
//  Copyright (c) 2015 mitchell hudson. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var addToSpringshowButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func addToSpringShowButtonTapped(sender: AnyObject) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
