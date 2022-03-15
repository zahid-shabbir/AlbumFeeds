//
//  ZahidDemoTests.swift
//  ZahidDemoTests
//
//  Created by Zahid Shabbir on 21/01/2021.
//
@testable import ZahidDemo
import XCTest
    class ZahidDemoTests: XCTestCase {
    func test_base_url_is_valid() {
        XCTAssertEqual(Constants.Apis.albumUrl, "https://jsonplaceholder.typicode.com/photos")
    }
    func test_cell_identifier_name_changed() {
        XCTAssertEqual(Constants.Cells.albumCellIdentifier, "AlbumTableViewCell")
    }
}
