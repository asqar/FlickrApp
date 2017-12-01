//
//  RemoteFetcher.m
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

    private var _entityClass:RealmJsonDeserializer
    private var _serviceName:String!
    private var _singleName:String!
    private var _pluralName:String!
    var serviceName:String!
    var timeoutInterval:Float

    init(entityClass:AnyClass, serviceName:String!, singleName:String!, pluralName:String!) {
        _entityClass = entityClass as! RealmJsonDeserializer
        _serviceName = serviceName
        _singleName = singleName
        _pluralName = pluralName
    }

    func serverUrl() -> String! {
        return "https://api.flickr.com/"
    }

    func realm() -> RLMRealm! {
        return RLMRealm.default()
    }

    func fetchItemsWithMethod(method:RestMethod, fromPath restServiceUrl:String!, parameters:AnyObject!, one:Bool, synchronoulsy synchronously:Bool, success:@escaping (URLSessionTask?,AnyObject?)->Void, failure:@escaping (_ sessionTask:URLSessionTask?,_ error:NSError?)->Void) {
#if DEBUG_VERBOSE
        let methodStart:NSDate! = NSDate.date()
#endif

        let manager:AFHTTPSessionManager! = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = ABJSONResponseSerializer()

        let progressBlock:(Progress) -> Void! = { (downloadProgress:Progress) in

            }

        let failureBlock:AnyObject! = { (operation:URLSessionTask!,error:NSError!) in
#if DEBUG
            NSLog("Error: %@", error)
#endif
            failure(operation, error)
            } as AnyObject

        let successBlock:(URLSessionDataTask, AnyObject?) -> ()! = { (task:URLSessionDataTask,responseObject:AnyObject!) in
#if DEBUG_VERBOSE
            NSLog("%@ : %@", task.originalRequest.URL.absoluteString, responseObject)
#endif

            let block:() -> ()! = {
                let realm:RLMRealm! = self.realm()
                realm.beginWriteTransaction()
                var result:AnyObject! = nil
                if one {
                    result = _entityClass.deserializeOne(responseObject, in: realm)
                } else {
                    result = _entityClass.deserializeMany(responseObject, in: realm)
                }
#if DEBUG_VERBOSE
                NSLog("%@", result)
#endif
                realm.commitWriteTransaction()

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
                DispatchQueue.main.async(execute: block as! @convention(block) () -> Void)
            }
        }

        let urlPath:String! = String(format:"%@%@%@", self.serverUrl(), self.serviceName, restServiceUrl)
        switch (method) { 
            case RestMethod.GET:
                manager.get(URLString:urlPath, parameters:parameters, progress:progressBlock, success:successBlock, failure:failureBlock)
                break
            case RestMethod.POST:
                manager.post(URLString:urlPath, parameters:parameters, progress:progressBlock, success:successBlock, failure: failureBlock)
                break
            case RestMethod.PUT:
                manager.put(urlPath, parameters:parameters, success:successBlock as! (URLSessionDataTask, Any?) -> Void, failure: failureBlock)
                break
            case RestMethod.DELETE:
                manager.delete(urlPath, parameters:parameters, success:successBlock as! (URLSessionDataTask, Any?) -> Void, failure: failureBlock)
                break
            default:
                break
        }
    }

    func fetchOneFromPath(restServiceUrl:String!, synchronoulsy:Bool, success:@escaping (URLSessionTask?,AnyObject?)->Void, failure:(URLSessionTask?,NSError?)->Void) {
        self.fetchItemsWithMethod(method: RestMethod.GET, fromPath: restServiceUrl, parameters:nil, one:true, synchronoulsy:synchronoulsy, success:success, failure:failure)
    }

    func fetchManyFromPath(restServiceUrl:String!, synchronoulsy:Bool, success:@escaping (URLSessionTask?,AnyObject?)->Void, failure:(URLSessionTask?,NSError?)->Void) {
        self.fetchItemsWithMethod(method: RestMethod.GET, fromPath: restServiceUrl, parameters:nil, one:false, synchronoulsy:synchronoulsy, success:success, failure:failure)
    }

    func postObject(o:AnyObject!, synchronoulsy:Bool, success:(URLSessionTask?,AnyObject?)->Void, failure:(URLSessionTask??,NSError?)->Void) {
        self.postObject(o: o, toPath:_pluralName, synchronoulsy:synchronoulsy, success:success, failure:failure)
    }

    func postObject(o:AnyObject!, toPath path:String!, synchronoulsy:Bool, success:@escaping (URLSessionTask?,AnyObject?)->Void, failure:(URLSessionTask?,NSError?)->Void) {
        let restServiceUrl:String! = String(format:"/%@/%@", _serviceName, path)
        self.fetchItemsWithMethod(method: RestMethod.POST, fromPath: restServiceUrl, parameters:nil, one:true, synchronoulsy:synchronoulsy, success:success, failure:failure)
    }

    func putObject(o:AnyObject!, objectId:Int, synchronoulsy:Bool, success:@escaping (URLSessionTask?,AnyObject?)->Void, failure:@escaping (URLSessionTask?,NSError?)->Void) {
        let restServiceUrl:String! = String(format:"%@/%@/%d", _serviceName, _pluralName, objectId)
        self.fetchItemsWithMethod(method: RestMethod.PUT, fromPath: restServiceUrl, parameters:nil, one:true, synchronoulsy:synchronoulsy, success:success, failure:failure)
    }

    func deleteObject(o:AnyObject!, objectId:Int, synchronoulsy:Bool, success:@escaping (URLSessionTask?,AnyObject?)->Void, failure:@escaping (URLSessionTask?,NSError?)->Void) {
        let restServiceUrl:String! = String(format:"%@/%@/%d", _serviceName, _pluralName, objectId)
        self.fetchItemsWithMethod(method: RestMethod.DELETE, fromPath: restServiceUrl, parameters:nil, one:true, synchronoulsy:synchronoulsy, success:success, failure:failure)
    }
}
