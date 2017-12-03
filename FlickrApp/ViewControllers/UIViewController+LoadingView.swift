//
//  UIViewController+LoadingView.swift
//  FlickrApp
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import UIKit
import KVNProgress

extension UIViewController {

    func showLoadingView(msg:String!) {
        KVNProgress.show(withStatus: msg)
    }

    func hideLoadingView() {
        KVNProgress.dismiss()
    }
}
