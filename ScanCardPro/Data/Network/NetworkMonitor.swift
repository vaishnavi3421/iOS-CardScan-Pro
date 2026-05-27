//
//  NetworkMonitor.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation
import Network

protocol NetworkMonitorProtocol: AnyObject {
    var isConnected: Bool { get }
    var connectionType: NetworkMonitor.ConnectionType { get }
    var pathUpdateHandler: ((Bool) -> Void)? { get set }
    func startMonitoring()
    func stopMonitoring()
}

final class NetworkMonitor: NetworkMonitorProtocol {
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    private(set) var isConnected: Bool = false
    private(set) var connectionType: ConnectionType = .unknown
    
    var pathUpdateHandler: ((Bool) -> Void)?
    
    private init() {
        self.monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            let isConnected = path.status == .satisfied
            self.isConnected = isConnected
            self.connectionType = self.getConnectionType(path)
            
            // Dispatch to main queue for UI handlers
            DispatchQueue.main.async {
                self.pathUpdateHandler?(isConnected)
                NotificationCenter.default.post(
                    name: .connectivityChanged,
                    object: nil,
                    userInfo: ["isConnected": isConnected]
                )
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    private func getConnectionType(_ path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else {
            return .unknown
        }
    }
}

// MARK: - Notification Extension
extension NSNotification.Name {
    static let connectivityChanged = NSNotification.Name("com.cardscanpro.connectivityChanged")
}
