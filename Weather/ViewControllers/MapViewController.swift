//
//  MapViewController.swift
//  Weather
//
//  Created by Александр Шерий on 21.08.2022.
//

import UIKit
import MapKit

protocol MapViewDelegate {
    func addLocation(_ location: Location)
}

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    private var pointAnnotation: MKPointAnnotation? = nil
    private let getLocations = GetLocationsInteractor()
    private let addLocation = AddLocationInteractor()
    var delegate: MapViewDelegate? = nil
    
    override func viewDidLoad() {
        mapView.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickOnMap))
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        getLocations.invoke().forEach {
            self.addAnnotation(at: $0)
        }
    }
    
    @IBAction func addLocation(_ sender: UIBarButtonItem) {
        showAddLocationAlert()
    }
    
    private func showAddLocationAlert() {
        guard let point = pointAnnotation else { return }

        let alert = UIAlertController(title: "Enter title", message: nil, preferredStyle: .alert)
        alert.addTextField()
        if let textField = alert.textFields?.first {
            textField.font = UIFont(name: "System", size: 16)
            textField.autocapitalizationType = .sentences
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let textField = alert.textFields?.first {
                if let title = textField.text, !title.isEmpty {
                    self.addLocationImplAndClose(with: title, point: point)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func addLocationImplAndClose(with title: String, point: MKPointAnnotation) {
        let location = Location(
            title: title,
            lat: point.coordinate.latitude,
            lon: point.coordinate.longitude
        )
        self.addLocation.invoke(location: location) { result in
            switch result {
            case .success:
                do {
                    self.delegate?.addLocation(location)
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func clickOnMap(_ sender: UITapGestureRecognizer) {
        if sender.state != UIGestureRecognizer.State.ended { return }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        
        if pointAnnotation != nil {
            pointAnnotation!.coordinate = locationCoordinate
        } else {
            pointAnnotation = MKPointAnnotation()
            pointAnnotation!.coordinate = locationCoordinate
            mapView.addAnnotation(
                pointAnnotation!
            )
        }
    }
    
    private func addAnnotation(at location: Location) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
        mapView.addAnnotation(annotation)
    }
}
