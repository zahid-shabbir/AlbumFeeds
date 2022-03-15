//
//  AlbumResponseModel.swift
//  ZahidDemo
//
//  Created by Zahid Shabbir on 19/01/2021.
//

import Foundation
struct AlbumModel: Codable {
	let albumId: Int?
	let id: Int?
	let title: String?
	let url: String?
	let thumbnailUrl: String?

	enum CodingKeys: String, CodingKey {
        case albumId = "albumId"
		case id = "id"
		case title = "title"
		case url = "url"
		case thumbnailUrl = "thumbnailUrl"
	}

}
