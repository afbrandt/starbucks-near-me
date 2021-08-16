//
//  CLLocation2DCoordinate+String.swift
//  StarbucksNearMe
//
//  Created by Andrew Brandt on 7/27/21.
//

import CoreLocation

extension CLLocationCoordinate2D {
    
    // Convenience function to convert coordinate to string
    public func toString() -> String {
        return "\(self.latitude),\(self.longitude)"
    }
}
