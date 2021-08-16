//
//  StarbucksNearMeTests.swift
//  StarbucksNearMeTests
//
//  Created by Andrew Brandt on 7/26/21.
//

import XCTest
import CoreLocation
@testable import StarbucksNearMe

class StarbucksNearMeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMapService() {
        let service = AppCore.assembly.locationSearchService
        
        let coordinate = CLLocationCoordinate2D(latitude: 42.48069147117667,
                                                longitude: -70.91056806973266)
        let keyword = "Starbucks"
        
        let expectation = XCTestExpectation(description: "Search API should be successful.")
        
        service.performSearchRequest(at: coordinate,
                                     keyword: keyword) { locations, error in
            if locations != nil {
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testDataManagerWithMock() {
        let mock = MockLocationProvider()
        
        AppCore.assembly.overrideLocationProvider = mock
        
        let manager = AppCore.assembly.locationDataManager
        
        let expectation = XCTestExpectation(description: "Manager should be able to fetch with mock location.")

        manager.fetchNearestLocations { locations, error in
            if let locations = locations, locations.count > 0 {
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 1000)
    }
    
    func testJsonParsing() {
        let bundle = Bundle(for: Self.self)
        let validPath = bundle.path(forResource: "ValidSample", ofType: "json")!
        let validUrl = URL(fileURLWithPath: validPath)
        let validData = try! Data(contentsOf: validUrl)
        
        let locationList = try! JSONDecoder().decode(LocationList.self, from: validData)
        XCTAssert(locationList.locations.count == 20)
        
        let invalidPath = bundle.path(forResource: "InvalidSample", ofType: "json")!
        let invalidUrl = URL(fileURLWithPath: invalidPath)
        let invalidData = try! Data(contentsOf: invalidUrl)
        
        let emptyList = try? JSONDecoder().decode(LocationList.self, from: invalidData)
        XCTAssertNil(emptyList)
    }
}
