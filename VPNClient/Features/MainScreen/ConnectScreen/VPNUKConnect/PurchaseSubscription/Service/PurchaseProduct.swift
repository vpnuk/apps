//
//  PurchaseProduct.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 02.08.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

enum PurchaseProduct: String, CaseIterable {
    case oneToOneDedicatedIp1Month1User = "68152"
    case dedicatedIp1Month2User = "6633"
    case sharedIp1Month1User = "59160"
}

extension PurchaseProduct {
    static var availableProducts: [PurchaseProduct] {
        return [
            .oneToOneDedicatedIp1Month1User,
            .dedicatedIp1Month2User,
            .sharedIp1Month1User
        ]
    }
    
    var productId: String { rawValue }
    
    var localizedTitle: String {
        switch self {
        case .oneToOneDedicatedIp1Month1User:
            return NSLocalizedString("1:1 Dedicated IP. 1 Month. 1 User", comment: "")
        case .dedicatedIp1Month2User:
            return NSLocalizedString("Dedicated IP. 1 Month. 2 Users", comment: "")
        case .sharedIp1Month1User:
            return NSLocalizedString("Shared IP. 1 Month. 1 User", comment: "")
        }
    }
    
    var localizeDescription: String {
        switch self {
        case .oneToOneDedicatedIp1Month1User:
            return NSLocalizedString("Your own unique 1:1 IP (UK only)", comment: "")
        case .dedicatedIp1Month2User:
            return NSLocalizedString("Your own unique IP", comment: "")
        case .sharedIp1Month1User:
            return NSLocalizedString("Large choice of server. Dynamic IP", comment: "")
        }
    }
    
    var data: Data {
        switch self {
        case .oneToOneDedicatedIp1Month1User:
            return .init(periodMonths: 1, maxUsers: 1, type: .oneToOne)
        case .dedicatedIp1Month2User:
            return .init(periodMonths: 1, maxUsers: 2, type: .dedicated)
        case .sharedIp1Month1User:
            return .init(periodMonths: 1, maxUsers: 1, type: .shared)
        }
    }
    
    struct Data {
        let periodMonths: Int
        let maxUsers: Int
        let type: SubscriptionType
    }
}

extension SubscriptionType {
    var localizedTitle: String {
          switch self {
          case .oneToOne:
              return NSLocalizedString("1:1 Dedicated IP", comment: "")
          case .dedicated:
              return NSLocalizedString("Dedicated IP", comment: "")
          case .shared:
              return NSLocalizedString("Shared IP", comment: "")
          }
      }
      
      var localizeDescription: String {
          switch self {
          case .oneToOne:
              return NSLocalizedString("Your unique server IP (UK only)", comment: "")
          case .dedicated:
              return NSLocalizedString("Your unique personal IP", comment: "")
          case .shared:
              return NSLocalizedString("Randomly assigned dynamic IP", comment: "")
          }
      }
}
