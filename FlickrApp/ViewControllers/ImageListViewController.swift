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


class ImageListViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var pullToRefreshView: SVPullToRefreshView?
    
    var viewModel:ImageListViewModel!
    
    private var _photoBrowser:MWPhotoBrowser!
    
    var photoBrowser:MWPhotoBrowser! {
        get { 
            if _photoBrowser == nil {
                _photoBrowser = MWPhotoBrowser(delegate:self as! MWPhotoBrowserDelegate)
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
        self.viewModel.updatedContentSignal.subscribeNext({ (x:AnyObject!) in
            self.collectionView?.reloadData()
            self.collectionView?.pullToRefreshView.stopAnimating()
            self.collectionView?.infiniteScrollingView.stopAnimating()
            } as! (Any?) -> Void)
        self.viewModel.dismissLoadingSignal.subscribeNext({ (x:AnyObject!) in
            self.hideLoadingView()
            KVNProgress.dismiss()
            } as! (Any?) -> Void)
        self.viewModel.startLoadingSignal.subscribeNext({ (x:AnyObject!) in 

            } as! (Any?) -> Void)
        self.viewModel.errorMessageSignal.subscribeNext({ (x:AnyObject!) in 
            KVNProgress.showError(withStatus: "Technical error. Try again later".localized)
            } as! (Any?) -> Void)

        self.showSpinner()
        self.viewModel.downloadImagesUpdating(updating: true)
    }

    func showSpinner() {
        self.showLoadingView(msg: "Loading results...".localized)
    }

    func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        //self.viewModel.active = true

        self.photoBrowser.delegate = nil
        _photoBrowser = nil
    }

    func viewDidDisappear(animated:Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - FMMosaicLayoutDelegate

    func collectionView(collectionView:UICollectionView!, layout collectionViewLayout:FMMosaicLayout!, numberOfColumnsInSection section:Int) -> Int {
        return kFMMosaicColumnCount
    }

    func collectionView(collectionView:UICollectionView!, layout collectionViewLayout:FMMosaicLayout!, mosaicCellSizeForItemAtIndexPath indexPath:IndexPath!) -> FMMosaicCellSize {
        return (indexPath.item % 12 == 0) ? FMMosaicCellSize.big : FMMosaicCellSize.small
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

    func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int {
        return self.viewModel.numberOfItemsInSection(section: section)
    }

    func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell {
        let cell:ImageCell! = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.viewModel = self.viewModel.objectAtIndexPath(indexPath: indexPath)
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

    func photoBrowser(photoBrowser:MWPhotoBrowser!, photoAtIndex index:UInt) -> MWPhoto! {
        if index < self.viewModel.numberOfItemsInSection(section: 0) {
            let image:ImageViewModel! = self.viewModel.objectAtIndexPath(indexPath: NSIndexPath.init(row: Int(index), section:0) as IndexPath!)
            let photoObj:MWPhoto! = MWPhoto(url: image.url)
            photoObj.caption = image.caption
            return photoObj
        }
        return nil
    }
}
