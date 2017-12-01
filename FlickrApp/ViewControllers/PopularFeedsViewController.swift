//
//  PopularFeedsViewController.m
//  FlickrApp
//
//  Created by aSqar on 24.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import UIKit

class PopularFeedsViewController : ImageListViewController {

    var viewModel:PopularFeedsViewModel!

    func viewDidLoad() {
        self.viewModel = PopularFeedsViewModel()
        super.viewDidLoad()
    }

    func showSpinner() {
        self.showLoadingView("Loading feeds...".localized)
    }

    func prepareForSegue(segue:UIStoryboardSegue!, sender:AnyObject!) {
        if (segue.destinationViewController is SearchViewController) {
            let searchViewModel:SearchViewModel! = SearchViewModel()
            let vc:SearchViewController! = segue.destinationViewController
            vc.viewModel = searchViewModel
        }
    }
}
