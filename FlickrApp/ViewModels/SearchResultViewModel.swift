//
//  SearchResultViewModel.swift
//  FlickrApp
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Realm
import RBQFetchedResultsController

class SearchResultViewModel : ImageListViewModel {

    private var searchAttempt:SearchAttempt!

    convenience init(searchAttemptViewModel:SearchAttemptViewModel!) {
        self.init(searchQuery:searchAttemptViewModel.queryString)
    }

    init(searchQuery:String!) {
        super.init()

        self.realm().beginWriteTransaction()
        let searchAttempt:SearchAttempt! = SearchAttempt()
        searchAttempt.searchTerm = searchQuery
        searchAttempt.dateSearched = NSDate() as Date!
        self.realm().addOrUpdate(searchAttempt)
        do {
            try self.realm().commitWriteTransaction()
        } catch {
            
        }
        self.searchAttempt = searchAttempt
    }

    override var title : String! {
        return searchAttempt.searchTerm
    }

    override var fetcher : RemoteFetcher! {
        return PhotoFetcher.sharedFetcher
    }

    override var fetchRequest : RBQFetchRequest! {
        let sd1:RLMSortDescriptor! = RLMSortDescriptor(keyPath:"orderIndex", ascending:true)
        let sortDescriptors:[RLMSortDescriptor]! = [ sd1 ]

        let fetchRequest:RBQFetchRequest! = RBQFetchRequest(entityName:"Photo", in:self.realm(), predicate:nil)
        fetchRequest.predicate = NSPredicate(format:"searchAttempt.searchTerm == %@", self.searchAttempt.searchTerm)
        fetchRequest.sortDescriptors = sortDescriptors
        return fetchRequest
    }

    override var serviceUrl : String! {
        let encodedStr:String! = self.searchAttempt.searchTerm.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed)
        return String(format:"text=%@", encodedStr)
    }

    override func processDownloadedResults(results:[AnyObject]!) {
        self.realm().beginWriteTransaction()
        var orderIndex:Int = self.numberOfItemsInSection(section: 0) + 1
        for item:Photo! in results as! [Photo]{
            item.orderIndex = orderIndex
            item.searchAttempt = self.searchAttempt
            orderIndex += 1
        }
        do {
            try self.realm().commitWriteTransaction()
        } catch {
            
        }
    }

    override func objectAtIndexPath(indexPath:IndexPath!) -> ImageViewModel! {
        let photo:Photo! = self.fetchedResultsController.object(at: indexPath) as! Photo
        return PhotoImageViewModel(photo:photo)
    }
}
