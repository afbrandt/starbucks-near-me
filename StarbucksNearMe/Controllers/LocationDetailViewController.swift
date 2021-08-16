//
//  LocationDetailViewController.swift
//  StarbucksNearMe
//
//  Created by Andrew Brandt on 7/27/21.
//

import UIKit
import MapKit

//Simple view controller that shows the position of a location on a map.
class LocationDetailViewController: UIViewController {
    
    var location: Location?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.title = "Starbucks Details"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.detailLabel.text = location?.approximateAddress
        
        if let coordinate = self.location?.coordinate {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate

            self.mapView.addAnnotation(annotation)
            
            self.mapView.showAnnotations([annotation], animated: true)
        }
    }
}

extension LocationDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "StarbucksAnnotation"
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
}
