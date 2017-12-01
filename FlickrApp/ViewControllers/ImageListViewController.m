//
//  ImageListViewController.m
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

let kFMHeaderFooterHeight:CGFloat = 44.0
let kFMMosaicColumnCount:Int = 2


class ImageListViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MWPhotoBrowserDelegate {

    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var pullToRefreshView: SVPullToRefreshView?
    
    var viewModel:ImageListViewModel!
    
    private var _photoBrowser:MWPhotoBrowser!
    private var photoBrowser:MWPhotoBrowser! {
        get { 
            if _photoBrowser == nil {
                _photoBrowser = MWPhotoBrowser(delegate:self)
                _photoBrowser.view.backgroundColor = UIColor.blackColor
                _photoBrowser.displayActionButton = false
                _photoBrowser.alwaysShowControls = true
                _photoBrowser.zoomPhotosToFill = true
                _photoBrowser.edgesForExtendedLayout = UIRectEdgeNone
                _photoBrowser.extendedLayoutIncludesOpaqueBars = false
            }
            return _photoBrowser
        }
        set { _photoBrowser = newValue }
    }

    func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.title = self.viewModel.title

        self.collectionView.addPullToRefreshWithActionHandler({
            self.viewModel.downloadImagesUpdating(true)
        })
        self.collectionView.addInfiniteScrollingWithActionHandler({
            self.viewModel.downloadImagesUpdating(false)
        })
        self.viewModel.updatedContentSignal.subscribeNext({ (x:AnyObject!) in
            self.collectionView.reloadData()
            self.collectionView.pullToRefreshView.stopAnimating()
            self.collectionView.infiniteScrollingView.stopAnimating()
        })
        self.viewModel.dismissLoadingSignal.subscribeNext({ (x:AnyObject!) in
            self.hideLoadingView()
            KVNProgress.dismiss()
        })
        self.viewModel.startLoadingSignal.subscribeNext({ (x:AnyObject!) in 

        })
        self.viewModel.errorMessageSignal.subscribeNext({ (x:AnyObject!) in 
            KVNProgress.showErrorWithStatus("Technical error. Try again later".localized)
        })

        self.showSpinner()
        self.viewModel.downloadImagesUpdating(true)
    }

    func showSpinner() {
        self.showLoadingView("Loading results...".localized)
    }

    func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        self.viewModel.active = true

        self.photoBrowser.delegate = nil
        self.photoBrowser = nil
    }

    func viewDidDisappear(animated:Bool) {
        super.viewDidDisappear(animated)
    }

    func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - FMMosaicLayoutDelegate

    func collectionView(collectionView:UICollectionView!, layout collectionViewLayout:FMMosaicLayout!, numberOfColumnsInSection section:Int) -> Int {
        return kFMMosaicColumnCount
    }

    func collectionView(collectionView:UICollectionView!, layout collectionViewLayout:FMMosaicLayout!, mosaicCellSizeForItemAtIndexPath indexPath:IndexPath!) -> FMMosaicCellSize {
        return (indexPath.item % 12 == 0) ? FMMosaicCellSizeBig : FMMosaicCellSizeSmall
    }

    func collectionView(collectionView:UICollectionView!, layout collectionViewLayout:FMMosaicLayout!, insetForSectionAtIndex section:Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
    }

    func collectionView(collectionView:UICollectionView!, layout collectionViewLayout:FMMosaicLayout!, interitemSpacingForSectionAtIndex section:Int) -> CGFloat {
        return 2.0
    }

    func collectionView(collectionView:UICollectionView!, layout collectionViewLayout:UICollectionViewLayout!, heightForHeaderInSection section:Int) -> CGFloat {
        return kFMHeaderFooterHeight
    }

    func collectionView(collectionView:UICollectionView!, layout collectionViewLayout:UICollectionViewLayout!, heightForFooterInSection section:Int) -> CGFloat {
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

    func collectionView(collectionView:UICollectionView!, numberOfItemsInSection section:Int) -> Int {
        return self.viewModel.numberOfItemsInSection(section)
    }

    func collectionView(collectionView:UICollectionView!, cellForItemAtIndexPath indexPath:IndexPath!) -> UICollectionViewCell! {
        let cell:ImageCell! = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath)
        cell.viewModel = self.viewModel.objectAtIndexPath(indexPath)
        return cell
    }

    func collectionView(collectionView:UICollectionView!, didSelectItemAtIndexPath indexPath:IndexPath!) {
        self.photoBrowser.currentPhotoIndex = indexPath.row
        self.navigationController!.pushViewController(self.photoBrowser, animated:true)
        self.collectionView.deselectItemAtIndexPath(indexPath, animated:true)
    }

    // MARK: - MWPhotoProwser delegate

    // `photoBrowser` has moved as a getter.

    func numberOfPhotosInPhotoBrowser(photoBrowser:MWPhotoBrowser!) -> UInt {
        let i:UInt = self.viewModel.numberOfItemsInSection(0)
        return i
    }

    func photoBrowser(photoBrowser:MWPhotoBrowser!, photoAtIndex index:UInt) -> MWPhoto! {
        if index < self.viewModel.numberOfItemsInSection(0) {
            let image:ImageViewModel! = self.viewModel.objectAtIndexPath(IndexPath.indexPathForRow(index, inSection:0))
            let photoObj:MWPhoto! = MWPhoto.photoWithURL(image.url)
            photoObj.caption = image.caption
            return photoObj
        }
        return nil
    }
}
