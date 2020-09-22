//
//  TripPlannerViewModel.swift
//  Cocus
//
//  Created by Amir Daliri on 17.09.2020.
//  Copyright © 2020 Cocus. All rights reserved.
//

import Foundation
import GameplayKit

class TripPlannerViewModel {
    
    var networkLayer: NetworkLayerProtocol!
    
    var errorMessage:(String)->() = { _ in }
    var viewDidLoad: () -> () = { }
    var title = ""
    
    // MARK: - Private Params
    private let graph = GKGraph()
    private var itemList = [WeightedGraphNode]()
    var firstAutoCompleteComponent: AutoCompleteComponent!
    var secondAutoCompleteComponent: AutoCompleteComponent!
    private var connectionsDataModel: [Connection]! {
        didSet {
            configureOutput()
        }
    }
    private var countryDataModel: [Country]!{
        didSet {
            configureOutput()
        }
    }

    // MARK: - Initial
    init(networkLayer: NetworkLayerProtocol) {
        self.networkLayer = networkLayer
        viewDidLoad = { [weak self] in
            self?.getOnlineData()
        }
    }
    
    // MARK: - API Method
    private func getOnlineData() {
        networkLayer.getOnlineConnections{ [weak self] (data, errorMessage) in
            guard let connections = data?.0, let countries = data?.1 else {
                self?.errorMessage(errorMessage!)
                self?.insertLocalData()
                return
            }
            self?.connectionsDataModel = connections
            self?.countryDataModel = countries
            self?.fillGraph()
        }
    }
    
    // MARK: - Local Data Method
    private func insertLocalData() {
        let data = getLocalData()
        self.connectionsDataModel = data.0
        self.countryDataModel = data.1
        self.fillGraph()
    }
    
    private func getLocalData() -> ([Connection], [Country]) {
        var connections = [Connection]()
        var countries = [Country]()
        networkLayer.getLocalConnection{ [weak self] (data, errorMessage) in
            guard let connectionList = data?.0, let countryList = data?.1 else {
                self?.errorMessage(errorMessage!)
                return
            }
            connections = connectionList
            countries = countryList
        }
        return (connections, countries)
    }
    
    // MARK: - Validation Method
    private func fillGraph() {
        for country in countryDataModel {
            let item = WeightedGraphNode(country: country)
            itemList.append(item)
        }
        graph.add(itemList)
        for connection in connectionsDataModel {
            guard let originNode = itemList.first(where: { $0.country == connection.from}),
                let destinationNode = itemList.first(where: { $0.country == connection.to }) else {
                    continue
            }
            originNode.addConnection(to: destinationNode, bidirectional: true, weight: Float(connection.price))
        }
    }
    
    private func configureOutput() {
        title = "Cheap Flights"
    }
    
    func findCountries(from text: String) -> Country? {
        return countryDataModel.first(where: { $0.name == text })
    }
    
    func findConnection(origin: String, destination: String) -> Connection? {
        let fromCountry = countryDataModel.first(where: { $0.name == origin })
        let toCountry = countryDataModel.first(where: { $0.name == destination })
        return connectionsDataModel.first(where: { $0.from == fromCountry && $0.to == toCountry ||
            $0.from == toCountry && $0.to == fromCountry
        })
    }
    
    func findPath(from: Country, to: Country) -> ([Connection], Int?) {
        guard let originNode = itemList.first(where: { $0.country == from}),
            let destinationNode = itemList.first(where: { $0.country == to }) else {
                return ([], nil)
        }
        let path = graph.findPath(from: originNode, to: destinationNode)
        let cost = getCost(for: path)
        
        var connections = [Connection]()
        for i in 0..<(path.count-1) {
            let origin = itemList.first(where: { $0 == path[i] })
            let destination = itemList.first(where: { $0 == path[i+1] })
            if let connection = connectionsDataModel.first(where: {
                $0.from == origin?.country && $0.to == destination?.country ||
                    $0.from == destination?.country && $0.to == origin?.country })
            {
                connections.append(connection)
            }
        }
        return (connections, cost)
    }
    
    private func getCost(for path: [GKGraphNode]) -> Int {
        var total: Float = 0
        for i in 0..<(path.count-1) {
            total += path[i].cost(to: path[i+1])
        }
        return Int(total)
    }
        
    // MARK: - AutoCompletion
    func getAllCountryForAutocomplete() -> [String] {
        var possibilities = [String]()
        for country in getLocalData().1 {
            possibilities.append(country.name)
        }
        return possibilities
    }
     
}
