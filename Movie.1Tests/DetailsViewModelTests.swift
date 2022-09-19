//
//  DetailsViewModelTests.swift
//  Movie.1Tests
//
//  Created by Мария Аверина on 10.09.2022.
//

import XCTest
@testable import Movie_1


class DetailsViewModelTests: XCTestCase {

    
    var sut: DetailsViewModel!
    var mockAPIManager: MockAPIManager!
    
    override func setUp() {
        super.setUp()
        mockAPIManager = MockAPIManager()
        sut = DetailsViewModel(apiManager: mockAPIManager)
    }
    
    func testMovieDetails() {
        
        let expect = XCTestExpectation(description: "movieDetailsCallBack")
        sut.initFetchProcess(id: "620873") { movie in
            expect.fulfill()
            XCTAssertNotEqual(movie.value?.title, "")
        }
        wait(for: [expect], timeout: 1)
    }


}

