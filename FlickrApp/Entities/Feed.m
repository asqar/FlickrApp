//
//  Feed.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Realm
import Realm_JSON

class Feed : RLMObject, RealmJsonDeserializer {

    var title:String!
    var link:String!
    var media:String!
    var dateTaken:NSDate!
    var descr:String!
    var datePublished:NSDate!
    var author:String!
    var authorId:String!
    var tags:String!

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

    class func deserializeOne(d:NSDictionary!, inRealm realm:RLMRealm!) -> Self {
        let item:Feed! = Feed.createOrUpdate(in:realm, withJSONDictionary: d as! [AnyHashable : Any]!)
        return item
    }

    class func deserializeMany(a:[AnyObject]!, inRealm realm:RLMRealm!) -> [Any]! {
//        if (a is NSDictionary) {
//            a = (a as! NSDictionary).objectForKey("items")
//        }
//        if (a is NSDictionary) {
//            a = (a as! NSDictionary).objectForKey("photo")
//        }
        let result:[AnyObject]! = Feed.createOrUpdate(in:realm, withJSONArray: a)

        let pattern:String! = "(?<=\").+(?=\")"
        let  error:NSError! = nil
        let regex:NSRegularExpression! = NSRegularExpression.regularExpressionWithPattern(pattern, options:0, error:&error)

        for item:Feed! in result { 
            let searchedString:String! = item.author
            let matches:[AnyObject]! = regex.matchesInString(searchedString, options:0, range: NSMakeRange(0, searchedString.length()))
            let match:NSTextCheckingResult! = matches.firstObject
            if (match != nil) {
                let matchText:String! = searchedString.substringWithRange(match.range())
                item.author = matchText
            }
         }
        return result
    }
}
