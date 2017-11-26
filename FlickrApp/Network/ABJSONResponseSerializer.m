//
//  ABJSONResponseSerializer.m
//  FlickrApp
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "ABJSONResponseSerializer.h"

@implementation ABJSONResponseSerializer

- (BOOL)validateResponse:(NSHTTPURLResponse *)response
                    data:(NSData *)data
                   error:(NSError * __autoreleasing *)error
{
    BOOL responseIsValid = [super validateResponse:response data:data error:error];
    
#ifdef DEBUG_VERBOSE
    NSLog(@"%@", [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding]);
#endif
    
    if (!responseIsValid) {
        NSError *errorPointer = *error;
        NSData *responseErrorData = errorPointer.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSString *responseErrorString = nil;
        if (responseErrorData) {
            responseErrorString = [[NSJSONSerialization JSONObjectWithData:responseErrorData options:0 error:nil] description];
        }
        
        NSMutableDictionary *mutableUserInfo = [errorPointer.userInfo mutableCopy];
        if (responseErrorString) {
            mutableUserInfo[@"kz.bakirov.FlickrApp.response.error"] = responseErrorString;
        }
        *error = [NSError errorWithDomain:errorPointer.domain code:errorPointer.code userInfo:[mutableUserInfo copy]];
    }
    
    return responseIsValid;
}

@end
