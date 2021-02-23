//
//  CredentialsProviderProtocol.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

protocol VPNCredentialsProvider {
    func getStoredCredentials() throws -> UsernamePasswordCredentials?
    var credentialsChangedListener: ((_ newCredentials: UsernamePasswordCredentials) -> ())? { get set }
}

