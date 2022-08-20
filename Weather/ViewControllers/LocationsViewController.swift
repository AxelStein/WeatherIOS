//
//  LocationsViewController.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import UIKit

class LocationsViewController: UITableViewController {
    private let getLocations = GetLocationsInteractor()
    private var locations: [Location]? = nil
    
    override func viewDidLoad() {
        locations = getLocations.invoke()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location = locations![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationItemCell", for: indexPath) as! LocationItemCell
        cell.titleLabel.text = location.title
        return cell
    }
}