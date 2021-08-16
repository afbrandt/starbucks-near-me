//
//  ViewController.swift
//  StarbucksNearMe
//
//  Created by Andrew Brandt on 7/26/21.
//

import UIKit

//Responsible for most event handling.  Requests data from data manager and passes location data
//to list and map views.
class HomeController: UIViewController {
    
    let locationProvider = AppCore.assembly.locationProvider
    let locationDataManager = AppCore.assembly.locationDataManager
    
    var listViewController: LocationListViewController?

    @IBOutlet weak var activityOverlay: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if locationProvider.hasLocationPermission {
            locationProvider.beginLocationUpdates()
        } else if !locationProvider.didRequestPermission || locationProvider.didObtainPermission {
            locationProvider.tryRequestLocationUse()
        } else {
            let errorInfo = [NSLocalizedDescriptionKey:"Location permission not available."]
            let error = NSError(domain: "LocationService",
                                code: 999,
                                userInfo: errorInfo)
            
            self.presentError(error: error)
        }
        
        self.title = "Starbucks Near Me"
        
        let controller = self.children.first(where: { $0 is LocationListViewController })
        
        if let listController = controller as? LocationListViewController {
            listController.delegate = self
            self.listViewController = listController
        }
        
        self.updateNearbyLocations()
    }
    
    func updateNearbyLocations() {
        self.activityOverlay.isHidden = false
        
        self.locationDataManager.fetchNearestLocations { locations, error in
            if let error = error {
                self.presentError(error: error)
                return
            }
            
            guard let locations = locations else {
                return
            }
            
            let coordinate = self.locationDataManager.fetchLocationsCoordinate
            
            DispatchQueue.main.async {
                self.listViewController?.lastKnownCoordinate = coordinate
                self.listViewController?.displayLocations(locations: locations)
                self.activityOverlay.isHidden = true
            }
        }
    }
    
    func presentError(error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func presentNoLocationsFound() {
        let alert = UIAlertController(title: "Result",
                                      message: "No Starbucks Found.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let location = sender as? Location else {
            return
        }
        
        if let destination = segue.destination as? LocationDetailViewController {
            destination.location = location
        }
    }
}

extension HomeController: LocationListViewDelegate {
    func listViewDidTapLocation(location: Location) {
        self.performSegue(withIdentifier: "pushDetail", sender: location)
    }
    
    func listViewDidRequestRefresh() {
        self.updateNearbyLocations()
    }
}
