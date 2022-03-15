//
//  ServiceManager.swift
//  ZahidDemo
//
//  Created by Zahid Shabbir on 27/02/2021.
    import MobileCoreServices
import Foundation
import SystemConfiguration
// MARK: - :::  Generic Web Serviuce Manager Work :::
/// This method will be fetch data from server
/// - Parameters:
///   - serviceUrl: url for the request
///   - completionHandler: a completion handler will return -> JSON Respone or Error
func makeGenericRequest<T: Decodable> (serviceUrl: String, completionHandler : @escaping (T?, Error?) -> Void) {
    guard let url = URL(string: serviceUrl) else { return }
    URLSession.shared.dataTask(with: url) { result in
        switch result {
        case .success(let data):
                    do {
                let response = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(response, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
                case .failure(let error):
            DispatchQueue.main.async {
                completionHandler(nil, error)
            }
        }
    }.resume()
}
public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `CONNECT` method.
    public static let connect = HTTPMethod(rawValue: "CONNECT")
    /// `DELETE` method.
    public static let delete = HTTPMethod(rawValue: "DELETE")
    /// `GET` method.
    public static let get = HTTPMethod(rawValue: "GET")
    /// `HEAD` method.
    public static let head = HTTPMethod(rawValue: "HEAD")
    /// `OPTIONS` method.
    public static let options = HTTPMethod(rawValue: "OPTIONS")
    /// `PATCH` method.
    public static let patch = HTTPMethod(rawValue: "PATCH")
    /// `POST` method.
    public static let post = HTTPMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put = HTTPMethod(rawValue: "PUT")
    /// `TRACE` method.
    public static let trace = HTTPMethod(rawValue: "TRACE")
    public let rawValue: String
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
    enum Result<Success, Failure> where Failure: Error {
    case success(Success)
    case failure(Failure)
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
