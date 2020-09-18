//
//  DataModelTests.swift
//  CocusTests
//
//  Created by Amir Daliri on 18.09.2020.
//  Copyright © 2020 Cocus. All rights reserved.
//

import XCTest
@testable import Cocus

class DataModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testDataModelParsedCorrectly() {
        let from = Coordinate(lat: -33.865143, long: 151.2099)
        let to = Coordinate(lat: -33.918861, long: 18.4233)
        let way = Way(from: from, to: to)
        let connection = Connections(coordinates: way, to: "Cape Town", price: 200, from: "Sydney")
        XCTAssertEqual(connection.coordinates.from.lat, -33.865143)
        XCTAssertEqual(connection.coordinates.from.long, 151.2099)
        XCTAssertEqual(connection.coordinates.to.lat, -33.918861)
        XCTAssertEqual(connection.coordinates.to.long, 18.4233)
        XCTAssertEqual(connection.price, 200)
        XCTAssertEqual(connection.to, "Cape Town")
    }
}
