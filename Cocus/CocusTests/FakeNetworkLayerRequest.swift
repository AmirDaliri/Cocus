//
//  FakeNetworkLayerRequest.swift
//  CocusTests
//
//  Created by Amir Daliri on 19.09.2020.
//  Copyright © 2020 Cocus. All rights reserved.
//

import Foundation
@testable import Cocus

class FakeNetworkLayerRequest: NetworkLayerProtocol {
    
    var connections = [Connection]()
    var places = [Country]()
    
    init() {
        let firstFromWay = Country(name: "Los Angeles", coordinate: Coordinate(lat: 40.73061, long: -73.935242))
        let firstToWay = Country(name: "London", coordinate: Coordinate(lat: 51.5285582, long: -0.241681))
        let firstConnection = Connection(from: firstFromWay, to: firstToWay, price: 600)
        connections.append(firstConnection)
        places.append(firstFromWay)
        places.append(firstToWay)
        let secondFromWay = Country(name: "Sydney", coordinate: Coordinate(lat: -33.865143, long: 151.2099))
        let secondToWay = Country(name: "Cape Town", coordinate: Coordinate(lat: -33.918861, long: 18.4233))
        let secondConnection = Connection(from: secondFromWay, to: secondToWay, price: 50)
        connections.append(secondConnection)
        places.append(secondToWay)
    }
    
    func getOnlineConnections(completionHandler: @escaping (([Connection], [Country])?, String?) -> ()) {
        completionHandler((connections, places), nil)
    }
    
    func getLocalConnection(completionHandler: (([Connection], [Country])?, String?) -> ()) {
        completionHandler((connections, places), nil)
    }
}
