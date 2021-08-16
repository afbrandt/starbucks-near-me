//
//  StarbucksLocation.swift
//  StarbucksNearMe
//
//  Created by Andrew Brandt on 7/27/21.
//

import Foundation
import CoreLocation

//Simple representation of a location.  Decodable using Google Maps API response data.
public struct Location: Decodable {
    let latitude: Double
    let longitude: Double
    
    let approximateAddress: String
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: self.latitude,
                                          longitude: self.longitude)
        }
    }
    
    enum LocationCodingKey: String, CodingKey {
        case approximateAddress = "vicinity"
        case coordinate = "geometry"
    }
    
    enum GeometryCodingKey: String, CodingKey {
        case location
    }
    
    enum CoordinateCodingKey:String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: LocationCodingKey.self)
        
        self.approximateAddress = try container.decode(String.self,
                                                       forKey: LocationCodingKey.approximateAddress)
        
        let geometryContainer = try container.nestedContainer(keyedBy: GeometryCodingKey.self,
                                                            forKey: LocationCodingKey.coordinate)
        
        let locationContainer = try geometryContainer.nestedContainer(keyedBy: CoordinateCodingKey.self,
                                                                      forKey: GeometryCodingKey.location)
        
        self.latitude = try locationContainer.decode(Double.self, forKey: CoordinateCodingKey.latitude)
        self.longitude = try locationContainer.decode(Double.self, forKey: CoordinateCodingKey.longitude)
    }
    
    func distance(from otherLocation: CLLocation) -> CLLocationDistance {
        let selfLocation = CLLocation(latitude: self.latitude,
                                  longitude: self.longitude)
        return selfLocation.distance(from: otherLocation)
    }
}
