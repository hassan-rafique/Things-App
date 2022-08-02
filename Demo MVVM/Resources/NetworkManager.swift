//
//  NetworkManager.swift
//  Vyzmo
//
//  Created by MacPro on 7/25/20.
//  Copyright © 2020 RoyalTech. All rights reserved.
//

import Network
import Alamofire

protocol NetworkManagerDelegate {
    func networkConnectionStatusChnaged()
}

final class NetworkManager: NSObject {
    static let sharedInstance = NetworkManager()
    
    private let monitor:NWPathMonitor
    private let queue = DispatchQueue.global()
    public private(set) var isConnected:Bool = false
    public private(set) var connectionType:ConnectionType = .unknown
    
    var delegate:NetworkManagerDelegate?

    enum ConnectionType {
        case wifi
        case celluler
        case ethernet
        case unknown
    }
    
    private override init() {
        monitor = NWPathMonitor()
    }
    
    private func getConnectionType(_ path:NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .celluler
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.getConnectionType(path)
            self?.delegate?.networkConnectionStatusChnaged()
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
}


// MARK: WEB APIS REQUEST
extension NetworkManager {
    
    func sendGetRequest(url: String, headers: HTTPHeaders, completion: @escaping (AFDataResponse<Data>) -> Void) {
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData(completionHandler: { response in
                completion(response)
            })
        }
    
    
    func sendPostRequest(url: String, parameters: Parameters, headers: HTTPHeaders, completion: @escaping (AFDataResponse<Data>) -> Void) {
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData(completionHandler: { response in
                completion(response)
            })
    }
    
}
