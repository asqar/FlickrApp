//
//  ImageCell.swift
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import UIKit
import SDWebImage

class ImageCell : UICollectionViewCell {
    
    @IBOutlet weak var imgPhoto: UIImageView?
    @IBOutlet weak var lblName: UILabel?
    @IBOutlet weak var progressView: UIProgressView?
    
    var viewModel:ImageViewModel!

    func setViewModel(viewModel:ImageViewModel!) {
        self.viewModel = viewModel

        imgPhoto?.sd_setImage(with: viewModel.url, placeholderImage:UIImage(named: "placeholder.png"),
                                    options:SDWebImageOptions(rawValue: 0), progress:{ (receivedSize:Int,expectedSize:Int) in
                                        self.progressView!.progress = Float(receivedSize / expectedSize)
         }, completed:{ (image:UIImage?,error:NSError?,cacheType:SDImageCacheType,imageURL:URL?) in
            self.progressView!.isHidden = true
            } as! SDWebImageCompletionBlock)

        lblName?.text = viewModel.caption
    }
}
