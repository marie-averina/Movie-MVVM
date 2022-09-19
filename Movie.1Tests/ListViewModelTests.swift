//
//  ListViewModelTests.swift
//  Movie.1Tests
//
//  Created by Мария Аверина on 06.09.2022.
//

import XCTest
@testable import Movie_1

class ListViewModelTests: XCTestCase {

    var sut: ListViewModel?
    var mockAPIManager: MockAPIManager!
    
    override func setUp() {
        super.setUp()
        mockAPIManager = MockAPIManager()
        sut = ListViewModel(apiManager: mockAPIManager)
    }
    
//    func testFetchMoviesList() {
//        mockAPIManager.moviesList = [Result]()
//        sut.fetchMovieList()
//        XCTAssert(mockAPIManager!.isGetMoviesList)
//    }
    
    func testFetchMovies() {
        let expect = XCTestExpectation(description: "callback")
        sut?.fetchMovieList(complettion: { movies in
            expect.fulfill()
            
            XCTAssertNotEqual(movies.value?.count, 0)
            for movie in movies.value ?? [] {
                XCTAssertNotNil(movie.id)
            }
        })
        wait(for: [expect], timeout: 1)
    }
    
}

//class MockAPIManager: APIManagerProtocol {
//
//    var isGetMoviesList = false
//    var isGetFilmById = false
//    var moviesList: [Result] = [Result]()
//    var movie = MovieDetailsModel(posterPath: "")
//    var getFilmsClosure: (([Result]) -> Void)!
//    var getFilmByIdClosure: ((MovieDetailsModel) -> Void)!
//
//    func getFilms(completionHandler: @escaping ([Result]) -> Void) {
//        isGetMoviesList = true
//        getFilmsClosure = completionHandler
//    }
//
//    func getFilmById(id: String, completionHandler: @escaping (MovieDetailsModel) -> Void) {
//        isGetFilmById = true
//        getFilmByIdClosure = completionHandler
//    }
//
//    func fetchMovieListSuccess() {
//        isGetMoviesList = true
//        getFilmsClosure(moviesList)
//    }
//
//    func fetchMovieDetailsSuccess() {
//        isGetFilmById = true
//        getFilmByIdClosure(movie)
//    }
//
//}
