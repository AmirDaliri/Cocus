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

    func testDataModelParsedCorrectly() {
        let from = Country(name: "Sydney", coordinate: Coordinate(lat: -33.865143, long: 151.2099))
        let to = Country(name: "Cape Town", coordinate: Coordinate(lat: -33.918861, long: 18.4233))
        let connection = Connection(from: from, to: to, price: 200)
        XCTAssertEqual(connection.from.coordinate.lat, -33.865143)
        XCTAssertEqual(connection.from.coordinate.long, 151.2099)
        XCTAssertEqual(connection.to.coordinate.lat, -33.918861)
        XCTAssertEqual(connection.to.coordinate.long, 18.4233)
        XCTAssertEqual(connection.price, 200)
        XCTAssertEqual(connection.to.name, "Cape Town")
    }
}
