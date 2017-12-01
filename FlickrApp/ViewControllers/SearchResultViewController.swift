//
//  SearchResultViewController.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import UIKit

class SearchResultViewController : ImageListViewController {

//    var viewModel:SearchResultViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func showSpinner() {
        self.showLoadingView(msg: "Loading search results...".localized)
    }
}
