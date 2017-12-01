//
//  SearchResultViewController.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import UIKit

class SearchResultViewController : ImageListViewController {

    var viewModel:SearchResultViewModel!

    func viewDidLoad() {
        super.viewDidLoad()
    }

    func showSpinner() {
        self.showLoadingView("Loading search results...".localized)
    }

    // `setViewModel:` has moved as a setter.
}
