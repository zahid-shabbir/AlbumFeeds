//
//  ViewModal.swift
//  ZahidDemo
//
//  Created by Zahid Shabbir on 27/02/2021.
//
import Foundation
class UserViewModal {
    /// Use this mesthod to fetch album from server
    /// - Parameters:
    ///   - url: url string of your request
    ///   - completion: on completion it'll return `[AlbumModel]`
    @available(iOS 15.0.0, *)
    func getAlbums() async -> [AlbumSectionModel] {

        let albums: [AlbumModel]?  = await makeRequest(of: AlbumService.getAlbums)
        return  self.prepareDataSource(albums: albums ?? [])
        
    }

    func getAlbums(completion: @escaping ([AlbumSectionModel]) -> Void ) {
        makeRequest(of: AlbumService.getAlbums) { (albums: [AlbumModel]?, _) in
            let final = self.prepareDataSource(albums: albums ?? [])
            completion(final)
        }
    }

    /// It prepare our `[AlbumModel]` to `[AlbumSectionModel]`
    /// - Parameters:
    ///   - albums: it is an `AlbumModel` to process it to `[AlbumSectionModel]`
    ///   - completion:Returns `[AlbumSectionModel]` where each `AlbumSectionModel`contains `items of [AlbumModel]`
    func prepareDataSource(albums: [AlbumModel]) -> [AlbumSectionModel] {
        var sections: [AlbumSectionModel] = []
        let uniqueSections = Set(albums.map { $0.albumId })
        for section in uniqueSections {
            sections.append(AlbumSectionModel(name: section, items: albums.filter {$0.albumId == section}) )
        }
        sections = sections.sorted { $0.id < $1.id }
        return sections
    }

    /// It prepare our `[AlbumModel]` to `[AlbumSectionModel]`
    /// - Parameters:
    ///   - albums: it is an `AlbumModel` to process it to `[AlbumSectionModel]`
    ///   - completion:Returns `[AlbumSectionModel]` where each `AlbumSectionModel`contains `items of [AlbumModel]`
    func prepareDataSource(albums: [AlbumModel], completion: @escaping ([AlbumSectionModel]) -> Void ) {
        var sections: [AlbumSectionModel] = []
        let uniqueSections = Set(albums.map { $0.albumId })
        for section in uniqueSections {
            sections.append(AlbumSectionModel(name: section, items: albums.filter {$0.albumId == section}) )
        }
        sections = sections.sorted { $0.id < $1.id }
        completion(sections)
    }

    /// Use this function to search through the album id
    /// - Parameters:
    ///   - searchText: it should be album id that is required to look up
    ///   - albums: it's datasource of `[AlbumSectionModel]`to filter and return matched results
    ///   - completion: returns `[AlbumSectionModel]` to show albums against particular album id
    func searchInAlbum(_ searchText: String, albums: [AlbumSectionModel], completion: ([AlbumSectionModel]) -> Void ) {
        guard let albumId = Int(searchText) else {
            completion([])
            return
        }
        completion(albums.filter {$0.id == albumId})
    }
}
