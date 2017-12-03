//
//  SearchViewController.swift
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import UIKit
import SVPullToRefresh

class SearchViewController : UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar?
    @IBOutlet weak var pullToRefreshView: SVPullToRefreshView?
    
    var viewModel:SearchViewModel!
    
    deinit {
        self.tableView?.delegate = nil;
        self.tableView?.dataSource = nil;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.translateUI()
        // Do any additional setup after loading the view.

        self.tableView.addPullToRefresh(actionHandler: {
            self.tableView.reloadData()
            self.tableView.pullToRefreshView.stopAnimating()
        })
        self.tableView.addInfiniteScrolling(actionHandler: {
            
        })
        self.viewModel.updatedContentSignal.subscribeNext({ (x) in
            self.tableView.reloadData()
            self.tableView.pullToRefreshView.stopAnimating()
            self.tableView.infiniteScrollingView.stopAnimating()
            })

        self.viewModel.loadHistory()
    }

    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        self.viewModel.isActive = true
    }

    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func translateUI() {
        self.title = "Search".localized
    }

    // MARK: - Search

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0
            {return}
        searchBar.endEditing(true)

        let vc:SearchResultViewController! = self.storyboard!.instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
        vc.viewModel = SearchResultViewModel(searchQuery:self.searchBar?.text)
        self.navigationController!.pushViewController(vc, animated:true)

        self.searchBar?.text = ""
    }

    // MARK: - UITableView data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections()
    }

    override func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return self.viewModel.numberOfItemsInSection(section: 0)
    }

    override func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        let cell:SearchAttemptCell! = tableView.dequeueReusableCell(withIdentifier: "SearchAttemptCell") as! SearchAttemptCell
        let viewModel:SearchAttemptViewModel! = self.viewModel.objectAtIndexPath(indexPath: indexPath)
        cell.setViewModel(viewModel: viewModel)
        return cell
    }

    override func tableView(_ tableView:UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat {
        let searchAttempt:SearchAttemptViewModel! = self.viewModel.objectAtIndexPath(indexPath: indexPath)

        let width:CGFloat = UIScreen.main.bounds.size.width - 20.0 * 2 - 156.0 - 35.0
        let height:CGFloat = searchAttempt.queryString.boundingRect(with: CGSize(width:width, height:CGFloat(MAXFLOAT)), options:NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), attributes:[NSFontAttributeName: UIFont(name: "HelveticaNeue", size:17.0) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)], context:nil).size.height + 20.0
        return height
    }

    override func tableView(_ tableView:UITableView, didSelectRowAt indexPath:IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated:true)
    }

    // MARK: -

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is SearchResultViewController) {
            let searchAttemptViewModel:SearchAttemptViewModel! = self.viewModel.objectAtIndexPath(indexPath: self.tableView.indexPathForSelectedRow)
            let vc:SearchResultViewController! = segue.destination as! SearchResultViewController
            vc.viewModel = SearchResultViewModel(searchAttemptViewModel:searchAttemptViewModel)
        }
    }
}
