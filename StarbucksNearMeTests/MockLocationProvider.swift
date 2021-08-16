//
//  MockLocationProvider.swift
//  StarbucksNearMeTests
//
//  Created by Andrew Brandt on 7/28/21.
//

import Foundation
import CoreLocation
@testable import StarbucksNearMe

class MockLocationProvider: LocationProvider {
    var didObtainPermission: Bool = true
    
    var hasLocationPermission: Bool = true
    
    var didRequestPermission: Bool = true
    
    var lastKnownLocationCallback: ((CLLocationCoordinate2D?,Error?) -> ())? {
        didSet {
            DispatchQueue.main.async {
                let coordinate = CLLocationCoordinate2D(latitude: 42.48069147117667,
                                                        longitude: -70.91056806973266)
                self.lastKnownLocationCallback?(coordinate, nil)
            }
        }
    }
    
    func tryRequestLocationUse() {
        //No op
    }
    
    func beginLocationUpdates() {
        //No op
    }
    
    
}
