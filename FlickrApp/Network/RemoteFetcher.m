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

- (void)fetchOneFromPath: (NSString *) restServiceUrl synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
                  failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure
{
    [self fetchItemsFromPath: restServiceUrl one:YES synchronoulsy:synchronously success:success failure:failure];
}

- (void)fetchManyFromPath: (NSString *) restServiceUrl synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
                   failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure
{
    [self fetchItemsFromPath: restServiceUrl one:NO synchronoulsy:synchronously success:success failure:failure];
}

- (void)fetchItemsFromPath: (NSString *) restServiceUrl one: (BOOL) one synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
                   failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure;
{
    NSDate *methodStart = [NSDate date];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *urlPath = [NSString stringWithFormat: @"%@%@%@", [self serverUrl], self.serviceName, restServiceUrl];

    [manager GET:urlPath parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //NSLog(@"%@ : %@", urlPath, responseObject);

        dispatch_block_t block = ^{
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            id result = nil;
            if (one) {
                result = [_entityClass deserializeOne: responseObject];
            } else {
                result = [_entityClass deserializeMany: responseObject];
            }
            //NSLog(@"%@", result);
            [realm commitWriteTransaction];
            
            NSDate *methodFinish = [NSDate date];
            NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
#ifdef DEBUG
            NSLog(@"executionTime = %f", executionTime);
#endif
            success(task, result);
        };
        
        if (synchronously) {
            block();
        } else {
            dispatch_async(dispatch_get_main_queue(), block);
        }
    } failure: ^(NSURLSessionTask *operation, NSError *error) {
#ifdef DEBUG
        NSLog(@"Error: %@", error);
#endif
        failure(operation, error);
    }];
}

- (void) postObject: (id) o synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
            failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure
{
    NSString *restServiceUrl = [NSString stringWithFormat:@"/%@/%@", _serviceName, _pluralName];
    
    [self postObject:o toPath:restServiceUrl synchronoulsy:synchronously success:success failure:failure];
}

- (void) postObject: (id) o toPath: (NSString *) path synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
            failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure
{

    
    NSDate *methodStart = [NSDate date];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat: @"%@%@", [self serverUrl], path] parameters:o  success: ^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *d = responseObject;
        
        dispatch_block_t block = ^{
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            RLMObject *result = [_entityClass deserializeOne: d];
            [realm commitWriteTransaction];
            
            NSDate *methodFinish = [NSDate date];
            NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
#ifdef DEBUG
            NSLog(@"executionTime = %f", executionTime);
#endif
            success(task, result);
        };
        
        if (synchronously) {
            block();
        } else {
            dispatch_async(dispatch_get_main_queue(), block);
        }
        
    } failure: ^(NSURLSessionTask *operation, NSError *error) {
#ifdef DEBUG
        NSLog(@"Error: %@", error);
#endif
        failure(operation, error);
    }];
}

- (void) putObject: (id) o : (int) objectId synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
           failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure;
{
    NSString *restServiceUrl = [NSString stringWithFormat:@"%@/%@/%d", _serviceName, _pluralName, objectId];
    
    NSDate *methodStart = [NSDate date];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager PUT:[NSString stringWithFormat: @"%@%@", [self serverUrl], restServiceUrl] parameters:o success: ^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *d = responseObject;
        
        dispatch_block_t block = ^{
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            RLMObject *result = [_entityClass deserializeOne: d];
            [realm commitWriteTransaction];
            
            NSDate *methodFinish = [NSDate date];
            NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
#ifdef DEBUG
            NSLog(@"executionTime = %f", executionTime);
#endif
            success(task, result);
        };
        
        if (synchronously) {
            block();
        } else {
            dispatch_async(dispatch_get_main_queue(), block);
        }
    } failure: ^(NSURLSessionTask *operation, NSError *error) {
#ifdef DEBUG
        NSLog(@"Error: %@", error);
#endif
        failure(operation, error);
    }];
}

- (void) deleteObject: (id) o : (int) objectId synchronoulsy: (BOOL) synchronously  success:(void (^)(NSURLSessionTask *operation, id mappingResult))success
              failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure;
{
    NSString *restServiceUrl = [NSString stringWithFormat:@"%@/%@/%d", _serviceName, _pluralName, objectId];
    
    NSDate *methodStart = [NSDate date];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager DELETE:[NSString stringWithFormat: @"%@%@", [self serverUrl], restServiceUrl] parameters:nil success: ^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *d = responseObject;
        
        dispatch_block_t block = ^{
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            RLMObject *result = [_entityClass deserializeOne: d];
            [realm commitWriteTransaction];
            
            NSDate *methodFinish = [NSDate date];
            NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
#ifdef DEBUG
            NSLog(@"executionTime = %f", executionTime);
#endif
            success(task, result);
        };
        
        if (synchronously) {
            block();
        } else {
            dispatch_async(dispatch_get_main_queue(), block);
        }
    } failure: ^(NSURLSessionTask *operation, NSError *error) {
#ifdef DEBUG
        NSLog(@"Error: %@", error);
#endif
        failure(operation, error);
    }];
}

@end
