//
//  Utils.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "UserDefaults.h"
#import <SAMKeychain/SAMKeychain.h>

@implementation UserDefaults

#pragma mark - Settings Bug Workaround

+(NSString *) uniqueDeviceIdentifier
{
    NSString *appName= [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    NSString *strApplicationUUID = [SAMKeychain passwordForService:appName account:@"udid"];
    if (strApplicationUUID == nil)
    {
        NSString *uuidStr = [UserDefaults retrieveFromUserDefaults:@"udid"];
        if (uuidStr == nil) {
            // Create universally unique identifier (object)
            CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
            
            // Get the string representation of CFUUID object.
            uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
            CFRelease(uuidObject);
        }
        NSError *error = nil;
        SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
        query.service = appName;
        query.account = @"udid";
        query.password = uuidStr;
        query.synchronizationMode = SAMKeychainQuerySynchronizationModeNo;
        [query save:&error];
        if (error){
#ifdef DEBUG
            NSLog(@"Error save to keychain: %@", error);
#endif
        }
    }
    return strApplicationUUID;
}

+ (void)saveToUserDefaults:(NSString*)key value:(NSString*)valueString
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:valueString forKey:key];
        [standardUserDefaults synchronize];
    } else {
        ////if (DEBUG) NSLog(@"Unable to save %@ = %@ to user defaults", key, valueString);
    }
}

+ (void)removeFromUserDefaults:(NSString*)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults removeObjectForKey:key];
        [standardUserDefaults synchronize];
    } else {
        ////if (DEBUG) NSLog(@"Unable to remove %@ from user defaults", key);
    }
}

+ (BOOL)retrieveBooleanFromUserDefaults:(NSString*)key
{
    //	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    //    return [standardUserDefaults boolForKey: key];
    NSString *s = [UserDefaults retrieveFromUserDefaults: key];
    return [s boolValue];
}

+ (NSString*)retrieveFromUserDefaults:(NSString*)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults objectForKey:key];
    
    // TODO: / apparent Apple bug: if user hasn't opened Settings for this app yet (as if?!), then
    // the defaults haven't been copied in yet.  So do so here.  Adds another null check
    // for every retrieve, but should only trip the first time
    if (val == nil) {
        ////if (DEBUG) NSLog(@"key = %@", key);
        ////if (DEBUG) NSLog(@"user defaults may not have been loaded from Settings.bundle ... doing that now ...");
        //Get the bundle path
        NSString *bPath = [[NSBundle mainBundle] bundlePath];
        NSString *settingsPath = [bPath stringByAppendingPathComponent:@"Settings.bundle"];
        NSString *plistFile = [settingsPath stringByAppendingPathComponent:@"Root.plist"];
        
        //Get the Preferences Array from the dictionary
        NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistFile];
        NSArray *preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
        
        //Loop through the array
        NSDictionary *item;
        for(item in preferencesArray)
        {
            //Get the key of the item.
            NSString *keyValue = [item objectForKey:@"Key"];
            
            //Get the default value specified in the plist file.
            id defaultValue = [item objectForKey:@"DefaultValue"];
            
            if (keyValue && defaultValue) {
                [standardUserDefaults setObject:defaultValue forKey:keyValue];
                if ([keyValue compare:key] == NSOrderedSame)
                    val = defaultValue;
            }
        }
        [standardUserDefaults synchronize];
    }
    return val;
}

@end
