//
//  WeightedGraphNode.swift
//  Cocus
//
//  Created by Amir Daliri on 19.09.2020.
//  Copyright © 2020 Cocus. All rights reserved.
//

import Foundation
import GameplayKit

class WeightedGraphNode: GKGraphNode {
    let country: Country
    var travelCost: [GKGraphNode: Float] = [:]
    
    init(country: Country) {
        self.country = country
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.country = Country(name: "", coordinate: Coordinate(lat: 0.0, long: 0.0))
        super.init()
    }
    
    override func cost(to node: GKGraphNode) -> Float {
        return travelCost[node] ?? 0
    }
    
    func addConnection(to node: GKGraphNode, bidirectional: Bool = true, weight: Float) {
        self.addConnections(to: [node], bidirectional: bidirectional)
        travelCost[node] = weight
        guard bidirectional else { return }
        (node as? WeightedGraphNode)?.travelCost[self] = weight
    }
}
