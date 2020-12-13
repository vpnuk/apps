//
//  MainScreenViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 09.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit
import NetworkExtension

protocol VPNConnectorDelegate: AnyObject {
    typealias ConnectionStatusUpdatedAction = (_ newStatus: NEVPNStatus) -> ()
    var connectPressedAction: Action? { get set }
    var connectionStatusUpdatedAction: ConnectionStatusUpdatedAction? { get set }
    var connectedServerData: ConnectionData? { get }
    func connect(withSettings settings: ConnectionSettings)
    var connectionStatus: NEVPNStatus { get }

}

enum ConnectScreenType: Int {
    case account = 0
    case custom = 1
}

protocol MainScreenViewModelProtocol {
    func viewLoaded()
    func openSettingsTouched()
    func openSupportTouched()
    func connectTypeChanged(type: ConnectScreenType)
}

class MainScreenViewModel: MainScreenViewModelProtocol {
    private let router: MainScreenRouterProtocol
    weak var view: MainScreenViewProtocol?
    private var vpnService: VPNService
    private let serversRepository: ServersRepository
    
    var connectPressedAction: Action?
    var connectionStatusUpdatedAction: ConnectionStatusUpdatedAction?
    
    private var lastConnectScreenType: ConnectScreenType? {
        get {
            let val = UserDefaults.standard.integer(forKey: "lastConnectScreenType")
            return ConnectScreenType(rawValue: val)
        }
        set {
            UserDefaults.standard.set(newValue?.rawValue, forKey: "lastConnectScreenType")
        }
    }
    
    init(router: MainScreenRouterProtocol, vpnService: VPNService, serversRepository: ServersRepository) {
        self.router = router
        self.vpnService = vpnService
        self.serversRepository = serversRepository
    }
    
    func viewLoaded() {
        let lastConnectType = lastConnectScreenType ?? .custom
        connectTypeChanged(type: lastConnectType)
        vpnService.delegate = self
        view?.connectionStatusView.connectButtonAction = { [weak self] in
            self?.connectButtonTouched()
        }
        
        reloadServers()
    }
    
    private func reloadServers() {
        view?.setLoading(true)
        serversRepository.updateServers { [weak self] result in
            guard let self = self else { return }
            self.view?.setLoading(false)
            
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.view?.presentAlert(message: NSLocalizedString("Servers update error.", comment: ""))
            }
        }
    }
    
    func connectTypeChanged(type: ConnectScreenType) {
        switch type {
        case .account:
            router.switchToAccountConnectView(connectorDelegate: self)
        case .custom:
            router.switchToCustomConnectView(connectorDelegate: self)
        }
        lastConnectScreenType = type
        view?.setConnectScreenType(type)
    }
    
    func openSettingsTouched() {
        router.presentSettings()
    }
    
    func openSupportTouched() {
        if let link = URL(string: Constants.supportUrl) {
            UIApplication.shared.open(link)
        }
    }
}

extension MainScreenViewModel: VPNConnectorDelegate {
    var connectionStatus: NEVPNStatus {
        vpnService.status
    }
    
    private func connectButtonTouched() {
        switch vpnService.status {
        case .invalid, .disconnected:
            connectPressedAction?()
        case .connected, .connecting:
            vpnService.connectionClicked()
        default:
            break
        }
    }
    
    var connectedServerData: ConnectionData? {
        return vpnService.currentProtocolConfiguration?.connectionData
    }
    
    func connect(withSettings settings: ConnectionSettings) {
        switch vpnService.status {
        case .invalid, .disconnected:
            vpnService.configure(settings: settings)
            vpnService.connectionClicked()
        case .connected, .connecting:
            vpnService.connectionClicked()
        default:
            break
        }
    }
}

extension ConnectionStatusView.ConnectionDetails {
    init(connectionData: ConnectionData?) {
        guard let connectionData = connectionData else {
            ip = nil
            port = nil
            socketType = nil
            return
        }
        ip = connectionData.serverIP
        port = connectionData.port
        socketType = connectionData.socketType.rawValue
    }
}

extension MainScreenViewModel: VPNServiceDelegate {
    func raised(error: VPNError) {
        switch error {
        case .error(let desc):
            DispatchQueue.main.async {
                self.view?.presentAlert(message: desc)
            }
        }
    }
    
    func statusUpdated(newStatus status: NEVPNStatus) {
        let connectionData = vpnService.currentProtocolConfiguration?.connectionData
        switch status {
        case .connecting:
            view?.connectionStatusView.update(
                with: .init(
                    status: .connecting(details: .init(connectionData: connectionData))
                )
            )
        case .connected:
            view?.connectionStatusView.update(with: .init(status: .connected(details: .init(connectionData: connectionData))))
        case .disconnected:
            view?.connectionStatusView.update(with: .init(status: .disconnected))
        case .disconnecting:
            view?.connectionStatusView.update(with: .init(status: .disconnecting))
        default:
            break
        }
        connectionStatusUpdatedAction?(status)
    }
}

extension MainScreenViewModel {
    enum Constants {
        static let supportUrl: String = SubscriptionConstants.liveHelpUrl
    }
}
