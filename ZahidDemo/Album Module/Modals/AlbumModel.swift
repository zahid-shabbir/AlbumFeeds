//
//  AlbumResponseModel.swift
//  ZahidDemo
//
//  Created by Zahid Shabbir on 27/02/2021.
//
    import Foundation
public struct AlbumModel: Codable {
	let albumId: Int
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
public struct Item {
    var name: String
    var detail: String
    public init(name: String, detail: String) {
        self.name = name
        self.detail = detail
    }
}
public struct AlbumSectionModel {
    var id: Int
    var items: [AlbumModel]
    var collapsed: Bool
    public init(name: Int, items: [AlbumModel], collapsed: Bool = false) {
        self.id = name
        self.items = items
        self.collapsed = collapsed
    }
}
