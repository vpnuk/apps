//
//  OpenVPNConfigurationsProvider.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 24.10.2021.
//  Copyright © 2021 VPNUK. All rights reserved.
//

import Foundation
import TunnelKit

protocol OpenVPNConfigurationProviderProtocol: AnyObject {
    var isConfigurationsLoaded: Bool { get }
    func reloadConfigurations(forceRedownload: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func getUpdatedOpenVPNConfiguration(
        with userSettings: UserVPNConnectionSettings
    ) -> OpenVPN.Configuration?
}

class OpenVPNConfigurationsProvider {
    private var openVPNConfigurationFromFile: OpenVPN.Configuration?
    private var openVPNScrambledConfigurationFromFile: OpenVPN.Configuration?
    
    private let openVPNConfigurationRepository: OpenVPNConfigurationRepositoryProtocol
    private let shouldUseOvpnFile: Bool = true
    
    init(openVPNConfigurationRepository: OpenVPNConfigurationRepositoryProtocol) {
        self.openVPNConfigurationRepository = openVPNConfigurationRepository
    }
}

extension OpenVPNConfigurationsProvider: OpenVPNConfigurationProviderProtocol {
    var isConfigurationsLoaded: Bool { !(shouldUseOvpnFile && openVPNConfigurationFromFile == nil) }
    func getUpdatedOpenVPNConfiguration(
        with userSettings: UserVPNConnectionSettings
    ) -> OpenVPN.Configuration? {
        return buildVPNConfiguration(shouldUseOvpnFile: shouldUseOvpnFile, withUserSettings: userSettings)
    }
    
    func reloadConfigurations(forceRedownload: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        reloadConfiguration(forceRedownload: forceRedownload, completion: completion)
    }
    
    /// Reload not scrambled config
    private func reloadConfiguration(forceRedownload: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        let loadConfig = { [weak self] (url: URL) in
            self?.getOVPNConfiguration(from: url) { result in
                switch result {
                case .success(let config):
                    self?.openVPNConfigurationFromFile = config
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        if openVPNConfigurationRepository.isFileExist && !forceRedownload {
            loadConfig(openVPNConfigurationRepository.fileUrl)
        } else {
            openVPNConfigurationRepository.downloadOVPNConfigurationFile { result in
                switch result {
                case .success(let url):
                    loadConfig(url)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func getOVPNConfiguration(from fileURL: URL, completion: @escaping (Result<OpenVPN.Configuration, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let vpnConfig = try self.parseVPNConfig(from: fileURL)
                DispatchQueue.main.async {
                    completion(.success(vpnConfig))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func buildVPNConfiguration(
        shouldUseOvpnFile: Bool,
        withUserSettings userSettings: UserVPNConnectionSettings
    ) -> OpenVPN.Configuration? {
        if shouldUseOvpnFile {
            guard let openVPNConfigurationFromFile = openVPNConfigurationFromFile else { return nil }
            return getUpdatedVPNConfig(openVPNConfigurationFromFile, withUserSettings: userSettings)
        } else {
            return buildOldVPNConfiguration(using: userSettings)
        }
    }
    
    private func buildOldVPNConfiguration(using config: UserVPNConnectionSettings) -> OpenVPN.Configuration {
        var sessionBuilder = OpenVPN.ConfigurationBuilder()
        
        sessionBuilder.ca = OpenVPNConstants.ca
        sessionBuilder.clientCertificate = OpenVPNConstants.cert
        sessionBuilder.clientKey = OpenVPNConstants.key
        
        sessionBuilder.dnsServers = ["8.8.8.8", "8.8.4.4", "208.67.222.222", "208.67.220.220"]
        let k = OpenVPN.StaticKey(lines: OpenVPNConstants.openVPNStaticKey, direction: .client)
        sessionBuilder.tlsWrap = OpenVPN.TLSWrap(strategy: .auth, key: k!)
        sessionBuilder.cipher = .aes256gcm
        sessionBuilder.digest = .sha1
        sessionBuilder.compressionFraming = .compLZO
        sessionBuilder.renegotiatesAfter = nil
        sessionBuilder.hostname = config.hostname
        sessionBuilder.endpointProtocols = [EndpointProtocol(config.socketType.toOpenVPN(), config.port)]
        sessionBuilder.usesPIAPatches = false
        sessionBuilder.mtu = 1542
        
        return sessionBuilder.build()
    }
    
    private func getUpdatedVPNConfig(
        _ vpnConfig: OpenVPN.Configuration,
        withUserSettings userSettings: UserVPNConnectionSettings
    ) -> OpenVPN.Configuration {
        var builder = vpnConfig.builder()
        
        builder.hostname = userSettings.hostname
        builder.endpointProtocols = [EndpointProtocol(userSettings.socketType.toOpenVPN(), userSettings.port)]
        
        return builder.build()
    }
    
    /// Parses an .ovpn file from an URL.
    private func parseVPNConfig(from url: URL) throws -> OpenVPN.Configuration {
        let file = try OpenVPN.ConfigurationParser.parsed(fromURL: url)
        return file.configuration
    }
}
