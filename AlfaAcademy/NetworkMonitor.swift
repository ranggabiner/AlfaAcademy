//
//  NetworkMonitor.swift
//  AlfaAcademy
//
//  Created by Rangga Biner on 16/01/25.
//

import Network

protocol NetworkMonitorDelegate: AnyObject {
    func networkStatusDidChange(isConnected: Bool)
}

class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor: NWPathMonitor
    private(set) var isConnected: Bool = true
    weak var delegate: NetworkMonitorDelegate?
    
    private init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            self?.isConnected = isConnected
            DispatchQueue.main.async {
                self?.delegate?.networkStatusDidChange(isConnected: isConnected)
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
