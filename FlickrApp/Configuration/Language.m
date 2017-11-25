//
//  Language.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "Language.h"

@implementation Language

static NSBundle *bundle = nil;

+(void)initialize {
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString *current = [languages objectAtIndex:0];
    [self setLanguage:current];
}

/*
 example calls:
 [Language setLanguage:@"it"];
 [Language setLanguage:@"de"];
 */
+(void)setLanguage:(NSString *)l {
    NSString *path = [[ NSBundle mainBundle ] pathForResource:l ofType:@"lproj" ];
    bundle = [NSBundle bundleWithPath:path];
}

+(NSString *)get:(NSString *)key alter:(NSString *)alternate {
    NSString *v = [bundle localizedStringForKey:key value:alternate table:nil];
    return v == nil ? key : v;
}

@end
