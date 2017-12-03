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

    @objc dynamic var photoId:String!
    @objc dynamic var owner:String!
    @objc dynamic var secret:String!
    @objc dynamic var server:String!
    @objc dynamic var farm:Int = 0
    @objc dynamic var title:String!
    @objc dynamic var isPublic:Int = 0
    @objc dynamic var isFriend:Int = 0
    @objc dynamic var isFamily:Int = 0
    @objc dynamic var orderIndex:Int = 0
    @objc dynamic var searchAttempt:SearchAttempt!

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

    override class func deserializeMany(a:Any?, in realm:RLMRealm!) -> [AnyObject] {
        var items:[AnyObject]
        if (a is NSDictionary) {
            let d:NSDictionary = (a as! NSDictionary).object(forKey: "photos") as! NSDictionary
            items = d.object(forKey: "photo") as! [AnyObject]
        } else {
            items = a as! [AnyObject]
        }
        return Photo.createOrUpdate(in:realm, withJSONArray: items)! as [AnyObject]
    }
}
