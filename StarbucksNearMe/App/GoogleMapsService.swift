//
//  GoogleMapsService.swift
//  StarbucksNearMe
//
//  Created by Andrew Brandt on 7/26/21.
//

import CoreLocation
import Foundation

#warning("Add your API key")
let API_KEY = "YOUR-API-KEY-HERE"

let HOST_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"

let RANK_BY_VALUE = "distance"

fileprivate enum ServiceParameterKeys: String {
    case key = "key"
    case location = "location"
    case keyword = "keyword"
    case rankby = "rankby"
}

class GoogleMapsService: LocationSearchService {
    
    func performSearchRequest(at coordinate:CLLocationCoordinate2D,
                              keyword:String? = nil,
                              completionHandler: @escaping LocationSearchCompletionHandler)
    {
        var parameters = [ServiceParameterKeys:String]()
        
        parameters[.key] = API_KEY
        parameters[.location] = coordinate.toString()
        parameters[.rankby] = RANK_BY_VALUE
        
        if let k = keyword {
            parameters[.keyword] = k
        }
        
        let mappedParams = parameters.map { return "\($0)=\($1)" }
        let formedParamString = mappedParams.joined(separator: "&")
        
        guard let encodedParamString =
                formedParamString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            let errorInfo = [NSLocalizedDescriptionKey:"Request encoding error occurred."]
            let error = NSError(domain: "GoogleMapsService",
                                code: 4240,
                                userInfo: errorInfo)
            completionHandler(nil,error)
            return
        }
        
        let formedUrlString = HOST_URL+"?"+encodedParamString
        
        guard let url = URL(string: formedUrlString) else {
            let errorInfo = [NSLocalizedDescriptionKey:"Error forming URL."]
            let error = NSError(domain: "GoogleMapsService",
                                code: 4241,
                                userInfo: errorInfo)
            completionHandler(nil,error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            
            guard let data = data else {
                //No error, but no data
                let errorInfo = [NSLocalizedDescriptionKey:"Received empty response."]
                let error = NSError(domain: "GoogleMapsService",
                                    code: 4242,
                                    userInfo: errorInfo)
                completionHandler(nil,error)
                return
            }
            
            let locations: [Location]
            
            do {
                let results = try JSONDecoder().decode(LocationList.self, from: data)
                locations = results.locations
            } catch let e {
                completionHandler(nil, e)
                return
            }
            
            completionHandler(locations,nil)
        }
        
        task.resume()
    }
}
