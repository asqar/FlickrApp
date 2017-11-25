//
//  Utils.h
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject

+(NSString *) uniqueDeviceIdentifier;

+ (void)saveToUserDefaults:(NSString*)key value:(NSString*)valueString;
+ (void)removeFromUserDefaults:(NSString*)key;
+ (BOOL)retrieveBooleanFromUserDefaults:(NSString*)key;
+ (NSString*)retrieveFromUserDefaults:(NSString*)key;

@end
