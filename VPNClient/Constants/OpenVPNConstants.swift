//
//  OpenVPNConstants.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.10.2019.
//  Copyright © 2019 VPNUK. All rights reserved.
//

import Foundation
import TunnelKit

//"443", at: 0, animated: false)
//    portSegmentedControl.insertSegment(withTitle: "8008", at: 1, animated: false)
//    portSegmentedControl.insertSegment(withTitle: "80", at: 1, animated: false)
//case .udp:
//    portSegmentedControl.removeAllSegments()
//    portSegmentedControl.insertSegment(withTitle: "1194", at: 0, animated: false)
//    portSegmentedControl.insertSegment(withTitle: "55194", at: 1, animated: false)
//    portSegmentedControl.insertSegment(withTitle: "65194"

enum VPNSettings {
    static let socketPorts: [SocketType: [Int]] = {
        var settings = [SocketType: [Int]]()
        settings[.tcp] = [443, 8080, 80]
        settings[.udp] = [1194, 55194, 65194]
        return settings
    }()
    
    static let settingsChangedNotification: NSNotification.Name = NSNotification.Name(rawValue: "settingsChangedNotification")
    
    static let defaultSettings: (port: Int, socketType: SocketType) = (port: 1194, socketType: .udp)
}

enum OpenVPNConstants {
    static let keychainUsernameKey = "keychainUsernameKey"
    static let keychainPasswordKey = "keychainPasswordKey"
    
    static let appGroup = "group.info.vpnuk.VPNClient"
    static let tunnelIdentifier = "info.vpnuk.VPNClient.VPNClientNetworkExtension"
    
    
    static let openVPNStaticKey: [Substring] = [
        "-----BEGIN OpenVPN Static key V1-----",
        "62c8f2b6f4268d6459296c9685d825d9",
    "bb9bf5d82cd557e9126823a24b1dcf4e",
    "2ccdff7ec9f5c15690fd329c283c5e07",
    "c2ac67a9ec2e3a7ce9aa36826379a30a",
    "6b66514d06022ca45b07f420de756876",
    "64861990c50a200b3a2a00cfce9749dc",
    "d83711164f8a9effc9f694a81ed4df87",
    "0baf064e36b5feeadc30116de4380a06",
    "2e7242dd890796d03264b667d551601c",
    "5650ecf0ebebe7f398c4f854afbe0487",
    "8878a99582a8c8d68a2cc25ba6b7d695",
    "fe0c999cfa25cd75eb31e4e2c7796383",
    "6990d8d5abd4bb346f1e5b70202dbe45",
    "15d9e09c66d9d372a51cea3928d3638a",
    "7c39bdcb3a26d49f20efd502dd1c8b79",
    "467d953fcdfc302fa6dd3c52a49c3b20",
    "-----END OpenVPN Static key V1-----"
    ]
    
    
    static let ca = OpenVPN.CryptoContainer(pem: """
    -----BEGIN CERTIFICATE-----
    MIIEPDCCAySgAwIBAgIJAPY5WT7EiG4qMA0GCSqGSIb3DQEBBQUAMHExCzAJBgNV
    BAYTAkdCMQswCQYDVQQIEwJHQjEPMA0GA1UEBxMGTG9uZG9uMQ4wDAYDVQQKEwVW
    UE5VSzERMA8GA1UEAxMIVlBOVUsgQ0ExITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRA
    dnBudWsuaW5mbzAeFw0xOTA1MjQxOTUzNDZaFw0zOTA1MTkxOTUzNDZaMHExCzAJ
    BgNVBAYTAkdCMQswCQYDVQQIEwJHQjEPMA0GA1UEBxMGTG9uZG9uMQ4wDAYDVQQK
    EwVWUE5VSzERMA8GA1UEAxMIVlBOVUsgQ0ExITAfBgkqhkiG9w0BCQEWEnN1cHBv
    cnRAdnBudWsuaW5mbzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANAs
    5xF68mTOo5X2TQ09OGKClNC/5HbPimI+vQha37GhMdj1Vy6LBIbcVSa1UL52H109
    ZBnwV56pGbKki2nPh/Fb9eT8pgL/jJ/PvXc5KaTUknJK1A3G7KNpJk2DjO6i0dR/
    jHWxgnDfU445qJXAlsc4vHgO3YaPJbPscZxuA2hDdtEUYh2ecr5nomEaMUEcAaIF
    62wDMc3XsRK3wBQP4CQJ8hWEFINTEYpPenfGeFXeHAezE7N2tO35acvcuxWJHuGK
    qfXTBOzv+utjK7J67Q4pSybXm/gkiHQ/Uf6/+SiH3FandwW46WVR55K3p/aKQa/3
    jgRjwJt/EpCj7UdvFxcCAwEAAaOB1jCB0zAdBgNVHQ4EFgQUDSvNBosUkM9cRUG/
    HnKYzWJDlWQwgaMGA1UdIwSBmzCBmIAUDSvNBosUkM9cRUG/HnKYzWJDlWShdaRz
    MHExCzAJBgNVBAYTAkdCMQswCQYDVQQIEwJHQjEPMA0GA1UEBxMGTG9uZG9uMQ4w
    DAYDVQQKEwVWUE5VSzERMA8GA1UEAxMIVlBOVUsgQ0ExITAfBgkqhkiG9w0BCQEW
    EnN1cHBvcnRAdnBudWsuaW5mb4IJAPY5WT7EiG4qMAwGA1UdEwQFMAMBAf8wDQYJ
    KoZIhvcNAQEFBQADggEBAIoXulOhqxaXWWP22tpYgp9h2YesQwjK0JqG1KMBevdw
    /B7ZXZgiXXrftKM6LNCvIYY1Uoqk055yGhiwbg5b1FuyqihqsD/cygmyghvM+CMQ
    ycS4GvuUGRyWfDzdFUTCh6tawoIez0V33PdJIXDwrVG3nsEVyhdR0x1xXEntlVHo
    r23mmYT0A37E3ZHx5fbNkPIQUBGK5s+AiVkIo4rd93LLeNS2vMIjXJVrl9yq52IC
    q1cP6wYX9asYIRM2LRtF4hIpQLXMHMOfqI8489l3VlcrvbGlzmw4xd58lOH09E0T
    TtAfVmDj60a4oFEl3HYiIFtCibEb5jyAnpcpfpExmYs=
    -----END CERTIFICATE-----
    """)

    static let cert = OpenVPN.CryptoContainer(pem: """
    -----BEGIN CERTIFICATE-----
    MIIEljCCA36gAwIBAgIBAjANBgkqhkiG9w0BAQUFADBxMQswCQYDVQQGEwJHQjEL
    MAkGA1UECBMCR0IxDzANBgNVBAcTBkxvbmRvbjEOMAwGA1UEChMFVlBOVUsxETAP
    BgNVBAMTCFZQTlVLIENBMSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QHZwbnVrLmlu
    Zm8wHhcNMTkwNTI0MTk1NDEzWhcNMzkwNTE5MTk1NDEzWjCBgjELMAkGA1UEBhMC
    R0IxCzAJBgNVBAgTAkdCMQ8wDQYDVQQHEwZMb25kb24xDjAMBgNVBAoTBVZQTlVL
    MSIwIAYDVQQDExl2cG51ay1vcGVudnBuLWNsaWVudC0yMDE5MSEwHwYJKoZIhvcN
    AQkBFhJzdXBwb3J0QHZwbnVrLmluZm8wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
    ggEKAoIBAQDIyBHGOV8DXCmLax6CfUiBRiXg00yr/WNEyBZvlgiNw/wE/PNB65qN
    1vBbM5VpLelwlQ0SzWFLe0cuiulbR/IK747Q2IPezjwxhaUFEKX7cUNXowqHAW2U
    WJIOr06+Eq9JPThIvurRvNbcxdQJpc0FDLACAGqctNWXfhowPLb2gtLnzUK9OJ6r
    F/FztjNIpr4VMKLgXC2EDiomzqNwGrds59kkHwq2X6/ocq5erd9rrrZUthy3TiIh
    QZc6cSlmQUOxv13KY2EgZ+7vSx4xZQS47+y9XK2eNg9jLNpIEuGNA8oot8H0Tmdj
    OS5rwK0p/JokAYD9AqxtP3KJYE6xMP2TAgMBAAGjggElMIIBITAJBgNVHRMEAjAA
    MC0GCWCGSAGG+EIBDQQgFh5FYXN5LVJTQSBHZW5lcmF0ZWQgQ2VydGlmaWNhdGUw
    HQYDVR0OBBYEFGpyTGZ+3AKIdetkx5bZTLg53a1BMIGjBgNVHSMEgZswgZiAFA0r
    zQaLFJDPXEVBvx5ymM1iQ5VkoXWkczBxMQswCQYDVQQGEwJHQjELMAkGA1UECBMC
    R0IxDzANBgNVBAcTBkxvbmRvbjEOMAwGA1UEChMFVlBOVUsxETAPBgNVBAMTCFZQ
    TlVLIENBMSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QHZwbnVrLmluZm+CCQD2OVk+
    xIhuKjATBgNVHSUEDDAKBggrBgEFBQcDAjALBgNVHQ8EBAMCB4AwDQYJKoZIhvcN
    AQEFBQADggEBABweVNpZ6pVKPFZ6fhAwR/6olVTGPEWPAwg1v8wW2BtLjiGbFhKO
    ao+mjCIDef+xhYVxsrusTmA5YIWn5c+kD/Bn4yjCIvDSVVYyMNTdl3H5sNkmKkgM
    3UngmtC8OqPtKMf7D7r7sQkGYhhMGqRUz5szCBi+jz7p0k9mAHmszTJc554G2mkT
    pBmDcs3U0foN3vx9PzmPSlLuROJ4nYY67JvPSoQlPbnr0VLAsEO6g2EgDLS5cYbV
    yEcxE7Twc69plzZL2cI2VXmxUFG2I41vzwbV69smZNH63O0Ja2g0YqP7uD4JnEaP
    jPrBO16E4elIjSnYTRAoqUt7fbd2wXKcZrM=
    -----END CERTIFICATE-----
    """)

    static let key = OpenVPN.CryptoContainer(pem: """
    -----BEGIN PRIVATE KEY-----
    MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDIyBHGOV8DXCmL
    ax6CfUiBRiXg00yr/WNEyBZvlgiNw/wE/PNB65qN1vBbM5VpLelwlQ0SzWFLe0cu
    iulbR/IK747Q2IPezjwxhaUFEKX7cUNXowqHAW2UWJIOr06+Eq9JPThIvurRvNbc
    xdQJpc0FDLACAGqctNWXfhowPLb2gtLnzUK9OJ6rF/FztjNIpr4VMKLgXC2EDiom
    zqNwGrds59kkHwq2X6/ocq5erd9rrrZUthy3TiIhQZc6cSlmQUOxv13KY2EgZ+7v
    Sx4xZQS47+y9XK2eNg9jLNpIEuGNA8oot8H0TmdjOS5rwK0p/JokAYD9AqxtP3KJ
    YE6xMP2TAgMBAAECggEBALEJB/MafxZ9WvxddUdlpFqoOZnldgNopvDs5Ct7xQsL
    NdpIF02Wqm5KiSBBeYqGOwFTy3U6toFRr8/wGBaud1MBK5ImdxAsFJMt3fV7Wn88
    vT42un+T2MUm25IrLWkXHIudeVVbUb2hnmqH3JCtKvs61q7NIzQNlw++1uSVhFYS
    L6K8Scvv5to0kuVR4in4wNCk/ElX0cpSPjQ7y1nhOpUPt7EVdhUNGZ2ldlYBMVQb
    EdtCjL5XMqAtfu3FNEDq13hqQhNyJe0OCCJCrRfDpxmaYaTuKB6euvumpxHkvmJM
    8l8r5avfS1MOPecrUWcQk6ZLnX927fq+Ktu/A/xMcbECgYEA8nMU6PEg5ZfJvp/g
    DVSzOPnDXK4ACy60l7UF8rCHWaivUNe7VqSByzX62SmcrvtB7FkHws6DynvY08pk
    5c9c2niifQGt7+1p56ZrCFsugdjkRI11+sEDmHawPlgzpIJPABXh06aHwih8ZXGY
    bokLrTEhgExtnlhsRSgGtOZtGicCgYEA1ADPcDQxgwAreGGSKCIZsgXF8ZjqydYZ
    MyZrHm5go56gFodk0IthV2qtZvPN7w2s5vInisUTK2jW/4N8nLttWpAIiF5d4Pvm
    NzMjMib63CnanB0VM54//LHOhy8ONJ6zz84/P89+uKQI71X/V9NbLwifE1O3PYwc
    NJfJwV12gLUCgYBVzfjGgCAeYVvbBQXscd+D+JD1ifcl/f+X+U8Dlwov5w001UTN
    4ya0XoRKuvlizDWGifO/NAtca/xO6EBRPNQl1a/cAe4nDaT/gNw8dti8x5/xywbI
    GetF2CuDxP9x51RCOXxUxYkiY+WymUNTS1lAkDTFDUd2VODskL/e4fYW3QKBgAFh
    m/hkLqpm1uGq6RPf3QD+7qI7V9RG09U0e+Av4etO/kYHTc3aCqFSLZ0NG5tiIG1E
    yKMr04sl3Li/d5Fh2z2K0LNqwfvUSFS1vZX3EQ1cLHN18QxsDIit8+WHlfUbz5oc
    Aud8h5vWXcSJb+d3lhGBYd/zXK9G+WwSTRs4a6w9AoGBAIecsglAS0QjC5xuuPyJ
    Zj45GM6iw/VAO72xinKmmLjS/cN1gOEaq95ZNxx2GBoqW2QLjBZTmdFpmENHWzd0
    Ya03V03ze50JxsdFIAQcc2lyevppby6Gn3pq3IMBDpOn36UFEWVTR3T79XKio5tL
    eujc3PcmLtKkNtvLBQtF022R
    -----END PRIVATE KEY-----
    """)
}
