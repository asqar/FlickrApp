//
//  RemoteFetcher.h
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface RemoteFetcher : NSObject
{
    Class _entityClass;
    NSString *_serviceName;
    NSString *_singleName;
    NSString *_pluralName;
}

- (NSString *) serverUrl;

@property (nonatomic, strong) NSString *serviceName;
@property (nonatomic, assign) float timeoutInterval;

- (id)initWithEntity:(Class)entityClass serviceName:(NSString *)serviceName singleName:(NSString *)singleName pluralName:(NSString *)pluralName;
- (id) initMe;

- (void)fetchOneFromPath: (NSString *) restServiceUrl synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
                   failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure;
- (void)fetchManyFromPath: (NSString *) restServiceUrl synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
                  failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure;
- (void) postObject: (id) o synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
            failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure;
- (void) postObject: (id) o toPath: (NSString *) path synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
            failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure;
- (void) putObject: (id) o : (int) objectId synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
           failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure;
- (void) deleteObject: (id) o : (int) objectId synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
              failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure;

@end
