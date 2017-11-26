//
//  RemoteFetcher.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "RemoteFetcher.h"
#import "Entities.h"
#import <AFNetworking/AFNetworking.h>
#import "UserDefaults.h"
#import "RealmJsonDeserializer.h"
#import <Realm+JSON/RLMObject+JSON.h>
#import "ABJSONResponseSerializer.h"

typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
} RestMethod;

@interface RemoteFetcher() {
}

- (NSString *) serverUrl;

@end

@implementation RemoteFetcher

-(void)dealloc
{
    _entityClass = nil;
}

- (id) initMe
{
    return nil;
}

- (id)initWithEntity:(Class)entityClass serviceName:(NSString *)serviceName singleName:(NSString *)singleName pluralName:(NSString *)pluralName
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _entityClass = entityClass;
    _serviceName = serviceName;
    _singleName = singleName;
    _pluralName = pluralName;

    return self;
}

- (NSString *) serverUrl
{
    return @"https://api.flickr.com/";
}

- (void)fetchItemsWithMethod: (RestMethod) method fromPath: (NSString *) restServiceUrl parameters:(id)parameters one: (BOOL) one synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
                   failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure;
{
#ifdef DEBUG_VERBOSE
    NSDate *methodStart = [NSDate date];
#endif
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [ABJSONResponseSerializer serializer];

    id progressBlock = ^(NSProgress * _Nonnull downloadProgress) {
        
    };
    
    id failureBlock = ^(NSURLSessionTask *operation, NSError *error) {
#ifdef DEBUG
        NSLog(@"Error: %@", error);
#endif
        failure(operation, error);
    };
    
    id successBlock =^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#ifdef DEBUG_VERBOSE
        NSLog(@"%@ : %@", task.originalRequest.URL.absoluteString, responseObject);
#endif
        
        dispatch_block_t block = ^{
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            id result = nil;
            if (one) {
                result = [_entityClass deserializeOne: responseObject];
            } else {
                result = [_entityClass deserializeMany: responseObject];
            }
#ifdef DEBUG_VERBOSE
            NSLog(@"%@", result);
#endif
            [realm commitWriteTransaction];
            
#ifdef DEBUG_VERBOSE
            NSDate *methodFinish = [NSDate date];
            NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
            NSLog(@"executionTime = %f", executionTime);
#endif
            success(task, result);
        };
        
        if (synchronously) {
            block();
        } else {
            dispatch_async(dispatch_get_main_queue(), block);
        }
    };
    
    NSString *urlPath = [NSString stringWithFormat: @"%@%@%@", [self serverUrl], self.serviceName, restServiceUrl];
    switch (method) {
        case GET:
            [manager GET:urlPath parameters:parameters progress:progressBlock success:successBlock failure:failureBlock];
            break;
        case POST:
            [manager POST:urlPath parameters:parameters progress:progressBlock success:successBlock failure: failureBlock];
            break;
        case PUT:
            [manager PUT:urlPath parameters:parameters success:successBlock failure: failureBlock];
            break;
        case DELETE:
            [manager DELETE:urlPath parameters:parameters success:successBlock failure: failureBlock];
            break;
        default:
            break;
    }
}

- (void)fetchOneFromPath: (NSString *) restServiceUrl synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
                 failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure
{
    [self fetchItemsWithMethod: GET fromPath: restServiceUrl parameters:nil one:YES synchronoulsy:synchronously success:success failure:failure];
}

- (void)fetchManyFromPath: (NSString *) restServiceUrl synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
                  failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure
{
    [self fetchItemsWithMethod: GET fromPath: restServiceUrl parameters:nil one:NO synchronoulsy:synchronously success:success failure:failure];
}

- (void) postObject: (id) o synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
            failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure
{
    [self postObject:o toPath:_pluralName synchronoulsy:synchronously success:success failure:failure];
}

- (void) postObject: (id) o toPath: (NSString *) path synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
            failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure
{
    NSString *restServiceUrl = [NSString stringWithFormat:@"/%@/%@", _serviceName, path];
    [self fetchItemsWithMethod: POST fromPath: restServiceUrl parameters:nil one:YES synchronoulsy:synchronously success:success failure:failure];
}

- (void) putObject: (id) o : (int) objectId synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
           failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure;
{
    NSString *restServiceUrl = [NSString stringWithFormat:@"%@/%@/%d", _serviceName, _pluralName, objectId];
    [self fetchItemsWithMethod: PUT fromPath: restServiceUrl parameters:nil one:YES synchronoulsy:synchronously success:success failure:failure];
}

- (void) deleteObject: (id) o : (int) objectId synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
              failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure;
{
    NSString *restServiceUrl = [NSString stringWithFormat:@"%@/%@/%d", _serviceName, _pluralName, objectId];
    [self fetchItemsWithMethod: DELETE fromPath: restServiceUrl parameters:nil one:YES synchronoulsy:synchronously success:success failure:failure];
}

@end
