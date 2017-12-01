//
//  SearchResultViewModel.m
//  FlickrApp
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Realm
import RBQFetchedResultsController

class SearchResultViewModel : ImageListViewModel {

    private var _searchAttempt:SearchAttempt!
    private var searchAttempt:SearchAttempt! {
        get { return _searchAttempt }
        set { _searchAttempt = newValue }
    }

    init(searchAttemptViewModel:SearchAttemptViewModel!) {
        self.init(searchQuery:searchAttemptViewModel.queryString)
    }

    init(searchQuery:String!) {
        super.init()

        self.realm().beginWriteTransaction()
        let searchAttempt:SearchAttempt! = SearchAttempt()
        searchAttempt.searchTerm = searchQuery
        searchAttempt.dateSearched = NSDate.date()
        self.realm().addOrUpdateObject(searchAttempt)
        self.realm().commitWriteTransaction()

        self.searchAttempt = searchAttempt
        return self
    }

    func title() -> String! {
        return _searchAttempt.searchTerm
    }

    func fetcher() -> RemoteFetcher! {
        return PhotoFetcher.sharedFetcher
    }

    func fetchRequest() -> RBQFetchRequest! {
        let sd1:RLMSortDescriptor! = RLMSortDescriptor(keyPath:"orderIndex", ascending:true)
        let sortDescriptors:[RLMSortDescriptor]! = [ sd1 ]

        let fetchRequest:RBQFetchRequest! = RBQFetchRequest(entityName:"Photo", in:self.realm(), predicate:nil)
        fetchRequest.predicate = NSPredicate(format:"searchAttempt.searchTerm == %@", self.searchAttempt.searchTerm)
        fetchRequest.sortDescriptors = sortDescriptors
        return fetchRequest
    }

    func serviceUrl() -> String! {
        let encodedStr:String! = self.searchAttempt.searchTerm.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        return String(format:"text=%@", encodedStr)
    }

    override func processDownloadedResults(results:[AnyObject]!) {
        self.realm().transactionWithBlock({ 

            let orderIndex:Int = self.numberOfItemsInSection(0) + 1
            for item:Photo! in results {  
                item.orderIndex = orderIndex
                item.searchAttempt = self.searchAttempt
                orderIndex++
             }
        })
    }

    override func objectAtIndexPath(indexPath:IndexPath!) -> ImageViewModel! {
        let photo:Photo! = self.fetchedResultsController.objectAtIndexPath(indexPath)
        return ImageViewModel(photo:photo)
    }
}
