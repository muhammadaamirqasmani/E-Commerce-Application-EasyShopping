//
//  HomeVC.swift
//  EasyShopping
//
//  Created by admin on 16/11/2017.
//  Copyright © 2017 MuhammadAamir. All rights reserved.
//

import UIKit
import Firebase
import ObjectMapper
import SDWebImage

class HomeVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var ItemCollectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    
    var productOrservice = ["Mobile","Cloth","Tablet","Home Appliences","Laptop","Plumber","Electrition","Mobile Repaing","Software Development","Laptop Repaing"]

//    var docRef : DocumentReference? = nil
    var quoteListener: ListenerRegistration!
    var ItemMenu = [ItemObject]()
    var CurrentItemMenu = [ItemObject]()
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.placeholder = "Search Item by Name"
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        ItemCollectionView.delegate = self
        ItemCollectionView.dataSource = self
        
        
        activityView.startAnimating()
        quoteListener = Firestore.firestore().collection("product").addSnapshotListener({  (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let array = querySnapshot!.documents.map({ (data) -> ItemObject in
                    let obj = Mapper<ItemObject>().map(JSON: data.data())!
                    obj.id = data.documentID
                    return obj
                })
                print(array)
                ItemObject.ItemDetail = array
                self.ItemMenu = array
                self.CurrentItemMenu = self.ItemMenu
                self.ItemCollectionView.reloadData()
                self.activityView.stopAnimating()
            }
        })
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         quoteListener.remove()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            CurrentItemMenu = ItemMenu
            ItemCollectionView.reloadData()
            return
        }
        CurrentItemMenu = ItemMenu.filter({ ItemObject -> Bool in
            (ItemObject.ItemName?.lowercased().contains(searchText.lowercased()))!
            })
            self.ItemCollectionView.reloadData()    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        print("\(ItemMenu.count)")
        return CurrentItemMenu.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCollectionVCell
//        let url = URL(string: ItemMenu[indexPath.row].ImageURL!)
//        let data = try! Data(contentsOf: url!)
        
        cell.ItemImage.sd_setImage(with: URL(string: CurrentItemMenu[indexPath.row].ImageURL!), placeholderImage: UIImage(named: "placeholder.png"))
        cell.ItemName.text = CurrentItemMenu[indexPath.row].ItemName
        cell.ItemPrice.text = CurrentItemMenu[indexPath.row].ProductType
        cell.ItemRating.rating = Double((CurrentItemMenu[indexPath.row].ItemRating ?? 0))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "ItemDetailVC") as! ItemDetailVC
        let url = URL(string: CurrentItemMenu[indexPath.row].ImageURL!)
        let data = try? Data(contentsOf: url!)
        
        desVC.variableItemImage =  UIImage(data: data!)!
        desVC.variableUserContact = CurrentItemMenu[indexPath.row].UserContact!
        desVC.variableitemName = CurrentItemMenu[indexPath.row].ItemName!
        desVC.variableItemDescription = CurrentItemMenu[indexPath.row].ItemDescription!
        desVC.variableProductType = CurrentItemMenu[indexPath.row].ProductType!
        desVC.variableLatitude = CurrentItemMenu[indexPath.row].Latitude!
        desVC.variableLongitude = CurrentItemMenu[indexPath.row].Longitude!
        desVC.variablePostID = CurrentItemMenu[indexPath.row].id!
//        print(documentID)
        print(desVC.variablePostID)
        
        self.present(desVC, animated: true, completion: nil)
    }
    
}



