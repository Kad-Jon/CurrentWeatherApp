//
//  LocationSearchTable.swift
//  CurrentWeatherApp
//
//  Created by XCodeClub on 2019-02-08.
//  Copyright © 2019 Kjonza. All rights reserved.
//

import UIKit
import MapKit

// Declare location search protocol
protocol LocationSearchDelegate {
    
    // Method to allow delegate to handle locationSelection
    func locationSelected(location: MKMapItem)
}

class LocationSearchTable: UITableViewController {
    
    // matching Items array will be used as datasource for the tableview
    var matchingItems:[MKMapItem] = []
    var delegate:LocationSearchDelegate?
    
}

// UISearchResultsUpdating Delegate
extension LocationSearchTable: UISearchResultsUpdating {
    
    // function that updates search results
    func updateSearchResults(for searchController: UISearchController) {
        
        // Store a reference to the search controllers search bar text
        guard let searchBarText = searchController.searchBar.text else {
            return
        }
        
        // Instantiate a MKLocal search request object
        let request = MKLocalSearch.Request()
        
        // Set the request 'naturalLanguageQuery' text to the search Bar text
        request.naturalLanguageQuery = searchBarText
        
        // Initialize an MKLocalSearch object using the configured request object
        let search = MKLocalSearch(request: request)
        
        // 'start' the search and and all going well retrieve a response, which contains an array of MKMapItems
        search.start { (response, _ ) in
            guard let response = response else {
                return
            }
            
            // Set the matching Items array, which provides the table view with data, as equivalent to the map items array
            self.matchingItems = response.mapItems
            
            // Reload table view to display the new data
            self.tableView.reloadData()
        }
    }
}

// MARK:- Table View protocol methods

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // numbers of rows is the number of matching results to the search
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Instatiate cell from IB and store a reference to its placemark property (which contains user friendly location data)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        
        // Set cell label to placemark name for location and return the cell
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = ""
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Once a location listed in the tableView has been selected, let the delegated view controller handle the passed map item and then dismiss the locationsearchtable
        delegate?.locationSelected(location: matchingItems[indexPath.row])
        self.dismiss(animated: true,completion: nil)
        
    }
}
