//
//  NetworkLayer.swift
//  Cocus
//
//  Created by Amir Daliri on 19.09.2020.
//  Copyright © 2020 Cocus. All rights reserved.
//

import Foundation

class NetworkLayer: NetworkLayerProtocol {
    
    private let baseURL = "https://raw.githubusercontent.com/TuiMobilityHub/ios-code-challenge/master/"
    private let connectionUri = "connections.json"

    func getOnlineConnections(completionHandler: @escaping (([Connection],[Country])?,_ errString: String?)->()) {
        guard let url = URL(string: "\(baseURL)\(connectionUri)") else {
            completionHandler(nil, "request url is not valid")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let responseData = data else {
                completionHandler(nil, "response data is null")
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]  else {
                    completionHandler(nil, "response json is null")
                    return
                }
                guard let results = json["connections"] as? [[String: Any]] else {
                    completionHandler(nil, "can't find any dictionary with 'connections' name")
                    return
                }
                completionHandler(self.parsConnectionDictionary(dict: results), nil)
            } catch let error {
                completionHandler(nil, error.localizedDescription)
            }
        }.resume()
        
    }
    
    func getLocalConnection(completionHandler: (([Connection],[Country])?,_ errString: String?)->()) {
        guard let path = Bundle.main.path(forResource: "connections", ofType: "json") else {
            completionHandler(nil, "can't find any file with 'connections.json' name")
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]  else {
                completionHandler(nil, "Faild to map data")
                return
            }
            guard let results = json["connections"] as? [[String: Any]] else {
                completionHandler(nil, "can't find any dictionary with 'connections' name")
                return
            }
            completionHandler(self.parsConnectionDictionary(dict: results), nil)
        } catch {
            completionHandler(nil, "Faild to map data")
        }
    }
    
    private func parsConnectionDictionary(dict: [[String: Any]]) -> ([Connection], [Country]) {
        
        var connections = [Connection]()
        var countries = [Country]()

        for connection in dict {
            guard let coordinates = connection["coordinates"] as? [String: Any],
                let from = coordinates["from"] as? [String: Any],
                let to = coordinates["to"] as? [String: Any] else{
                    continue
            }
            
            let fromObject = Coordinate(lat: from["lat"] as! Double, long: from["long"] as! Double)
            let toObject = Coordinate(lat: to["lat"] as! Double, long: to["long"] as! Double)
            let fromCountry = Country(name: connection["from"] as! String, coordinate: fromObject)
            let toCountry = Country(name: connection["to"] as! String, coordinate: toObject)            
            let connection = Connection(from: fromCountry, to: toCountry, price: connection["price"] as! Int)
            
            if !countries.contains(fromCountry) {
                countries.append(fromCountry)
            }
            
            if !countries.contains(toCountry) {
                countries.append(toCountry)
            }
            connections.append(connection)
        }
        return (connections, countries)
    }
    
}
