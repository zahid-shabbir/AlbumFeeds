//
//  AlbumService.swift
//  MunchON
//
//  Created by Zahid Shabbir on 08/03/2022.
//  Copyright © 2022 Zahid Shabbir. All rights reserved.

import Foundation

enum AlbumService {
    case getAlbums
    case getAlmbumDetail
}

extension AlbumService: WebServiceProtocol {

    var endPoint: String {
        switch self {
        case .getAlbums: return "photos"
        case .getAlmbumDetail: return "Add endpoint of your request"

        }
    }

    internal var method: HTTPMethods {
        switch self {
        case .getAlbums, .getAlmbumDetail: return .get
        }
    }

}
