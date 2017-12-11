//
//  CustomTableViewCell.swift
//  EasyShopping
//
//  Created by admin on 20/11/2017.
//  Copyright © 2017 MuhammadAamir. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {


    @IBOutlet weak var ItemImage: UIImageView!
    @IBOutlet weak var ItemName: UILabel!
    @IBOutlet weak var ItemDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        ItemImage.layer.borderWidth = 1
        ItemImage.layer.masksToBounds = false
        ItemImage.layer.borderColor = UIColor.red.cgColor
        ItemImage.layer.cornerRadius = ItemImage.frame.height/2
        ItemImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

