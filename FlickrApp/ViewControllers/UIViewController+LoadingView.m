//
//  UIViewController+LoadingView.m
//  FlickrApp
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import UIKit
import DejalActivityView

extension UIViewController {

    func showLoadingView(msg:String!) {
        if DejalBezelActivityView.current() != nil
        {
            DejalBezelActivityView.current().activityLabel.text = msg
        } else {
            DejalBezelActivityView(for: self.view, withLabel: msg, width:UInt(250.0)).animateShow()
        }
    }

    func hideLoadingView() {
        DejalBezelActivityView.remove(animated: true)
    }
}
