//
//  FeedFetcher.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

class FeedFetcher : RemoteFetcher {
    
    static let sharedFetcher = FeedFetcher()

    required init() {
        super.init(entityClass:Feed.self, serviceName:String(format:"services/feeds/photos_public.gne?format=json&nojsoncallback=1"), singleName:"feed", pluralName:"feeds")
    }
}
