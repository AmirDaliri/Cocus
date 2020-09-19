//
//  NetworkLayer.swift
//  Cocus
//
//  Created by Amir Daliri on 19.09.2020.
//  Copyright © 2020 Cocus. All rights reserved.
//

import Foundation

class NetworkLayer: NetworkLayerProtocol {
    
    private let baseURL = "https://raw.githubusercontent.com/TuiMobilityHub/ios-code-challenge/master/connections.json"

    func getOnlineConnections(completionHandler: @escaping ([Connection]?,_ errString: String?)->()) {
        guard let url = URL(string: baseURL) else {
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
    
    func getLocalConnection(completionHandler: ([Connection]?,_ errString: String?)->()) {
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
    
    private func parsConnectionDictionary(dict: [[String: Any]]) -> [Connection] {
        var connections = [Connection]()
        
        for connection in dict {
            guard let coordinates = connection["coordinates"] as? [String: Any],
                   let from = coordinates["from"] as? [String: Any],
                   let to = coordinates["to"] as? [String: Any] else{
                       continue
               }
            let fromObject = Coordinate(lat: from["lat"] as! Double, long: from["long"] as! Double)
            let toObject = Coordinate(lat: to["lat"] as! Double, long: to["long"] as! Double)
            let way = Way(from: fromObject, to: toObject)
            let connection = Connection(coordinates: way, to: connection["to"] as! String, price: connection["price"] as! Int, from: connection["from"] as! String)
            
            connections.append(connection)
        }
        return connections
    }
    
}
