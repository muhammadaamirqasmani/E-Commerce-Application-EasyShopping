//
//  HomeVC.swift
//  SHOPSTA
//
//  Created by admin on 02/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import Firebase
import ObjectMapper
import SDWebImage


class HomeVC: UIViewController {
 

    @IBOutlet weak var pictureCollection: UICollectionView!
    
    var picturearray = [pictureObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        pictureCollection.delegate = self
//        pictureCollection.dataSource = self
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return picturearray.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCollectionVC
//
//        cell.ItemImage.sd_setImage(with: URL(string: picturearray[indexPath.row].ImageURL!), placeholderImage: UIImage(named: "placeholder.png"))
//        return cell
//
//    }
    

}
