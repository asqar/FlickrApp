//
//  SearchAttempt.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Realm
import Realm_JSON

class SearchAttempt : RLMObject, RealmJsonDeserializer {

    var searchTerm:String!
    var dateSearched:Date!
    var isSuccessful:Bool!
    private(set) var photos:RLMLinkingObjects<RLMObject>!

    override class func primaryKey() -> String? {
        return "searchTerm"
    }

    func linkingObjectsProperties() -> NSDictionary! {
        return [
            "photos": RLMPropertyDescriptor(with: Photo.self, propertyName:"searchAttempt"),
                 ]
    }
}
