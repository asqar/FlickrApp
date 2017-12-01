//
//  PhotoFetcher.swift
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

let FLICKR_SEARCH_API_KEY = "fbc1edb4f93131e0ea4a399b928dabc9" // need to hide and encrypt it

class PhotoFetcher : RemoteFetcher {

    static let sharedFetcher = PhotoFetcher()
    
    required init() {
        super.init(entityClass:Photo.self, serviceName:String(format:"services/rest/?method=flickr.photos.search&api_key=%@&format=json&nojsoncallback=1&", FLICKR_SEARCH_API_KEY), singleName:"photo", pluralName:"photos")
    }
}
