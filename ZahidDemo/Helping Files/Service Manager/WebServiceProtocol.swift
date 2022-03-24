//
//  Requestable.swift
//  ZahidDemo.
//
//  Created by Zahid Shabbir on 08/03/2022.
//  Copyright © 2022 Zahid Shabbir. All rights reserved.

import Foundation

protocol WebServiceProtocol {
    var baseURl: String { get }
    var endPoint: String { get }
    var requestUrl: String { get }
    var method: HTTPMethods { get }
    var token: String {get}
//    var responseType: Codable {get}

}
struct DefaultStruct: Codable {}
extension WebServiceProtocol {

    var baseURl: String {
        return "https://jsonplaceholder.typicode.com/"
    }

    internal var requestUrl: String {
        var finalEndPoint = self.baseURl  + self.endPoint
        finalEndPoint = finalEndPoint.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        return finalEndPoint

    }

    /**
     -
     - if specifies token if needed then we'll specifically pass that token
     -
     */
    var token: String { return "JWT token" }

    /// Use this method to prepare a `Request` passed in `func makeRequest`
    /// - Parameter params:  takes dictionary of type  --> **[String: Any]**
    /// - Returns: `URLRequest`
    public func getRequest(params: ParamsType? = nil ) -> URLRequest? {

        guard let url = URL(string: self.requestUrl) else {return nil}

        var request        = URLRequest(url: url as URL)

        request.httpMethod = self.method.rawValue

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(self.token, forHTTPHeaderField: "Authorization")

        guard let param = params, let jsonData = param?.jsonDataRepresentation  else {
            return request
        }

        request.httpBody = jsonData

        return request
    }
}

public struct HTTPMethods: RawRepresentable, Equatable, Hashable {
    /// `CONNECT` method.
    public static let connect = HTTPMethods(rawValue: "CONNECT")
    /// `DELETE` method.
    public static let delete = HTTPMethods(rawValue: "DELETE")
    /// `GET` method.
    public static let get = HTTPMethods(rawValue: "GET")
    /// `HEAD` method.
    public static let head = HTTPMethods(rawValue: "HEAD")
    /// `OPTIONS` method.
    public static let options = HTTPMethods(rawValue: "OPTIONS")
    /// `PATCH` method.
    public static let patch = HTTPMethods(rawValue: "PATCH")
    /// `POST` method.
    public static let post = HTTPMethods(rawValue: "POST")
    /// `PUT` method.
    public static let put = HTTPMethods(rawValue: "PUT")
    /// `TRACE` method.
    public static let trace = HTTPMethods(rawValue: "TRACE")
    public let rawValue: String
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
