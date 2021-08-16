//
//  DefaultLocationDataManager.swift
//  StarbucksNearMe
//
//  Created by Andrew Brandt on 7/27/21.
//

import Foundation
import CoreLocation

let STARBUCKS_SEARCH_KEYWORD = "Starbucks"

public class StarbucksLocationDataManager: LocationDataManager {
    
    var hasRequestedLocation: Bool = false
    
    var fetchLocationsCoordinate: CLLocationCoordinate2D?
    
    var recentlyFetchedLocations: [Location]? = []
        
    public func fetchNearestLocations(completionBlock: @escaping LocationDataFetchCompletionBlock) {
        let callback: (CLLocationCoordinate2D?,Error?) -> () = { coordinate, callbackError in
            let service = AppCore.assembly.locationSearchService
            if let callbackError = callbackError {
                completionBlock(nil, callbackError)
                return
            }
            
            guard let coordinate = coordinate else {
                let errorInfo = [NSLocalizedDescriptionKey:"Unknown error occurred."]
                let error = NSError(domain: "LocationDataManager",
                                    code: 42,
                                    userInfo: errorInfo)
                completionBlock(nil, error)
                return
            }
            
            service.performSearchRequest(at: coordinate,
                                         keyword: STARBUCKS_SEARCH_KEYWORD,
                                         completionHandler: { response, error in
                                            if let error = error {
                                                print(error)
                                                completionBlock(nil,error)
                                                return
                                            }
                                            
                                            guard let response = response else {
                                                return
                                            }
                                            
                                            self.recentlyFetchedLocations = response
                                            self.fetchLocationsCoordinate = coordinate
                                            
                                            completionBlock(response, nil)
                                         })
        }
        
        var provider = AppCore.assembly.locationProvider
        provider.lastKnownLocationCallback = callback
    }
}
