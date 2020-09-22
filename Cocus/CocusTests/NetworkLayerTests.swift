//
//  NetworkLayerTests.swift
//  CocusTests
//
//  Created by Amir Daliri on 19.09.2020.
//  Copyright © 2020 Cocus. All rights reserved.
//

import XCTest
@testable import Cocus

class NetworkLayerTests: XCTestCase {

    var sut: TripPlannerViewModel!
    var fakeNetworkLayerRequest: FakeNetworkLayerRequest!
    
    override func setUpWithError() throws {
        sut = TripPlannerViewModel(networkLayer: FakeNetworkLayerRequest())
        fakeNetworkLayerRequest = FakeNetworkLayerRequest()
        sut.viewDidLoad()
    }

    override func tearDownWithError() throws {
        sut = nil
        fakeNetworkLayerRequest = nil
    }

    func testOutputAttributes() {
        XCTAssertEqual(sut.title, "Cheap Flights")
    }
    
}
