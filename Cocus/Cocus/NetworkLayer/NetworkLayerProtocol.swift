//
//  NetworkLayerProtocol.swift
//  Cocus
//
//  Created by Amir Daliri on 19.09.2020.
//  Copyright © 2020 Cocus. All rights reserved.
//

import Foundation

protocol NetworkLayerProtocol {
    func getLocalConnection(completionHandler: ([Connection]?,_ errorMessage: String?)->())
    func getOnlineConnections(completionHandler: @escaping ([Connection]?,_ errorMessage: String?)->())
}
