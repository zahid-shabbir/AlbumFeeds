//
//  ServiceManager.swift
//  ZahidDemo.
//
//  Created by Zahid Shabbir on 08/03/2022.
//  Copyright © 2022 Zahid Shabbir. All rights reserved.

import Foundation
import MobileCoreServices
import SystemConfiguration

typealias ParamsType = [String: Any]?
typealias RuquestCompletion<T: Codable> = (T?, _ error: String?) -> Void

/// A Generic Functions to fetch data using URLSession
/// - Parameters:
///   - requestType: an enum of requests i.e `Login`, `auth service` etc
///   - params: a doctionary of params defualt is nil
///   - completion: a completion that returns parsed modal of type codable that's sent and error message of type string
/// - Returns: it returns nothing but through `completion`


func makeRequest<T: Codable>(of requestable: WebServiceProtocol,
                             params: ParamsType = nil, showProgress: Bool = true) async -> T? {

    guard let request =  requestable.getRequest(params: params) else {
        return (nil) // , "Bad Request")
    }

    do {
        let (data, _) =  try await URLSession.shared.data(for: request)
        data.printPretty()
//        let parsedData =  await data.parse()
         let parsedData =  try JSONDecoder().decode(T.self, from: data)
        return parsedData

    } catch let error {
        print(error)
        return (nil)// , "Bad Request")
    }

}
/// Using this function for new routes for new url

extension URL {
    func asyncDownload(completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared
            .dataTask(with: self, completionHandler: completion)
            .resume()
    }
}

extension URLRequest {
    func asyncFetch(completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared
            .dataTask(with: self, completionHandler: completion)
            .resume()
    }
}

public class Reachability {
    class var isConnectedToNetwork: Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
    }
}
