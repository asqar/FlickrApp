//
//  ImageListViewController.swift
//  FlickrApp
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import UIKit
import MWPhotoBrowser
import FMMosaicLayout
import KVNProgress
import SVPullToRefresh
import ReactiveCocoa

let kFMHeaderFooterHeight:CGFloat = 44.0
let kFMMosaicColumnCount:Int = 2


class ImageListViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MWPhotoBrowserDelegate, FMMosaicLayoutDelegate {

    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var pullToRefreshView: SVPullToRefreshView?
    
    var viewModel:ImageListViewModel!
    
    deinit {
        _photoBrowser?.delegate = nil
        _photoBrowser = nil
    }
    
    private var _photoBrowser:MWPhotoBrowser!
    
    var photoBrowser:MWPhotoBrowser! {
        get { 
            if _photoBrowser == nil {
                _photoBrowser = MWPhotoBrowser(delegate:self)
                _photoBrowser.view.backgroundColor = UIColor.black
                _photoBrowser.displayActionButton = false
                _photoBrowser.alwaysShowControls = true
                _photoBrowser.zoomPhotosToFill = true
                _photoBrowser.edgesForExtendedLayout = UIRectEdge()
                _photoBrowser.extendedLayoutIncludesOpaqueBars = false
            }
            return _photoBrowser
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.title = self.viewModel.title

        self.collectionView?.addPullToRefresh(actionHandler: {
            self.viewModel.downloadImagesUpdating(updating: true)
        })
        self.collectionView?.addInfiniteScrolling(actionHandler: {
            self.viewModel.downloadImagesUpdating(updating: false)
        })
        self.viewModel.updatedContentSignal.subscribeNext({ (x) in
            self.collectionView?.reloadData()
            self.collectionView?.pullToRefreshView.stopAnimating()
            self.collectionView?.infiniteScrollingView.stopAnimating()
            })
        self.viewModel.dismissLoadingSignal.subscribeNext({ (x) in
            self.hideLoadingView()
            })
        self.viewModel.startLoadingSignal.subscribeNext({ (x) in

            })
        self.viewModel.errorMessageSignal.subscribeNext({ (x) in
            KVNProgress.showError(withStatus: "Technical error. Try again later".localized)
            })

        self.showSpinner()
        self.viewModel.downloadImagesUpdating(updating: true)
    }

    func showSpinner() {
        self.showLoadingView(msg: "Loading results...".localized)
    }

    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        self.viewModel.isActive = true

        _photoBrowser?.delegate = nil
        _photoBrowser = nil
    }

    override func viewDidDisappear(_ animated:Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - FMMosaicLayoutDelegate

    func collectionView(_ collectionView:UICollectionView!, layout collectionViewLayout:FMMosaicLayout!, numberOfColumnsInSection section:Int) -> Int {
        return kFMMosaicColumnCount
    }

    func collectionView(_ collectionView:UICollectionView!, layout collectionViewLayout:FMMosaicLayout!, mosaicCellSizeForItemAt indexPath:IndexPath!) -> FMMosaicCellSize {
        return (indexPath.item % 12 == 0) ? FMMosaicCellSize.big : FMMosaicCellSize.small
    }

    func collectionView(_ collectionView:UICollectionView!, layout collectionViewLayout:FMMosaicLayout!, insetForSectionAt section:Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
    }

    func collectionView(_ collectionView:UICollectionView!, layout collectionViewLayout:FMMosaicLayout!, interitemSpacingForSectionAt section:Int) -> CGFloat {
        return 2.0
    }

    private func collectionView(collectionView:UICollectionView!, layout collectionViewLayout:UICollectionViewLayout!, heightForHeaderInSection section:Int) -> CGFloat {
        return kFMHeaderFooterHeight
    }

    private func collectionView(collectionView:UICollectionView!, layout collectionViewLayout:UICollectionViewLayout!, heightForFooterInSection section:Int) -> CGFloat {
        return kFMHeaderFooterHeight
    }

    func headerShouldOverlayContentInCollectionView(collectionView:UICollectionView!, layout collectionViewLayout:FMMosaicLayout!) -> Bool {
        return true
    }

    func footerShouldOverlayContentInCollectionView(collectionView:UICollectionView!, layout collectionViewLayout:FMMosaicLayout!) -> Bool {
        return true
    }

    // MARK: - UICollectionView data source

    func numberOfSectionsInCollectionView(collectionView:UICollectionView!) -> Int {
        return self.viewModel.numberOfSections()
    }

    func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int {
        return self.viewModel.numberOfItemsInSection(section: section)
    }

    func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell {
        let cell:ImageCell! = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.setViewModel(viewModel: self.viewModel.objectAtIndexPath(indexPath: indexPath))
        return cell
    }

    func collectionView(_ collectionView:UICollectionView, didSelectItemAt indexPath:IndexPath) {
        self.photoBrowser.setCurrentPhotoIndex(UInt(indexPath.row))
        self.navigationController!.pushViewController(self.photoBrowser, animated:true)
        self.collectionView?.deselectItem(at: indexPath, animated:true)
    }

    // MARK: - MWPhotoProwser delegate
    
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        let i:UInt = UInt(self.viewModel.numberOfItemsInSection(section: 0))
        return i
    }
    
    func photoBrowser(_ photoBrowser:MWPhotoBrowser!, photoAt index:UInt) -> MWPhotoProtocol! {
        if index < self.viewModel.numberOfItemsInSection(section: 0) {
            let image:ImageViewModel! = self.viewModel.objectAtIndexPath(indexPath: NSIndexPath.init(row: Int(index), section:0) as IndexPath!)
            let photoObj:MWPhoto! = MWPhoto(url: image.url(isThumbnail:false))
            photoObj.caption = image.caption
            return photoObj
        }
        return nil
    }
}
