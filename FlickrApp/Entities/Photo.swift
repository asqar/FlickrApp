//
//  Photo.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Realm
import Realm_JSON

class Photo : RLMObject, RealmJsonDeserializer {

    var photoId:String!
    var owner:String!
    var secret:String!
    var server:String!
    var farm:Int!
    var title:String!
    var isPublic:Int!
    var isFriend:Int!
    var isFamily:Int!
    var orderIndex:NSNumber!
    var searchAttempt:SearchAttempt!

    class func JSONInboundMappingDictionary() -> NSDictionary! {
        return [
                 "id" : "photoId",
                 "owner" : "owner",
                 "secret" : "secret",
                 "server" : "server",
                 "farm" : "farm",
                 "title" : "title",
                 "ispublic" : "isPublic",
                 "isfriend" : "isFriend",
                 "isfamily" : "isFamily",
                 ]
    }

    class func JSONOutboundMappingDictionary() -> NSDictionary! {
        return [
            :]
    }

    override class func primaryKey() -> String? {
        return "photoId"
    }

    class func deserializeOne(d:NSDictionary!, inRealm realm:RLMRealm!) -> Self {
        let item:Photo! = Photo.createOrUpdate(in:realm, withJSONDictionary: d as! [AnyHashable : Any]!)
        return item
    }

    class func deserializeMany(a:[AnyObject]!, inRealm realm:RLMRealm!) -> [Any]! {
//        if (a is NSDictionary) {
//            a = (a as! NSDictionary).objectForKey("photos")
//        }
//        if (a is NSDictionary) {
//            a = (a as! NSDictionary).objectForKey("photo")
//        }
        return Photo.createOrUpdate(in:realm, withJSONArray: a)
    }
}
