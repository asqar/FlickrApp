//
//  ImageListViewModel.swift
//  FlickrApp
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import RBQFetchedResultsController
import ReactiveCocoa

let PER_PAGE = 10

class ImageListViewModel : BaseViewModel, RBQFetchedResultsControllerDelegate {

    // MARK: - Public methods

    private(set) var updatedContentSignal:RACSignal!
    private(set) var startLoadingSignal:RACSignal!
    private(set) var dismissLoadingSignal:RACSignal!
    private(set) var errorMessageSignal:RACSignal!
    
    var serviceUrl:String! {
        return ""
    }
    
    var currentPage:Int
    
    var title : String! { // virtual
        return ""
    }
    var fetcher : RemoteFetcher! { // virtual
        return nil
    }
    var fetchRequest : RBQFetchRequest!{ // virtual
        return nil
    }
    
    private var _fetchedResultsController:RBQFetchedResultsController!
    var fetchedResultsController:RBQFetchedResultsController! {
        get { 
            if _fetchedResultsController == nil {
                _fetchedResultsController = RBQFetchedResultsController(fetchRequest:self.fetchRequest, sectionNameKeyPath:nil, cacheName:nil)
                _fetchedResultsController.delegate = self
                _fetchedResultsController.performFetch()

                (self.dismissLoadingSignal as! RACSubject).sendNext({ (x:AnyObject!) in })
            }

            return _fetchedResultsController
        }
    }

    override init() {
        self.currentPage = 1
        super.init()
        
//        self.updatedContentSignal = RACSubject.subject() // "ImageListViewModel updatedContentSignal"
//        self.startLoadingSignal = RACSubject.subject() // "ImageListViewModel startLoadingSignal"
//        self.dismissLoadingSignal = RACSubject.subject() // "ImageListViewModel dismissLoadingSignal"
//        self.errorMessageSignal = RACSubject.subject() // "ImageListViewModel errorMessageSignal"
//
//
//        self.didBecomeActiveSignal.subscribeNext({ (x:AnyObject!) in 
//        })


    }

    func numberOfSections() -> Int {
        return self.fetchedResultsController.numberOfSections()
    }

    func numberOfItemsInSection(section:Int) -> Int {
        return self.fetchedResultsController.numberOfRows(forSectionIndex: section)
    }

    // to be overriden
    func objectAtIndexPath(indexPath:IndexPath!) -> ImageViewModel! {
        return nil
    }

    // MARK: - Search

    func processDownloadedResults(results:[AnyObject]!) {}

    func downloadImagesUpdating(updating:Bool) {
        if updating {
            self.currentPage = 1
        } else {
            self.currentPage += 1
        }

        self.fetcher.fetchManyFromPath(restServiceUrl: String(format:"%@&per_page=%d&page=%d", self.serviceUrl, PER_PAGE, self.currentPage),  synchronoulsy:false, success:{ (operation:URLSessionTask!,mappingResult:AnyObject!) in

            self.processDownloadedResults(results: mappingResult as! [AnyObject]!)

            self._fetchedResultsController = nil

            (self.updatedContentSignal as! RACSubject).sendNext({ (x:AnyObject!) in })
        }, failure:{ (operation:URLSessionTask!,error:NSError!) in 
            (self.dismissLoadingSignal as! RACSubject).sendNext({ (x:AnyObject!) in })

#if DEBUG
            NSLog("%@", error)
            //[self.errorMessageSignal sendNext:^(id x) {}];
#endif
        })
    }

    // MARK: - Fetched results controller

    // `fetchedResultsController` has moved as a getter.

    func controllerDidChangeContent(_ controller:RBQFetchedResultsController) {
        (self.updatedContentSignal as! RACSubject).sendNext({ (x:AnyObject!) in })
    }

    func controllerWillChangeContent(_ controller:RBQFetchedResultsController) {

    }

    func controller(_ controller:RBQFetchedResultsController, didChange anObject:RBQSafeRealmObject, at indexPath:IndexPath?, for type:NSFetchedResultsChangeType, newIndexPath:IndexPath?) {

    }

    func controller(_ controller:RBQFetchedResultsController, didChangeSection section:RBQFetchedResultsSectionInfo, at sectionIndex:UInt, for type:NSFetchedResultsChangeType) {

    }
}
