//
//  PhotoImageViewModel.swift
//  FlickrApp
//
//  Created by aSqar on 03.12.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Foundation

class PhotoImageViewModel : ImageViewModel {
    private var _photo:Photo
    
    override func url(isThumbnail:Bool) -> URL! {
        let urlFormat = isThumbnail ? "http://farm%d.static.flickr.com/%@/%@_%@_m.jpg" : "http://farm%d.static.flickr.com/%@/%@_%@.jpg"
        let urlString:String! = String(format:urlFormat, _photo.farm, _photo.server, _photo.photoId, _photo.secret)
        return URL(string: urlString)
    }
    
    init(photo:Photo!) {
        self._photo = photo
        super.init()
        self.caption = photo.title
    }
}
