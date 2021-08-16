//
//  LocationManager.swift
//  StarbucksNearMe
//
//  Created by Andrew Brandt on 7/26/21.
//

import CoreLocation

public typealias LocationDataFetchCompletionBlock = ([Location]?,Error?) -> ()

//Interface for a data manager that stores and updates location data.
protocol LocationDataManager {
    
    //Collection of locations obtained since the last search
    var recentlyFetchedLocations: [Location]? { get }
    
    //Device location that was used in last search
    var fetchLocationsCoordinate: CLLocationCoordinate2D? { get }
    
    //Retrieves the latest device location and fetches new location data.
    func fetchNearestLocations(completionBlock: @escaping LocationDataFetchCompletionBlock)
}
