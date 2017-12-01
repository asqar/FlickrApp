//
//  Utils.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import SAMKeychain
import UIKit
import Foundation

class UserDefaults {

    // MARK: - Settings Bug Workaround

    class func uniqueDeviceIdentifier() -> String! {
        let appName:String! = Bundle.mainBundle().infoDictionary().objectForKey((kCFBundleNameKey as! NSString))

        let strApplicationUUID:String! = SAMKeychain.passwordForService(appName, account:"udid")
        if strApplicationUUID == nil
        {
            var uuidStr:String! = UserDefaults.retrieveFromUserDefaults("udid")
            if uuidStr == nil {
                // Create universally unique identifier (object)
                let uuidObject:CFUUIDRef = CFUUIDCreate(kCFAllocatorDefault)

                // Get the string representation of CFUUID object.
                uuidStr = (CFUUIDCreateString(kCFAllocatorDefault, uuidObject) as!String)
                CFRelease(uuidObject)
            }
            let error:NSError! = nil
            let query:SAMKeychainQuery! = SAMKeychainQuery()
            query.service = appName
            query.account = "udid"
            query.password = uuidStr
            query.synchronizationMode = SAMKeychainQuerySynchronizationModeNo
            query.save(&error)
            if (error != nil) {
#if DEBUG
                NSLog("Error save to keychain: %@", error)
#endif
            }
        }
        return strApplicationUUID
    }

    class func saveToUserDefaults(key:String!, value valueString:String!) {
        let standardUserDefaults:NSUserDefaults! = NSUserDefaults.standardUserDefaults()

        if (standardUserDefaults != nil) {
            standardUserDefaults.setObject(valueString, forKey:key)
            standardUserDefaults.synchronize()
        } else {
            ////if (DEBUG) NSLog(@"Unable to save %@ = %@ to user defaults", key, valueString);
        }
    }

    class func removeFromUserDefaults(key:String!) {
        let standardUserDefaults:NSUserDefaults! = NSUserDefaults.standardUserDefaults()

        if (standardUserDefaults != nil) {
            standardUserDefaults.removeObjectForKey(key)
            standardUserDefaults.synchronize()
        } else {
            ////if (DEBUG) NSLog(@"Unable to remove %@ from user defaults", key);
        }
    }

    class func retrieveBooleanFromUserDefaults(key:String!) -> Bool {
        //	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        //    return [standardUserDefaults boolForKey: key];
        let s:String! = UserDefaults.retrieveFromUserDefaults(key)
        return s.boolValue()
    }

    class func retrieveFromUserDefaults(key:String!) -> String! {
        let standardUserDefaults:NSUserDefaults! = NSUserDefaults.standardUserDefaults()
        var val:String! = nil

        if (standardUserDefaults != nil)
            {val = standardUserDefaults.objectForKey(key)}

        // TODO: / apparent Apple bug: if user hasn't opened Settings for this app yet (as if?!), then
        // the defaults haven't been copied in yet.  So do so here.  Adds another null check
        // for every retrieve, but should only trip the first time
        if val == nil {
            ////if (DEBUG) NSLog(@"key = %@", key);
            ////if (DEBUG) NSLog(@"user defaults may not have been loaded from Settings.bundle ... doing that now ...");
            //Get the bundle path
            let bPath:String! = Bundle.mainBundle().bundlePath()
            let settingsPath:String! = bPath.stringByAppendingPathComponent("Settings.bundle")
            let plistFile:String! = settingsPath.stringByAppendingPathComponent("Root.plist")

            //Get the Preferences Array from the dictionary
            let settingsDictionary:NSDictionary! = NSDictionary.dictionaryWithContentsOfFile(plistFile)
            let preferencesArray:[AnyObject]! = settingsDictionary.objectForKey("PreferenceSpecifiers")

            //Loop through the array
            for item:NSDictionary! in preferencesArray { 
                //Get the key of the item.
                let keyValue:String! = item.objectForKey("Key")

                //Get the default value specified in the plist file.
                let defaultValue:AnyObject! = item.objectForKey("DefaultValue")

                if (keyValue != nil) && defaultValue {
                    standardUserDefaults.setObject(defaultValue, forKey:keyValue)
                    if keyValue.compare(key) == NSOrderedSame
                        {val = defaultValue}
                }
             }
            standardUserDefaults.synchronize()
        }
        return val
    }
}
