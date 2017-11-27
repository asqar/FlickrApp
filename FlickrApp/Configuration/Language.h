//
//  Language.h
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Language : NSObject

+(void)initialize;
+(void)setLanguage:(NSString *)l;
+(NSString *)get:(NSString *)key alter:(NSString *)alternate;

@end
