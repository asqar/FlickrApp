//
//  Feed.swift
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Realm
import Realm_JSON
import Foundation

class Feed : Entity {

    @objc dynamic var title:String!
    @objc dynamic var link:String!
    @objc dynamic var media:String!
    @objc dynamic var dateTaken:NSDate!
    @objc dynamic var descr:String!
    @objc dynamic var datePublished:NSDate!
    @objc dynamic var author:String!
    @objc dynamic var authorId:String!
    @objc dynamic var tags:String!

    class func JSONInboundMappingDictionary() -> NSDictionary! {
        return [
                 "title" : "title",
                 "link" : "link",
                 "media.m" : "media",
                 "date_taken" : "dateTaken",
                 "description" : "descr",
                 "published" : "datePublished",
                 "author" : "author",
                 "author_id" : "authorId",
                 "tags" : "tags",
                 ]
    }

    class func JSONOutboundMappingDictionary() -> NSDictionary! {
        return [
            :]
    }

    override class func primaryKey() -> String? {
        return "link"
    }

    override class func deserializeOne(d:NSDictionary!, in realm:RLMRealm!) -> AnyObject {
        let item:Feed! = Feed.createOrUpdate(in:realm, withJSONDictionary: d as! [AnyHashable : Any]!)
        return item
    }

    override class func deserializeMany(a:Any?, in realm:RLMRealm!) -> [AnyObject] {
        var items:[AnyObject]
        if (a is NSDictionary) {
            items = (a as! NSDictionary).object(forKey: "items") as! [AnyObject]
        } else {
            items = a as! [AnyObject]
        }
        
        let result:[Feed]! = Feed.createOrUpdate(in:realm, withJSONArray: items)! as! [Feed]

        let pattern:String! = "(?<=\").+(?=\")"
        do {
            let regex:NSRegularExpression! = try NSRegularExpression(pattern: pattern, options:NSRegularExpression.Options(rawValue: 0))

            for item:Feed! in result as [Feed] {
                let searchedString:String! = item.author
                let matches:[NSTextCheckingResult]! = regex.matches(in: searchedString, options:NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, searchedString.count))
                let match:NSTextCheckingResult! = matches.first
                if (match != nil) {
                    let matchText:String! = searchedString[Range(match.range, in: searchedString)!]
                    item.author = matchText
                }
             }
        } catch let error {
            print(error)
        }
        return result
    }
}
