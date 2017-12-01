//
//  PopularFeedsViewController.swift
//  FlickrApp
//
//  Created by aSqar on 24.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import UIKit

class PopularFeedsViewController : ImageListViewController {

//    override var viewModel:PopularFeedsViewModel!

    override func viewDidLoad() {
        self.viewModel = PopularFeedsViewModel()
        super.viewDidLoad()
    }

    override func showSpinner() {
        self.showLoadingView(msg: "Loading feeds...".localized)
    }

    func prepareForSegue(segue:UIStoryboardSegue!, sender:AnyObject!) {
        if (segue.destination is SearchViewController) {
            let searchViewModel:SearchViewModel! = SearchViewModel()
            let vc:SearchViewController! = segue.destination as! SearchViewController
            vc.viewModel = searchViewModel
        }
    }
}
