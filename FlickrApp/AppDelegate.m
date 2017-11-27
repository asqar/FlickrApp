//
//  AppDelegate.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Fabric with:@[[Crashlytics class]]];

    [self handleDefaultRealm];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Realm

- (void) handleDefaultRealm
{
    NSString *defaultRealmPath = [RLMRealmConfiguration defaultConfiguration].fileURL.absoluteString;
    if (![[NSFileManager defaultManager] fileExistsAtPath:defaultRealmPath]) {
        NSString *v0Path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"default.realm"];
        [[NSFileManager defaultManager] removeItemAtPath:defaultRealmPath error:nil];
        [[NSFileManager defaultManager] copyItemAtPath:v0Path toPath:defaultRealmPath error:nil];
    }
    
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    // Set the new schema version. This must be greater than the previously used
    // version (if you've never set a schema version before, the version is 0).
    config.schemaVersion = 1;
    config.deleteRealmIfMigrationNeeded = YES;
    
    //    config.encryptionKey = [NSData dataWithBytes:[[[DTOUser secretSharedKey] dataUsingEncoding:NSUTF8StringEncoding] bytes] length:64];
    
    // NSLog(@"%@", [config.encryptionKey hexRepresentationWithSpaces_AS:NO]);
    
    // Set the block which will be called automatically when opening a Realm with a
    // schema version lower than the one set above
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        if (oldSchemaVersion < 1) {
            // Nothing to do!
            // Realm will automatically detect new properties and removed properties
            // And will update the schema on disk automatically
        }
    };
    
    // Tell Realm to use this new configuration object for the default Realm
    [RLMRealmConfiguration setDefaultConfiguration:config];
    
    // Now that we've told Realm how to handle the schema change, opening the file
    // will automatically perform the migration
    
    
    // trying to open an outdated realm file without first registering a new schema version and migration block
    // with throw
    @try {
        [RLMRealm defaultRealm];
    }
    @catch (NSException *exception) {
#ifdef DEBUG
        NSLog(@"Trying to open an outdated realm a migration block threw an exception.");
#endif
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:defaultRealmPath error:&error];
#ifdef DEBUG
        NSLog(@"%@", error);
#endif
    }
}

@end
