//
//  LocationsViewController.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import UIKit

protocol LocationsDelegate {
    func setCurrentLocation(_ location: LocationModel)
}

class LocationsViewController: UITableViewController, MapViewDelegate {
    private let getLocations = GetLocationsInteractor()
    private let removeLocation = RemoveLocationInteractor()
    
    private var locations: [LocationModel]? = nil
    var delegate: LocationsDelegate? = nil
    
    override func viewDidLoad() {
        reloadLocations()
        navigationItem.title = "locations"~
    }
    
    private func reloadLocations() {
        locations = getLocations.invoke()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "remove"~) { [weak self] (action, view, completion) in
            self?.removeLocation(at: indexPath)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    private func removeLocation(at indexPath: IndexPath) {
        if let locations = locations {
            let location = locations[indexPath.row]
            removeLocation.invoke(location: location)
            
            self.locations?.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
        if let location = locations?[indexPath.row] {
            delegate?.setCurrentLocation(location)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let vc = segue.destination as! MapViewController
            vc.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location = locations![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationItemCell", for: indexPath) as! LocationItemCell
        cell.titleLabel.text = location.title
        return cell
    }
    
    func addLocation() {
        reloadLocations()
    }
}
