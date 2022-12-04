//
//  barAnnotationView.swift
//  MapApp
//
//  Created by Matthew Morris on 6/13/22.
//

import UIKit
import MapKit

class barAnnotationView: NSObject, MKAnnotation {
    @objc dynamic var coordinate = CLLocationCoordinate2D(latitude: 10, longitude: 10)
    var title: String? = NSLocalizedString("bar name", comment: "bar annotation")
    var subtitle: String?
    

}
