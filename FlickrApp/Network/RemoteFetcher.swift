//
//  RemoteFetcher.swift
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Foundation
import AFNetworking
import Realm
import Realm_JSON

enum RestMethod {
    case GET
    case POST
    case PUT
    case DELETE
}


class RemoteFetcher {

    var entityClass:Entity.Type
    var serviceName:String!
    var singleName:String!
    var pluralName:String!

    init(entityClass:Entity.Type, serviceName:String!, singleName:String!, pluralName:String!) {
        self.entityClass = entityClass
        self.serviceName = serviceName
        self.singleName = singleName
        self.pluralName = pluralName
    }

    func serverUrl() -> String! {
        return "https://api.flickr.com/"
    }

    func realm() -> RLMRealm! {
        return RLMRealm.default()
    }

    func fetchItemsWithMethod(method:RestMethod, fromPath restServiceUrl:String!, parameters:AnyObject!, one:Bool, synchronoulsy synchronously:Bool, success:@escaping (URLSessionTask?,Any?)->Void, failure:@escaping (URLSessionDataTask?, Error) -> Void) {
#if DEBUG_VERBOSE
        let methodStart:NSDate! = NSDate.date()
#endif

        let manager:AFHTTPSessionManager! = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()

        let progressBlock:(Progress) -> Void = { (downloadProgress) in
            
        }

        let failureBlock:(URLSessionDataTask?, Error) -> Void = { (operation,error) in
#if DEBUG
            NSLog("Error: %@", error)
#endif
            failure(operation, error)
            }

        let successBlock:(URLSessionDataTask, Any?) -> Void = { (task,responseObject) in
#if DEBUG
            NSLog("%@ : %@", task.originalRequest.URL.absoluteString, responseObject)
#endif

            let block:() -> Void = {
                let realm:RLMRealm! = self.realm()
                realm.beginWriteTransaction()
                var result:AnyObject! = nil
                if one {
                    result = self.entityClass.deserializeOne(d: responseObject as! NSDictionary!, in: realm)
                } else {
                    result = self.entityClass.deserializeMany(a: responseObject, in: realm) as AnyObject
                }
#if DEBUG
                NSLog("%@", result)
#endif
                do {
                    try realm.commitWriteTransaction()
                } catch {
                    
                }

#if DEBUG_VERBOSE
                let methodFinish:NSDate! = NSDate.date()
                let executionTime:NSTimeInterval = methodFinish.timeIntervalSinceDate(methodStart)
                NSLog("executionTime = %f", executionTime)
#endif
                success(task, result)
            }

            if synchronously {
                block()
            } else {
                DispatchQueue.main.async(execute: block as @convention(block) () -> Void)
            }
        }

        let urlPath:String! = String(format:"%@%@%@", self.serverUrl(), self.serviceName, restServiceUrl)
        switch (method) { 
            case RestMethod.GET:
                manager.get(urlPath, parameters:parameters, progress:progressBlock, success:successBlock, failure:failureBlock)
                break
            case RestMethod.POST:
                manager.post(urlPath, parameters:parameters, progress:progressBlock, success:successBlock, failure:failureBlock)
                break
            case RestMethod.PUT:
                manager.put(urlPath, parameters:parameters, success:successBlock, failure:failureBlock)
                break
            case RestMethod.DELETE:
                manager.delete(urlPath, parameters:parameters, success:successBlock, failure:failureBlock)
                break
        }
    }

    func fetchOneFromPath(restServiceUrl:String!, synchronoulsy:Bool, success:@escaping (URLSessionTask?,Any?)->Void, failure:@escaping (URLSessionDataTask?, Error) -> Void) {
        self.fetchItemsWithMethod(method: RestMethod.GET, fromPath: restServiceUrl, parameters:nil, one:true, synchronoulsy:synchronoulsy, success:success, failure:failure)
    }

    func fetchManyFromPath(restServiceUrl:String!, synchronoulsy:Bool, success:@escaping (URLSessionTask?,Any?)->Void, failure:@escaping (URLSessionDataTask?, Error) -> Void) {
        self.fetchItemsWithMethod(method: RestMethod.GET, fromPath: restServiceUrl, parameters:nil, one:false, synchronoulsy:synchronoulsy, success:success, failure:failure)
    }

    func postObject(o:AnyObject!, synchronoulsy:Bool, success:@escaping (URLSessionTask?,Any?)->Void, failure:@escaping (URLSessionDataTask?, Error) -> Void) {
        self.postObject(o: o, toPath:pluralName, synchronoulsy:synchronoulsy, success:success, failure:failure)
    }

    func postObject(o:AnyObject!, toPath path:String!, synchronoulsy:Bool, success:@escaping (URLSessionTask?,Any?)->Void, failure:@escaping (URLSessionDataTask?, Error) -> Void) {
        let restServiceUrl:String! = String(format:"/%@/%@", serviceName, path)
        self.fetchItemsWithMethod(method: RestMethod.POST, fromPath: restServiceUrl, parameters:nil, one:true, synchronoulsy:synchronoulsy, success:success, failure:failure)
    }

    func putObject(o:AnyObject!, objectId:Int, synchronoulsy:Bool, success:@escaping (URLSessionTask?,Any?)->Void, failure:@escaping (URLSessionDataTask?, Error) -> Void) {
        let restServiceUrl:String! = String(format:"%@/%@/%d", serviceName, pluralName, objectId)
        self.fetchItemsWithMethod(method: RestMethod.PUT, fromPath: restServiceUrl, parameters:nil, one:true, synchronoulsy:synchronoulsy, success:success, failure:failure)
    }

    func deleteObject(o:AnyObject!, objectId:Int, synchronoulsy:Bool, success:@escaping (URLSessionTask?,Any?)->Void, failure:@escaping (URLSessionDataTask?, Error) -> Void) {
        let restServiceUrl:String! = String(format:"%@/%@/%d", serviceName, pluralName, objectId)
        self.fetchItemsWithMethod(method: RestMethod.DELETE, fromPath: restServiceUrl, parameters:nil, one:true, synchronoulsy:synchronoulsy, success:success, failure:failure)
    }
}
