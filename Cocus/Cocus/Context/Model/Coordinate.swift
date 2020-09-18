//
//  Coordinate.swift
//  Cocus
//
//  Created by Amir Daliri on 18.09.2020.
//  Copyright © 2020 Cocus. All rights reserved.
//

import Foundation
import CoreLocation

struct Coordinate: Equatable {
    
    let lat: Double
    let long: Double
    
    func locationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
