//
//  FeedImageViewModel.swift
//  FlickrApp
//
//  Created by aSqar on 03.12.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Foundation

class FeedImageViewModel : ImageViewModel {
    private var _feed:Feed
    
    override func url(isThumbnail:Bool) -> URL! {
        return URL(string: isThumbnail ? _feed.media : _feed.media.replacingOccurrences(of: "_m.", with: "."))
    }
    
    init(feed:Feed!) {
        self._feed = feed
        super.init()
        self.caption = String(format:"@%@", feed.author)
    }
}
