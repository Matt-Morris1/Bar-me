//
//  ViewController.swift
//  MapApp
//
//  Created by Matthew Morris on 4/27/22.
//

import UIKit
import MapKit
import CoreLocation
import SwiftUI

class MapViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var barMapView: MKMapView!
    var searchController = UISearchController()
    var tableView: UITableViewController!
    
    var latitude: Double?
    var longitude: Double?
    
    var bars: [Bars] = []
    let newBar = Bars()
    
    var tabBar: UIView!
    var listButton: UIButton!
    var yelpLabel: UILabel!
    
    var selectedAnnotation: MKAnnotation?
    
    let locationManager: CLLocationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listBarButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(openBarList))
        let mapBarButton = UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: self, action: #selector(buttonTest))
        navigationController?.setToolbarItems([listBarButton, mapBarButton], animated: true)
        navigationController?.toolbar.layer.zPosition = 5
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
    
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
//        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set up the map view and center the view on the user location
        
        barMapView = MKMapView()
        tabBar = UIView()
        listButton = UIButton()
        yelpLabel = UILabel()
        
        guard let currentLocation = locationManager.location else { return }

        barMapView.frame = CGRect(x: view.center.x, y: view.center.y, width: view.frame.size.width, height: view.frame.size.height)

        barMapView.mapType = MKMapType.standard
        barMapView.center = view.center
        barMapView.isScrollEnabled = true
        barMapView.isZoomEnabled = true
        barMapView.showsUserLocation = true
        barMapView.layer.zPosition = -1
        barMapView.delegate = self
        barMapView?.centerToLocation(currentLocation)
        
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.backgroundColor = UIColor(cgColor: .init(red: 0.1, green: 0.1, blue: 0.11, alpha: 1))
        tabBar.layer.masksToBounds = true
        tabBar.layer.borderColor = CGColor(red: 0.15, green: 0.15, blue: 0.16, alpha: 1)
        tabBar.layer.borderWidth = 1
        
        listButton.translatesAutoresizingMaskIntoConstraints = false
        listButton.setImage(UIImage(systemName: "list.dash"), for: .normal)
        listButton.addTarget(self, action: #selector(openBarList), for: .touchUpInside)
        
        yelpLabel.translatesAutoresizingMaskIntoConstraints = false
        yelpLabel.text = "Powered by Yelp"
        yelpLabel.font = UIFont(name: "Helvetica Neue", size: 20)
        yelpLabel.textColor = UIColor(cgColor: .init(gray: 0.5, alpha: 0.7))

        view.addSubview(barMapView)
        barMapView.addSubview(tabBar)
        barMapView.bringSubviewToFront(tabBar)
        barMapView.addSubview(yelpLabel)
        barMapView.bringSubviewToFront(yelpLabel)
        tabBar.addSubview(listButton)

        NSLayoutConstraint.activate([
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            tabBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09),

            listButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: 10),
            listButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            yelpLabel.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -5),
            yelpLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5)
        ])
        
        DispatchQueue.main.async {
            self.createAnnotations()
        }
        
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        viewWillAppear(true)
    }
    
    
    @objc func buttonTest() {
        print("Tap Success!")
    }
    
    @objc func openBarList() {
        let vc = BarListTableViewController()
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let name = view.annotation?.title else { return }
        guard let id = view.annotation?.subtitle else { return }
        guard let annotation = view.annotation else { return }
        guard let currentLocation = locationManager.location else { return }
        
        if !annotation.isKind(of: MKUserLocation.self) {
            UIView.animate(withDuration: 0.2, delay: 0) {
                view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(75)) {
                self.setupBarView(name: name, id: id)
            }
            
            UIView.animate(withDuration: 0.1, delay: 0.5) {
                self.barMapView.deselectAnnotation(view.annotation, animated: true)
            }
        } else {
            barMapView.centerToLocation(currentLocation)
        }
    
        
        
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        createAnnotations()
    }
    
    
    
    func setupBarView(name: String?, id: String?) {
        let barView = BarViewController()
        barView.id = id
        present(barView, animated: true)
    }
    
    func createAnnotations() {

        // Print out list of bar locations in the surrounding region, and add annotations to each location

        retrieveBars(latitude: barMapView.region.center.latitude, longitude: barMapView.region.center.longitude, category: "bars", limit: 50, sortBy: "distance", locale: "en_US") { response, error in

            if let response = response {
                self.bars = response
                for bar in response {
                    guard let latitude = bar.latitude else { return }
                    guard let longitude = bar.longitude else { return }

                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        annotation.title = bar.name
                        annotation.subtitle = bar.id

                    self.barMapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        annotationView.clipsToBounds = true
        annotationView.glyphText = ""
        annotationView.markerTintColor = .clear
        annotationView.image = UIImage(named: "Blue Bar")
        annotationView.bounds = CGRect(x: annotationView.center.x, y: annotationView.center.y, width: 75, height: 75)
        annotationView.contentMode = .scaleToFill
        annotationView.subtitleVisibility = .hidden

        return annotationView
    }
    
    
}

extension MapViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //to do
    }
}


private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
