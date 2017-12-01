//
//  Photo.swift
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Realm
import Realm_JSON

class Photo : Entity {

    var photoId:String!
    var owner:String!
    var secret:String!
    var server:String!
    var farm:Int!
    var title:String!
    var isPublic:Int!
    var isFriend:Int!
    var isFamily:Int!
    var orderIndex:Int!
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

    override class func deserializeOne(d:NSDictionary!, in realm:RLMRealm!) -> AnyObject {
        let item:Photo! = Photo.createOrUpdate(in:realm, withJSONDictionary: d as! [AnyHashable : Any]!)
        return item
    }

    override class func deserializeMany(a:[AnyObject]!, in realm:RLMRealm!) -> [AnyObject] {
//        if (a is NSDictionary) {
//            a = (a as! NSDictionary).objectForKey("photos")
//        }
//        if (a is NSDictionary) {
//            a = (a as! NSDictionary).objectForKey("photo")
//        }
        return Photo.createOrUpdate(in:realm, withJSONArray: a)! as [AnyObject]
    }
}
