//
//  searchBar.swift
//  EastCoastTrail
//
//  Created by Diego Zuluaga on 2017-07-19.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import Foundation
import UIKit
extension mainViewController {
    
    func setupSearchView(){
        let searchScropTitle = ["Trail", "City","Difficultity"]
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
        self.searchController.searchBar.scopeButtonTitles = searchScropTitle
        
//        tableView.tableHeaderView = searchController.searchBar
    }
    
    func searchHandler(){
        print(123)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
        self.searchController.searchBar.showsScopeBar = true
        return true
    }
    
    
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool{
        return true
    }
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filterTrailHeads = trailHeads.filter({ (trailHead) -> Bool in
            let name = trailHead.properties?.Name
            return (name?.lowercased().contains(searchText.lowercased()))!
        })
        
        self.tableView.reloadData()
    }
    
    
}
