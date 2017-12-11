//
//  CustomCollectionVCell.swift
//  EasyShopping
//
//  Created by admin on 15/11/2017.
//  Copyright © 2017 MuhammadAamir. All rights reserved.
//

import UIKit
import Cosmos

class CustomCollectionVCell: UICollectionViewCell {
    
    @IBOutlet weak var ItemImage: UIImageView!
    @IBOutlet weak var ItemName: UILabel!
    @IBOutlet weak var ItemPrice: UILabel!
    @IBOutlet weak var ItemRating: CosmosView!
}
