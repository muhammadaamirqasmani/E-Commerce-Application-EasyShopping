//
//  ReviewCell.swift
//  EasyShopping
//
//  Created by admin on 27/11/2017.
//  Copyright © 2017 MuhammadAamir. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var reviewImage: UIImageView!
    @IBOutlet weak var ReviewLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        reviewImage.layer.borderWidth = 1
        reviewImage.layer.masksToBounds = false
        reviewImage.layer.borderColor = UIColor.red.cgColor
        reviewImage.layer.cornerRadius = reviewImage.frame.height/2
        reviewImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
