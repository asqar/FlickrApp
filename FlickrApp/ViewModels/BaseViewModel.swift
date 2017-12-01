//
//  BaseViewModel.swift
//  FlickrApp
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Realm

class BaseViewModel : NSObject {

    func realm() -> RLMRealm! {
        return RLMRealm.default()
    }
}
