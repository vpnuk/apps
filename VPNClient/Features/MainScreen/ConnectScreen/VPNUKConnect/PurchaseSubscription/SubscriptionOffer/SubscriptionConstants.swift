//
//  SubscriptionConstants.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.12.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

enum SubscriptionConstants {
    static let termsDetails: NSAttributedString = {
        let textColor = Style.Color.grayUIColor
        let termsDetailsLabelNumberOfLines = 0
        let attributedLinkTextRange = NSMakeRange(477, 36)
        let attributedMainTextRange = NSMakeRange(0, 477)
        let termsDetails = NSMutableAttributedString(string:"-Your Apple ID account will be charged on the last day of your free trial. \n \n-Your subscription will automatically renew at the end of each billing period unless it is canceled at least 24 hours before the expiry date. \n \n-You can manage and cancel your subscriptions by going to your App Store account settings after purchase. \n \n-Any unused portion of a free trial period, if offered, will be forfeited when you purchase a subscription. \n \n-By subscribing, you agree to the Terms of Service and Privacy Policy.")
        
        let termsDetailsURL = "https://www.vpnuk.net/terms/"
        let attributedString = termsDetails
        let url = URL(string: termsDetailsURL)!
        attributedString.addAttribute(
            .foregroundColor,
            value: textColor,
            range: attributedMainTextRange
        )
        attributedString.setAttributes([.link: url], range: attributedLinkTextRange)
        
        return attributedString
    }()
    
    static let subscriptionAdvantagesModel: PurchaseSubscriptionAdvantagesView.Model = {
        .init(
            title: NSLocalizedString("Why Subscribe?", comment: ""),
            reasons: [
                .init(title: NSLocalizedString("Additional Security", comment: "")),
                .init(title: NSLocalizedString("Complete Privacy", comment: "")),
                .init(title: NSLocalizedString("Fully Encrypted", comment: "")),
                .init(title: NSLocalizedString("Personal IP Address", comment: ""))
            ]
        )
    }()
    
    static let subscriptionsPlansInfo: String = {
        NSLocalizedString(
            """
               There are three types of account at VPNUK. The entry level account is our ‘Shared IP‘ account, which provides users with a randomly assigned ‘dynamic’ IP address and unlimited access to all of our servers located in 22 prime locations. Our most popular account is the ‘Dedicated IP‘ account, providing users with a personal IP, its a totally unique, ‘Static’ IP address. Users also have unlimited access to all of the Shared IP servers with this account. Our 1:1 Dedicated IP account is the same as the regular Dedicated IP account, this account type is an ideal solution for users that require incoming connections.
            """,
            comment: ""
        )
    }()
    
    static let subscriptionsMaxUsersInfo: String = {
        NSLocalizedString(
            """
               Maximum simultaneous VPN connections
            """,
            comment: ""
        )
    }()
    
    static let subscriptionsPeriodsInfo: String = {
        NSLocalizedString(
            """
               Subscription period in months
            """,
            comment: ""
        )
    }()
}
