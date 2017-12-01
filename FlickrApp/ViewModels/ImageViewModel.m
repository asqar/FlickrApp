//
//  ImageViewModel.m
//  FlickrApp
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Foundation

class ImageViewModel : BaseViewModel {

    var url:URL!
    var caption:String!

    init(photo:Photo!, isThumbnail:Bool) {
        super.init()
        
        let urlFormat = isThumbnail ? "http://farm%d.static.flickr.com/%@/%@_%@_m.jpg" : "http://farm%d.static.flickr.com/%@/%@_%@.jpg"
        
        let urlString:String! = String(format:urlFormat, photo.farm, photo.server, photo.photoId, photo.secret)
        self.url = URL(string: urlString)
        self.caption = photo.title
    }

    init(feed:Feed!) {
        super.init()
        
        self.url = URL(string: feed.media)
        self.caption = String(format:"@%@", feed.author)
    }
}
