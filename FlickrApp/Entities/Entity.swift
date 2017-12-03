//
//  Entity.swift
//  FlickrApp
//
//  Created by aSqar on 01.12.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Realm

class Entity: RLMObject {
    
    class func deserializeOne(d: NSDictionary!, in: RLMRealm!) -> AnyObject {
        return Entity()
    }
    
    class func deserializeMany(a: Any?, in: RLMRealm!) -> [AnyObject] {
        return []
    }
}
