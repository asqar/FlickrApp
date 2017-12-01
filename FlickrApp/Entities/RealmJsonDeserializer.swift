//
//  RealmJsonDeserializer.swift
//  FlickrApp
//
//  Created by aSqar on 01.12.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Foundation
import Realm

protocol RealmJsonDeserializer {
    static func deserializeOne(d:NSDictionary!, inRealm realm:RLMRealm!)
    static func deserializeMany(a:[AnyObject]!, inRealm realm:RLMRealm!)
}
