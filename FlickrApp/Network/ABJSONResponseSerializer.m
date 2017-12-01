//
//  ABJSONResponseSerializer.m
//  FlickrApp
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import AFNetworking

class ABJSONResponseSerializer : AFJSONResponseSerializer {

    func validateResponse(response:NSHTTPURLResponse!, data:NSData!, error:NSError!) -> Bool {
        let responseIsValid:Bool = super.validateResponse(response, data:data, error:error)

#if DEBUG_VERBOSE
        NSLog("%@", String(data:data, encoding:NSUTF8StringEncoding))
#endif

        if !responseIsValid {
            let errorPointer:NSError! = *error
            let responseErrorData:NSData! = errorPointer.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
            var responseErrorString:String! = nil
            if (responseErrorData != nil) {
                responseErrorString = NSJSONSerialization.JSONObjectWithData(responseErrorData, options:0, error:nil).description()
            }

            let mutableUserInfo:NSMutableDictionary! = errorPointer.userInfo.mutableCopy()
            if (responseErrorString != nil) {
                mutableUserInfo["kz.bakirov.FlickrApp.response.error"] = responseErrorString
            }
            *error = NSError.errorWithDomain(errorPointer.domain, code:errorPointer.code, userInfo:mutableUserInfo.copy())
        }

        return responseIsValid
    }
}
