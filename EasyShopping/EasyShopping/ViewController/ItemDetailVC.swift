//
//  ItemDetailVC.swift
//  EasyShopping
//
//  Created by admin on 22/11/2017.
//  Copyright © 2017 MuhammadAamir. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import ObjectMapper

class ItemDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    

    @IBOutlet weak var ItemImage: UIImageView!
    @IBOutlet weak var ItemName: UILabel!
    @IBOutlet weak var ProductType: UILabel!
    @IBOutlet weak var UserContact: UILabel!
    @IBOutlet weak var ItemDescription: UILabel!
    @IBOutlet weak var ReviewTable: UITableView!
    
    @IBOutlet weak var ReviewField: UITextField!
    
    var appDelegte = UIApplication.shared.delegate as! AppDelegate
    var variableitemName = String()
    var variableProductType = String()
    var variableUserContact = String()
    var variableItemDescription = String()
    var variableLatitude = Double()
    var variableLongitude = Double()
    var variableItemImage = UIImage()
    var variablePostID = String()
    var docRef : DocumentReference? = nil
    let db = Firestore.firestore()
    let userID = Auth.auth().currentUser!.uid
    var quoteListener: ListenerRegistration!
    var reviewsArray = [ReviewDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ReviewTable.delegate = self
        ReviewTable.dataSource = self
        
        ItemImage.image = variableItemImage
        ItemName.text = variableitemName
        ProductType.text = variableProductType
        UserContact.text = "Seller Contact No.\(variableUserContact)"
        ItemDescription.text = variableItemDescription
        
        
        quoteListener = db.collection("reviews").whereField("productID", isEqualTo: variablePostID).addSnapshotListener({  (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let array = querySnapshot!.documents.map({Mapper<ReviewDetail>().map(JSON: $0.data())!})
                print(array)
                ReviewDetail.reviewDetail = array
                self.reviewsArray = array
                self.ReviewTable.reloadData()
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        cell.ReviewLable.text = reviewsArray[indexPath.row].reviewsUser
        cell.reviewImage.sd_setImage(with: URL(string: reviewsArray[indexPath.row].ImageURL!), placeholderImage: UIImage(named: "placeholder.png"))
        return cell
    }
    
    @IBAction func directionBtn(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        
        desVC.variableLatitudeMap = variableLatitude
        desVC.variableLongitudeMap = variableLongitude
        desVC.variableItemName = variableitemName
        
        
        self.present(desVC, animated: true, completion: nil)
        
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
 
    @IBAction func reviewPost(_ sender: Any) {
        if ReviewField.text != ""  && ReviewField != nil{
            guard let review = self.ReviewField.text else {return}
            guard let ImageURL = self.appDelegte.UserProfleImage else {return}
            getReviewsFromUser(reviewsUser: review, productID: variablePostID, uid: userID, ImageURL: ImageURL)
            ReviewField.text = ""
        }else{
            return
        }
    }
    
    func getReviewsFromUser (reviewsUser: String, productID: String, uid: String, ImageURL: String ){
        let docData: [String: Any] = ["reviewsUser": reviewsUser, "productID": productID, "uid": uid, "ImageURL": ImageURL]
        docRef = db.collection("reviews").addDocument(data: docData){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.docRef!.documentID)")
            }
        }
    }
    
}
