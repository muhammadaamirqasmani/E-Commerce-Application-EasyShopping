//
//  MainVC.swift
//  EasyShopping
//
//  Created by admin on 11/11/2017.
//  Copyright © 2017 MuhammadAamir. All rights reserved.
//

import UIKit
import Firebase
import ObjectMapper
import SDWebImage


class MainVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPost: UITableView!
    @IBOutlet weak var backGroundImage: UIImageView!
    
    var quoteListener: ListenerRegistration!
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let uid = Auth.auth().currentUser?.uid
     var ItemMenu = [ItemObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPost.delegate = self
        userPost.dataSource = self
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        
       
        
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.red.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        activityView.startAnimating()
        quoteListener = Firestore.firestore().collection("user").whereField("uid", isEqualTo: uid).addSnapshotListener({  (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let url = URL(string: document.data()["ImageURL"] as! String)
                    self.profileImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
                    self.backGroundImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
                    self.userName.text = document.data()["UserName"] as? String ?? "(none)"
                }
                self.activityView.stopAnimating()
            }
        })
        
        quoteListener = Firestore.firestore().collection("product").whereField("uid", isEqualTo: uid).addSnapshotListener({  (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let array = querySnapshot!.documents.map({Mapper<ItemObject>().map(JSON: $0.data())!})
                print(array)
                ItemObject.ItemDetail = array
                self.ItemMenu = array
                self.userPost.reloadData()
                self.activityView.stopAnimating()
            }
        })
        
        
    }
    @IBAction func LogOut(_ sender: Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ItemMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        
        let url = URL(string: (ItemMenu[indexPath.row].ImageURL as! String))
        
        cell.ItemName.text = ItemMenu[indexPath.row].ItemName
        cell.ItemDescription.text = ItemMenu[indexPath.row].ItemDescription
        cell.ItemImage.sd_setImage(with: url, completed: nil)
        return cell
    }
    
    
    
}


