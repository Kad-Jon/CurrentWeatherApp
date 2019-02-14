//
//  LocationSearchTable.swift
//  CurrentWeatherApp
//
//  Created by XCodeClub on 2019-02-08.
//  Copyright © 2019 Kjonza. All rights reserved.
//

import UIKit
import MapKit

protocol LocationSearchDelegate {
    func remoteLocationRetrieved(location: MKMapItem)
}

class LocationSearchTable: UITableViewController {
    
    var matchingItems:[MKMapItem] = []
    var delegate:LocationSearchDelegate?
    
    
}

extension LocationSearchTable: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else {
            return
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        let search = MKLocalSearch(request: request)
        search.start { (response, _ ) in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = ""
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        delegate?.remoteLocationRetrieved(location: matchingItems[indexPath.row])
        self.dismiss(animated: true,completion: nil)
        
    }
}
