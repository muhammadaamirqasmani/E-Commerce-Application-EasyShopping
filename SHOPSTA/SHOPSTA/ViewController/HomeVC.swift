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


class HomeVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
 

    @IBOutlet weak var pictureCollection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureCollection.delegate = self
        pictureCollection.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    

}
