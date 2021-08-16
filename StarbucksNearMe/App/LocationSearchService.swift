//
//  LocationSearchService.swift
//  StarbucksNearMe
//
//  Created by Andrew Brandt on 7/27/21.
//

import CoreLocation

public typealias LocationSearchCompletionHandler = ([Location]?,Error?)->()

//Interface for making network request to fetch location data.
public protocol LocationSearchService {

    //Forms and sends a network request to fetch nearby location data.  Keyword can refine
    //search to particular locations (i.e. Starbucks).
    func performSearchRequest(at coordinate:CLLocationCoordinate2D,
                              keyword:String?,
                              completionHandler: @escaping LocationSearchCompletionHandler)
}
