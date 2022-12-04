//
//  BarListTableViewController.swift
//  MapApp
//
//  Created by Matthew Morris on 6/24/22.
//

import UIKit
import SwiftUI
import CoreLocation

class BarListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    var bars: [Bars] = []
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    lazy var mapButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(cgColor: .init(red: 0.1, green: 0.1, blue: 0.11, alpha: 1))
        button.setImage(UIImage(systemName: "map"), for: .normal)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(returnToMap), for: .touchUpInside)
        
        return button
    }()
    
    lazy var barTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 125
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor = CGColor(red: 0.15, green: 0.15, blue: 0.16, alpha: 1)
        tableView.layer.borderWidth = 1
        
        return tableView
    }()
    
    lazy var tabBar: UIView = {
        let bar = UIView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        
        return bar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(cgColor: .init(red: 0.1, green: 0.1, blue: 0.11, alpha: 1))
        
        guard let currentLocation = locationManager.location else { return }
        
        setUpTableView()
        
        retrieveBars(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, category: "bars", limit: 50, sortBy: "distance", locale: "en_US") { response, error in
            
            if let response = response {
                self.bars = response
                DispatchQueue.main.async {
                    self.barTableView.reloadData()
                }
            }
        }
        
        view.addSubview(barTableView)
        view.addSubview(tabBar)
        tabBar.addSubview(mapButton)
        
        NSLayoutConstraint.activate([
            barTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            barTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            barTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            barTableView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            tabBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09),
            
            mapButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: 10),
            mapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func returnToMap() {
        dismiss(animated: true)
    }
    
    func metersToMiles(meters: Double) -> Double {
        let miles = meters / 1609.344
        
        return miles.rounded(toPlaces: 1)
    }
    
    func setUpTableView() {
        barTableView.register(BarTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupBarView(id: String?) {
        let barView = BarViewController()
        barView.id = id
        present(barView, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bars.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BarTableViewCell
        
        let fileURL = URL(string: bars[indexPath.row].image_url!)
        let distance = bars[indexPath.row].distance
        
        cell.title.text = bars[indexPath.row].name
        
        if fileURL != nil {
            cell.image.load(url: fileURL!)
        } else {
            cell.image.image = .remove
        }
        
        if distance != nil {
            cell.distance.text = "Distance: \(metersToMiles(meters: distance!)) miles"
        } else {
            cell.distance.text = "Distance: N/A"
        }
        
        cell.address.text = bars[indexPath.row].address
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setupBarView(id: bars[indexPath.row].id)
    }
    

}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
