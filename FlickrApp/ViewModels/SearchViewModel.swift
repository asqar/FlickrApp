//
//  SearchViewModel.swift
//  FlickrApp
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Realm
import RBQFetchedResultsController
import ReactiveCocoa

class SearchViewModel : BaseViewModel, RBQFetchedResultsControllerDelegate {

    // MARK: - Public methods

    private(set) var updatedContentSignal:RACSignal!
    
    private var _fetchedResultsController:RBQFetchedResultsController!
    var fetchedResultsController:RBQFetchedResultsController! {
        get { 
            if _fetchedResultsController == nil {
                _fetchedResultsController = RBQFetchedResultsController(fetchRequest:self.fetchRequest(), sectionNameKeyPath:nil, cacheName:nil)
                _fetchedResultsController.delegate = self
                _fetchedResultsController.performFetch()
            }

            return _fetchedResultsController
        }
        set { _fetchedResultsController = newValue }
    }

    override init() {
        super.init()
        
        self.updatedContentSignal = RACSubject()
        self.updatedContentSignal.name = "SearchResultViewModel updatedContentSignal"

        self.didBecomeActiveSignal.subscribeNext({ (x) in
            self.loadHistory()
            })

    }

    func loadHistory() {
        self.fetchedResultsController.performFetch()
    }

    func numberOfSections() -> Int {
        return self.fetchedResultsController.numberOfSections()
    }

    func numberOfItemsInSection(section:Int) -> Int {
        return self.fetchedResultsController.numberOfRows(forSectionIndex: section)
    }

    func objectAtIndexPath(indexPath:IndexPath!) -> SearchAttemptViewModel! {
        let search:SearchAttempt! = self.fetchedResultsController.object(at: indexPath) as! SearchAttempt
        return SearchAttemptViewModel(searchAttempt:search)
    }

    // MARK: - Fetched results controller

    func fetchRequest() -> RBQFetchRequest! {
        let sd1:RLMSortDescriptor! = RLMSortDescriptor(keyPath:"dateSearched", ascending:false)
        let sortDescriptors:[RLMSortDescriptor]! = [ sd1 ]

        let fetchRequest:RBQFetchRequest! = RBQFetchRequest(entityName:"SearchAttempt", in:self.realm(), predicate:nil)
        fetchRequest.sortDescriptors = sortDescriptors
        return fetchRequest
    }

    // `fetchedResultsController` has moved as a getter.

    func controllerDidChangeContent(_ controller:RBQFetchedResultsController) {
        (self.updatedContentSignal as! RACSubject).sendNext({ (x:Any!) in })
    }

    func controllerWillChangeContent(_ controller:RBQFetchedResultsController) {

    }

    func controller(_ controller:RBQFetchedResultsController, didChange anObject:RBQSafeRealmObject, at indexPath:IndexPath?, for type:NSFetchedResultsChangeType, newIndexPath:IndexPath?) {

    }

    func controller(_ controller:RBQFetchedResultsController, didChangeSection section:RBQFetchedResultsSectionInfo, at sectionIndex:UInt, for type:NSFetchedResultsChangeType) {

    }
}
