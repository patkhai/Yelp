//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import PKHUD

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate{
    var searchBar: UISearchBar!
    
    var businesses: [Business]!
    var filteredData : [Business]?
    var isMoreDataLoading = false
    var loadMoreView: InfiniteScrollViewCell?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //search bar
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Restaurant"
   
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        searchBar.delegate = self
        filteredData = businesses
        navigationItem.titleView = searchBar
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollViewCell.defaultHeight)
        loadMoreView = InfiniteScrollViewCell(frame: frame)
        loadMoreView!.isHidden = true
        tableView.addSubview(loadMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollViewCell.defaultHeight
        tableView.contentInset = insets
        
      
        Business.searchWithTerm(term: "", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
                self.businesses = businesses
                self.tableView.reloadData()
                
                if let businesses = businesses {
                    for business in businesses {
                        print(business.name!)
                        print(business.address!)
                    }
                } else {
                    self.alertControl()
            }
        
            
            }
        )
        
//        Business.searchWithTerm(term: "Chinese", completion: { (businesses: [Business]?, error: Error?) -> Void in
//
//            self.businesses = businesses
//            self.tableView.reloadData()
//
//            if let businesses = businesses {
//                for business in businesses {
//                    print(business.name!)
//                    print(business.address!)
//                }
//            }
//
//        }
//        )
        
        /*Example of Yelp search with more search options specified
         Business.searchWithTerm(term: "Restaurants", sort: .distance, categories: ["asianfusion", "burgers"]) { (businesses, error) in
                self.businesses = businesses
                 for business in self.businesses {
                     print(business.name!)
                     print(business.address!)
                 }
         }
        */
        
    }
    
    func alertControl () {
        let alertController = UIAlertController(title: "No Network Detected", message: "Connect to Network and Try Again" , preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel) { (action) in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) {(action) in
            
        }
        
        
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true) {
            // optional code for what happens after the alert controller has finished presenting
        }
    }
    
    var limit: Int = 50
    var offset: Int = 50
    
    // Infinite scrolling setting
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollViewCell.defaultHeight)
                loadMoreView?.frame = frame
                loadMoreView!.startAnimating()
                
                // Load more results
                Business.searchWithTerm(term: searchBar.text!, completion: { ( businesses: [Business]?, error: Error?) -> Void in
                   
                    for business in businesses! {
                        self.businesses.append(business)
                    }
                    
                    // update offset
                    self.offset += self.limit
                    
                    // Update flag
                    self.isMoreDataLoading = false
                    
                    // Stop the loading indicator
                    self.loadMoreView?.stopAnimating()
                    
                    self.tableView.reloadData()
                }
                )
            }
        }
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath)as! BusinessCell
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    //search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.filteredData = self.businesses
        }else{
            self.filteredData = self.businesses.filter({
                ($0.name?.contains(searchText))!
            })
        }
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        tableView.resignFirstResponder()
      

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //start the HUD
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        if let text = searchBar.text, text.count > 0 {
            Business.searchWithTerm(term: searchBar.text!, completion: { (businesses: [Business]?, error: Error?) -> Void in
                
                    self.businesses = businesses
                    self.tableView.reloadData()
                    searchBar.setShowsCancelButton(false, animated: true)
                    searchBar.endEditing(true)
                    self.tableView.resignFirstResponder()
                    PKHUD.sharedHUD.hide()
      
        }
            )
    }
}
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
