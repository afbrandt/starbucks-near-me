//
//  DeviceLocationDataProvider.swift
//  StarbucksNearMe
//
//  Created by Andrew Brandt on 7/27/21.
//

import CoreLocation
import Foundation

private enum DevicePermissionHistoryKeys: String {
    case requestedPermission = "DeviceLocationProviderRequestedPermission"
    case obtainedPermission = "DeviceLocationProviderObtainedPermission"
}

class DeviceLocationProvider: NSObject, LocationProvider {
    
    private let locationManager = CLLocationManager()
    
    private var lastKnownLocation: CLLocationCoordinate2D?
    
    var lastKnownLocationCallback: ((CLLocationCoordinate2D?,Error?) -> ())?
    
    var hasLocationPermission: Bool {
        get {
            return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        }
    }
        
    var didRequestPermission: Bool {
        didSet {
            UserDefaults.standard.setValue(didRequestPermission,
                                           forKey: DevicePermissionHistoryKeys.requestedPermission.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    var didObtainPermission: Bool {
        didSet {
            UserDefaults.standard.setValue(didObtainPermission,
                                           forKey: DevicePermissionHistoryKeys.obtainedPermission.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    override init() {
        self.didRequestPermission = UserDefaults.standard.bool(forKey: DevicePermissionHistoryKeys.requestedPermission.rawValue)
        self.didObtainPermission = UserDefaults.standard.bool(forKey: DevicePermissionHistoryKeys.obtainedPermission.rawValue)
    }
    
    public func tryRequestLocationUse() {
        self.locationManager.requestWhenInUseAuthorization()
        self.didRequestPermission = true
        self.beginLocationUpdates()
    }
    
    public func beginLocationUpdates() {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
    }
}

extension DeviceLocationProvider: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.didObtainPermission = true
        } else if CLLocationManager.authorizationStatus() == .denied {
            self.didObtainPermission = false
            if let callback = self.lastKnownLocationCallback {
                let errorInfo = [NSLocalizedDescriptionKey:"Location permission not available."]
                let error = NSError(domain: "LocationProvider",
                                    code: 1000,
                                    userInfo: errorInfo)
                callback(nil, error)
                self.lastKnownLocationCallback = nil
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else {
            print("Received location manager update, but no location.")
            return
        }
        
        let coordinate = location.coordinate
        self.lastKnownLocation = coordinate
        
        if let callback = self.lastKnownLocationCallback {
            callback(coordinate, nil)
            self.lastKnownLocationCallback = nil
        }
    }
}
