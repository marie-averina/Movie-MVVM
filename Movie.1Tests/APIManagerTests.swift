//
//  APIManagerTests.swift
//  Movie.1Tests
//
//  Created by Мария Аверина on 06.09.2022.
//

import XCTest
@testable import Movie_1

class APIManagerTests: XCTestCase {

    var sut: APIManagerProtocol?
    
    override func setUp() {
        super.setUp()
        sut = APIManager()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testFetchMoviesList() {

        // Given A apiservice
        let sut = self.sut!

        // When fetch popular movie
        let expect = XCTestExpectation(description: "callback")
        
        sut.getFilms { movies in
            expect.fulfill()
            
        }
        sut.getFilms { movies in
            expect.fulfill()
            XCTAssertEqual(movies.count, 21)
            for movie in movies {
                XCTAssertNotNil(movie.id)
            }
        }
    }

}

