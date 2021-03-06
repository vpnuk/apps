//
//  ServersProvider.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

protocol ServerProvider {
    func getServer() throws -> ServerEntity?
    var serverChangedListener: ((_ newServer: ServerEntity?) -> ())? { get set }
}
