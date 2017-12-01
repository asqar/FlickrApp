//
//  MyLocalizedString.swift
//  FlickrApp
//
//  Created by aSqar on 01.12.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return Language.get(key: self, alter: "")
    }
}
