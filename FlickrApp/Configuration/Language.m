//
//  Language.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Foundation
import UIKit

class Language {

    var bundle:Bundle! = nil

    class func initialize() {
        let defs:NSUserDefaults! = NSUserDefaults.standardUserDefaults()
        let languages:[AnyObject]! = defs.objectForKey("AppleLanguages")
        let current:String! = languages.objectAtIndex(0)
        self.language = current
    }

    /*
     example calls:
     [Language setLanguage:@"it"];
     [Language setLanguage:@"de"];
     */
    class func setLanguage(l:String!) {
        let path:String! = Bundle.mainBundle().pathForResource(l, ofType:"lproj")
        bundle = Bundle.bundleWithPath(path)
    }

    class func get(key:String!, alter alternate:String!) -> String! {
        let v:String! = bundle.localizedStringForKey(key, value:alternate, table:nil)
        return v == nil ? key : v
    }
}
