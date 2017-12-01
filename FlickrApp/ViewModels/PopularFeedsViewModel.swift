//
//  PopularFeedsViewModel.m
//  FlickrApp
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Realm
import RBQFetchedResultsController
import ReactiveCocoa

class PopularFeedsViewModel : ImageListViewModel {

    override var title : String! {
        return "Popular Feeds".localized
    }

    override var fetcher : RemoteFetcher! {
        return FeedFetcher.sharedFetcher
    }

    override var fetchRequest : RBQFetchRequest! {
        let sd1:RLMSortDescriptor! = RLMSortDescriptor(keyPath:"datePublished", ascending:true)
        let sortDescriptors:[RLMSortDescriptor]! = [ sd1 ]
        let fetchRequest:RBQFetchRequest! = RBQFetchRequest(entityName:"Feed", in:self.realm(), predicate:nil)
        fetchRequest.sortDescriptors = sortDescriptors
        return fetchRequest
    }

    override var serviceUrl : String! {
        return ""
    }

    override func processDownloadedResults(results:[AnyObject]!) {
    }

    override func objectAtIndexPath(indexPath:IndexPath!) -> ImageViewModel! {
        let feed:Feed! = self.fetchedResultsController.object(at: indexPath) as! Feed
        return ImageViewModel(feed:feed)
    }
}
