//
//  HomeVC.swift
//  SHOPSTA
//
//  Created by admin on 02/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import ObjectMapper
import SDWebImage


class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
 

    @IBOutlet weak var pictureCollection: UICollectionView!
    
    var picturearray = [pictureObject]()
    let userID = Auth.auth().currentUser!.uid
    var imagePicker = UIImagePickerController()
    let db = Firestore.firestore()
    var data = NSData()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureCollection.delegate = self
        pictureCollection.dataSource = self
        
        
    }
    
    func uploadImageTOFirebaseStorage(data: NSData){
        let storage = Storage.storage().reference(withPath: "user/userShopstaNode/\(String(describing: ItemName.text)).jpeg")
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        let uploadTask = storage.putData(data as Data, metadata: uploadMetaData) { (metadata, error) in
            if (error != nil){
                print("I received an error! \(String(describing: error?.localizedDescription))")
            }else {
                let downloadURL = metadata?.downloadURL()?.absoluteString
                print("Upload Complete! Here's some metadata! \(String(describing: metadata))")
                print("This is Firebase image ___________URL____________\(String(describing: downloadURL))")
                
                let when = DispatchTime.now() + 3 // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                    // Your code with delay
                    guard let itemName = self.ItemName.text else {return}
                    guard let itemDes = self.ItemDescription.text else {return}
                    guard let UserContact = self.UserContact.text else {return}
                    self.getDataFromController(itemName: itemName, ItemDescription: itemDes, UserContact: UserContact, lat: (self.location?.coordinate.latitude)!, lon: (self.location?.coordinate.longitude)!, ProductType: self.productType, uid: self.userID, ImageURL: downloadURL!)
                }
            }
        }
        
        
        
    }
    
    
    func getDataFromController (itemName: String, ItemDescription: String, UserContact: String, lat:Double, lon: Double, ProductType: String, uid: String, ImageURL: String ){
        let docData: [String: Any] = ["ItemName": itemName, "ItemDescription": ItemDescription, "UserContact": UserContact, "Latitude": lat, "Longitude": lon, "ProductType":ProductType, "uid": uid, "ImageURL": ImageURL]
        docRef = db.collection("product").addDocument(data: docData){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.docRef!.documentID)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picturearray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCollectionVC

        cell.ItemImage.sd_setImage(with: URL(string: picturearray[indexPath.row].ImageURL!), placeholderImage: UIImage(named: "placeholder.png"))
        return cell

    }
    
    @IBAction func ItemPicture(_ sender: Any) {
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate=self
        
        let actionController = UIAlertController(title: "Profile Image", message: "Please select profile image for Distill", preferredStyle: .actionSheet)
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        actionController.addAction(galleryAction)
        actionController.addAction(cancel)
        actionController.addAction(cameraAction)
        self.present(actionController, animated: true, completion: nil)
    }
    

}
extension HomeVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.ItemImage.image = image
        self.data = UIImageJPEGRepresentation(image, 0.8)! as NSData
        self.dismiss(animated: true, completion: nil)
    }
    
}
