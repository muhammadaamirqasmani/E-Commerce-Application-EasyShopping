//
//  ItemObject.swift
//  EasyShopping
//
//  Created by admin on 20/11/2017.
//  Copyright © 2017 MuhammadAamir. All rights reserved.
//

import Foundation
import ObjectMapper
//import FirebaseFirestore
//protocol DocumentSerializable {
//    init?(dictionary:[String:Any])
//}
//
//struct ItemObject {
//
//    var ItemName: String
//    var ItemDescription: String
//    var Latitude: Double
//    var Longitude: Double
//    var ProductType: String
//    var UserContact: String
//    var ImageURL: String
//
//    var dictionary:[String:Any]{
//        return[
//        "ImageURL" : ImageURL,
//        "UserContact" : UserContact,
//        "ProductType" : ProductType,
//        "Latitude" : Latitude,
//        "Longitude" : Longitude,
//        "ItemDescription" : ItemDescription,
//        "ItemName" : ItemName
//        ]
//    }
//}
//extension ItemObject : DocumentSerializable{
//    init?(dictionary: [String : Any]) {
//        guard let ImageURL = dictionary["ImageURL"] as? String,
//        let ProductType = dictionary["ProductType"] as? String,
//        let UserContact = dictionary["UserContact"] as? String,
//        let Latitude = dictionary["Latitude"] as? Double,
//        let Longitude = dictionary["Longitude"] as? Double,
//        let ItemDescription = dictionary["ItemDescription"] as? String,
//            let ItemName = dictionary["ItemName"] as? String else{return nil}
//        self.init(ItemName: ItemName, ItemDescription: ItemDescription, Latitude: Latitude, Longitude: Longitude, ProductType: ProductType, UserContact: UserContact, ImageURL: ImageURL)
//    }
//}

class ItemObject: Mappable {

    var ItemName: String?
    var ItemDescription: String?
    var Latitude: Double?
    var Longitude: Double?
    var ProductType: String?
    var UserContact: String?
    var ImageURL: String?
    var ItemRating: Double?
    var id:String?
//    var ItemPrice: Double?
    
    static var ItemDetail = [ItemObject]()

    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        ItemName        <- map["ItemName"]
        ItemDescription <- map["ItemDescription"]
        Latitude        <- map["Latitude"]
        Longitude       <- map["Longitude"]
        ProductType     <- map["ProductType"]
        UserContact     <- map["UserContact"]
        ImageURL        <- map["ImageURL"]
        ItemRating        <- map["ItemRating"]
//        ItemPrice        <- map["ItemPrice"]
    }
}

class ReviewDetail: Mappable {
    
    var UserName: String?
    var reviewsUser: String?
    var ImageURL: String?
    var PostID: String?
    var uid: String?
//    var ItemRating: Double?

    
    static var reviewDetail = [ReviewDetail]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        UserName        <- map["UserName"]
        ImageURL        <- map["ImageURL"]
        reviewsUser        <- map["reviewsUser"]
        uid        <- map["uid"]
        PostID        <- map["PostID"]
//        ItemRating        <- map["ItemRating"]

    }
}


