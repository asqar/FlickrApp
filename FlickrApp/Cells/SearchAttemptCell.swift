//
//  SearchAttemptCell.swift
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import UIKit

class SearchAttemptCell : UITableViewCell {

    var viewModel:SearchAttemptViewModel!
    
    @IBOutlet weak var lblSearchTerm: UILabel?
    @IBOutlet weak var lblSearchDate: UILabel?
    
    func setSelected(selected:Bool, animated:Bool) {
        super.setSelected(selected, animated:animated)

        // Configure the view for the selected state
    }

    func setViewModel(viewModel:SearchAttemptViewModel!) {
        lblSearchTerm?.text = viewModel.queryString
        lblSearchDate?.text = viewModel.dateString
    }
}
