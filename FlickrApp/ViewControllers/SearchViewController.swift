//
//  SearchViewController.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import UIKit
import SVPullToRefresh

class SearchViewController : UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar?
    @IBOutlet weak var pullToRefreshView: SVPullToRefreshView?
    
    var viewModel:SearchViewModel!

    func viewDidLoad() {
        super.viewDidLoad()
        self.translateUI()
        // Do any additional setup after loading the view.

        weakify(self)
        self.tableView.addPullToRefreshWithActionHandler({ 
            strongify(self)
            self.tableView.reloadData()
            self.tableView.pullToRefreshView.stopAnimating()
        })
        self.viewModel.updatedContentSignal.subscribeNext({ (x:AnyObject!) in 
            strongify(self)
            self.tableView.reloadData()
            self.tableView.pullToRefreshView.stopAnimating()
            self.tableView.infiniteScrollingView.stopAnimating()
        })

        self.viewModel.loadHistory()
    }

    func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        self.viewModel.active = true
    }

    func viewDidAppear(animated:Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

    func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func translateUI() {
        self.title = "Search".localized
    }

    // MARK: - Search

    func searchBarSearchButtonClicked(searchBar:UISearchBar!) {
        if _searchBar.text.length == 0
            {return}
        _searchBar.endEditing(true)

        let vc:SearchResultViewController! = self.storyboard.instantiateViewControllerWithIdentifier("SearchResultViewController")
        vc.viewModel = SearchResultViewModel(searchQuery:self.searchBar.text)
        self.navigationController!.pushViewController(vc, animated:true)

        self.searchBar.text = ""
    }

    // MARK: - UITableView data source

    func numberOfSectionsInTableView(tableView:UITableView!) -> Int {
        return self.viewModel.numberOfSections()
    }

    func tableView(tableView:UITableView!, numberOfRowsInSection section:Int) -> Int {
        return self.viewModel.numberOfItemsInSection(0)
    }

    func tableView(tableView:UITableView!, cellForRowAtIndexPath indexPath:IndexPath!) -> UITableViewCell! {
        let cell:SearchAttemptCell! = tableView.dequeueReusableCellWithIdentifier("SearchAttemptCell")
        let viewModel:SearchAttemptViewModel! = self.viewModel.objectAtIndexPath(indexPath)
        cell.viewModel = viewModel
        return cell
    }

    func tableView(tableView:UITableView!, heightForRowAtIndexPath indexPath:IndexPath!) -> CGFloat {
        let searchAttempt:SearchAttemptViewModel! = self.viewModel.objectAtIndexPath(indexPath)

        let width:CGFloat = UIScreen.mainScreen.bounds.size.width - 20.0 * 2 - 156.0 - 35.0
        let height:CGFloat = searchAttempt.queryString.boundingRectWithSize(CGSizeMake(width, MAXFLOAT), options:NSStringDrawingOptions.NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingOptions.NSStringDrawingUsesFontLeading, attributes:[NSFontAttributeName: UIFont.fontWithName("HelveticaNeue", size:17.0)], context:nil).size.height + 20.0
        return height
    }

    func tableView(tableView:UITableView!, didSelectRowAtIndexPath indexPath:IndexPath!) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }

    // MARK: -

    func prepareForSegue(segue:UIStoryboardSegue!, sender:AnyObject!) {
        if (segue.destinationViewController is SearchResultViewController) {
            let searchAttemptViewModel:SearchAttemptViewModel! = self.viewModel.objectAtIndexPath(self.tableView.indexPathForSelectedRow)
            let vc:SearchResultViewController! = segue.destinationViewController
            vc.viewModel = SearchResultViewModel(searchAttemptViewModel:searchAttemptViewModel)
        }
    }
}
