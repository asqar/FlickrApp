//
//  Language.swift
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Foundation
import UIKit

class Language {

    static var bundle:Bundle! = nil

    class func initialize() {
        let defs:UserDefaults! = UserDefaults.standard
        let languages:[String]! = defs.object(forKey: "AppleLanguages") as! [String]
        let current:String! = languages[0]
        self.setLanguage(l: current)
    }

    /*
     example calls:
     [Language setLanguage:@"it"];
     [Language setLanguage:@"de"];
     */
    class func setLanguage(l:String!) {
        let path:String! = Bundle.main.path(forResource: l, ofType:"lproj")
        bundle = Bundle(path: path)
    }

    class func get(key:String!, alter alternate:String!) -> String! {
        let v:String! = bundle.localizedString(forKey: key, value:alternate, table:nil)
        return v == nil ? key : v
    }
}
