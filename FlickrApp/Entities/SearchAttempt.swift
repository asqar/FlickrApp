//
//  SearchAttempt.swift
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Realm
import Realm_JSON

class SearchAttempt : Entity {

    @objc dynamic var searchTerm:String!
    @objc dynamic var dateSearched:Date!
    @objc dynamic var isSuccessful:Bool = false
//    @objc dynamic var photos:RLMLinkingObjects<RLMObject>!
    @objc dynamic var photos = RLMArray<AnyObject>(objectClassName: Photo.className())
    
    override class func primaryKey() -> String? {
        return "searchTerm"
    }

//    func linkingObjectsProperties() -> NSDictionary! {
//        return [
//            "photos": RLMPropertyDescriptor(with: Photo.self, propertyName:"searchAttempt"),
//                 ]
//    }
}
