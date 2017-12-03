//
//  AppDelegate.swift
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Realm

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Fabric.with([Crashlytics.self])
        
        self.handleDefaultRealm()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Realm
    
    func handleDefaultRealm() {
        let defaultRealmPath:String! = RLMRealmConfiguration.default().fileURL?.absoluteString
        if !FileManager.default.fileExists(atPath: defaultRealmPath) {
            let v0Path:String! = Bundle.main.resourcePath?.appending("default.realm")
            do{
                try FileManager.default.removeItem(atPath: defaultRealmPath)
                try FileManager.default.copyItem(atPath: v0Path, toPath:defaultRealmPath)
            } catch let error {
                print(error)
            }
        }


        let config:RLMRealmConfiguration! = RLMRealmConfiguration.default()
        // Set the new schema version. This must be greater than the previously used
        // version (if you've never set a schema version before, the version is 0).
        config.schemaVersion = 1
        config.deleteRealmIfMigrationNeeded = true

        //    config.encryptionKey = [NSData dataWithBytes:[[[DTOUser secretSharedKey] dataUsingEncoding:NSUTF8StringEncoding] bytes] length:64];

        // NSLog(@"%@", [config.encryptionKey hexRepresentationWithSpaces_AS:NO]);

        // Set the block which will be called automatically when opening a Realm with a
        // schema version lower than the one set above
        config.migrationBlock = { (migration:RLMMigration!,oldSchemaVersion:UInt64) in
            // We haven’t migrated anything yet, so oldSchemaVersion == 0
            if oldSchemaVersion < 1 {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
            }
        }

        // Tell Realm to use this new configuration object for the default Realm
        RLMRealmConfiguration.setDefault(config)

        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration


        // trying to open an outdated realm file without first registering a new schema version and migration block
        // with throw
        do {
            let realm = RLMRealm.default()
            realm.beginWriteTransaction()
            try realm.commitWriteTransaction()
        } catch {
#if DEBUG
            NSLog("Trying to open an outdated realm a migration block threw an exception.")
#endif
            do {
                try FileManager.default.removeItem(atPath: defaultRealmPath)
            } catch let error {
                print(error)
            }
        }
    }

}
