//
//  RegisterVC.swift
//  EasyShopping
//
//  Created by admin on 13/11/2017.
//  Copyright © 2017 MuhammadAamir. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseStorage

class RegisterVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var docRef : DocumentReference? = nil
    var imagePicker = UIImagePickerController()
    var product = ["Mobile","Cloth","Tablet","Home Appliences","Laptop"]
    var service = ["Plumber","Electrition","Mobile Repaing","Software Development","Laptop Repaing"]
    var locationManager = CLLocationManager()
    var location: CLLocation?
    let db = Firestore.firestore()
    var productType = ""
    let userID = Auth.auth().currentUser!.uid
    var data = NSData()
    let red = UIColor(red: 234.0/255.0, green: 36.0/255.0, blue: 37.0/255.0, alpha: 0.7)

    @IBOutlet weak var ItemImage: UIImageView!
    @IBOutlet weak var ItemDescription: UITextView!
    @IBOutlet weak var ItemName: UITextField!
    @IBOutlet weak var UserContact: UITextField!
    @IBOutlet weak var ProductOrService: UISegmentedControl!
    @IBOutlet weak var ProductAndService: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProductAndService.setValue(red, forKey: "textColor")
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func uploadImageTOFirebaseStorage(data: NSData){
        let storage = Storage.storage().reference(withPath: "user/userItemImage/\(String(describing: ItemName.text)).jpeg")
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
                
                self.ItemName.text = ""
                self.ItemDescription.text = ""
                self.ItemImage.image = nil
            }
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if ProductOrService.selectedSegmentIndex == 0{
            return product.count
        }else if ProductOrService.selectedSegmentIndex == 1 {
            return service.count
        }
        return 0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if ProductOrService.selectedSegmentIndex == 0{
            return product[row]
        }else if ProductOrService.selectedSegmentIndex == 1 {
            return service[row]
        }
        return ""
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if ProductOrService.selectedSegmentIndex == 0{
            ProductOrService.setTitle(product[row], forSegmentAt: 0)
            self.productType = ProductOrService.titleForSegment(at: 0)!
            print(productType)
        }else if ProductOrService.selectedSegmentIndex == 1 {
            ProductOrService.setTitle(service[row], forSegmentAt: 1)
            self.productType = ProductOrService.titleForSegment(at: 1)!
            print(productType)
            
        }
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
    
    @IBAction func SelectingProduct(_ sender: Any) {
       ProductAndService.reloadAllComponents()
        if ProductOrService.selectedSegmentIndex == 0{
            self.productType = ProductOrService.titleForSegment(at: 0)!
            print(productType)
        }else if ProductOrService.selectedSegmentIndex == 1 {
           
        }
    }
    
    @IBAction func RegisterItem(_ sender: Any) {
        
        uploadImageTOFirebaseStorage(data: data)
        
        self.dismiss(animated: true, completion: nil)

        
    }
}




extension RegisterVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.ItemImage.image = image
        self.data = UIImageJPEGRepresentation(image, 0.8)! as NSData
        self.dismiss(animated: true, completion: nil)
    }
  
}

extension RegisterVC: CLLocationManagerDelegate{
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last!

    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
}
