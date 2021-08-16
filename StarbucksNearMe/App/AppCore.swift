//
//  AppCore.swift
//  StarbucksNearMe
//
//  Created by Andrew Brandt on 7/27/21.
//

import UIKit

class AppCore {
    
    //Main entry point for app services
    static let assembly = AppCore()
    
    //Handles interaction between user location provider and location search service.  Stores
    //most recent search in memory.
    public var locationDataManager: LocationDataManager {
        get {
            if let manager = self.overrideLocationDataManager {
                return manager
            }
            return self.defaultLocationDataManager
        }
    }
    
    private let defaultLocationDataManager = StarbucksLocationDataManager()
    
    //Provide override to change behavior, like a mock.
    public var overrideLocationDataManager: LocationDataManager?
    
    //Provides the capability to perform a location based search.
    public var locationSearchService: LocationSearchService {
        get {
            if let service = self.overrideLocationSearchService {
                return service
            }
            return self.defaultLocationSearchService
        }
    }
    
    private let defaultLocationSearchService = GoogleMapsService()
    
    //Provide override to change behavior, like a mock.
    public var overrideLocationSearchService: LocationSearchService?
    
    //Provides the capability to request and receive device location data.
    public var locationProvider: LocationProvider {
        get {
            if let provider = self.overrideLocationProvider{
                return provider
            }
            return self.defaultLocationProvider
        }
    }
    
    private let defaultLocationProvider = DeviceLocationProvider()
    
    //Provide override to change behavior, like a mock.
    public var overrideLocationProvider: LocationProvider?
}
