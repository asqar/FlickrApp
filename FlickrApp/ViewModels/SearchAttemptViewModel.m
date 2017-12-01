//
//  SearchAttemptViewModel.m
//  FlickrApp
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Foundation

class SearchAttemptViewModel : BaseViewModel {

    var queryString:String!
    var dateString:String!

    init(searchAttempt:SearchAttempt!) {
        super.init()

        let dateFormatter:DateFormatter! = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
        self.dateString = dateFormatter.string(from: searchAttempt.dateSearched)
        self.queryString = searchAttempt.searchTerm


    }
}
