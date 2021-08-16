//
//  LocationList.swift
//  StarbucksNearMe
//
//  Created by Andrew Brandt on 7/27/21.
//

import Foundation

//Model to decode complete response of Google Maps API.
struct LocationList: Decodable {
    
    enum LocationListCodingKey: String, CodingKey {
        case locations = "results"
    }
    
    let locations: [Location]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: LocationListCodingKey.self)
        self.locations = try container.decode([Location].self, forKey: LocationListCodingKey.locations)
    }
}
