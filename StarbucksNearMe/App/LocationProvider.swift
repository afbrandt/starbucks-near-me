//
//  LocationDataProvider.swift
//  StarbucksNearMe
//
//  Created by Andrew Brandt on 7/27/21.
//

import CoreLocation

//Interface for providing location data.
public protocol LocationProvider {
    
    //Indicates if user gave permission to obtain location data.
    var hasLocationPermission: Bool { get }
    
    //Indicates if application has asked for permission to get location data.
    var didRequestPermission: Bool { get }
    
    //Indicates if application has previously been given permission.
    var didObtainPermission: Bool { get }
            
    //Callback that is used during location updates.  Callback is used once on
    //successful update then dropped.  Error given when permission error occurs
    var lastKnownLocationCallback: ((CLLocationCoordinate2D?,Error?) -> ())? { set get }
    
    //Attempt to ask for location permission.
    func tryRequestLocationUse()
    
    //Start observing for location updates.
    func beginLocationUpdates()
}
