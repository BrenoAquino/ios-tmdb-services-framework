//
//  DiscoverSpec.swift
//  
//
//  Created by Breno Aquino on 27/10/20.
//

import Foundation
import XCTest
import Quick
import Nimble

@testable import TMDBServices

class DiscoverSpec: QuickSpec {
    
    private let config = MovieDBConfig(version: .v3)
    
    override func spec() {
        super.spec()
        
        beforeEach {
            TMDBServices.shared.apiKey = "9fb1244aab053cf93fa00223bef8e80f"
            Mock.shared.bundleId = "brenoaquino.TMDBServicesTests"
            Mock.shared.isActive = true
            Mock.shared.reset()
        }
        
        if Mock.shared.endToEndTests {
            describe("End to end") {
                context("for discover movies") {
                    it("and returning success") {
                        self.endToEndDiscoverSuccess()
                    }
                }
            }
        }
        
        describe("Use mock") {
            context("for discover movies") {
                it("and returning success") {
                    self.mockDiscoverSuccess()
                }

                it("and returning some error") {
                    self.mockDiscoverFailure()
                }

                it("and returning unexpected object") {
                    self.mockDiscoverMapError()
                }

                it("and returning empty result") {
                    self.mockDiscoverEmpty()
                }
            }
        }
    }
}

// MARK: - Tests
extension DiscoverSpec {
    func endToEndDiscoverSuccess() {
        Mock.shared.isActive = false
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            DiscoverNetwork().movies(genre: 28) { result in
                switch result {
                case .success(let model):
                    expect(model.count).to(beGreaterThanOrEqualTo(1))
                case .failure(let error):
                    fail(error.localizedDescription)
                }
                done()
            }
        }
    }
    
    func mockDiscoverSuccess() {
        Mock.shared.add(target: DiscoverAPIs.discoverMovie(config: config, genre: 28), endpoint: DiscoverMock.discoverSuccess)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            DiscoverNetwork().movies(genre: 28) { result in
                switch result {
                case .success(let model):
                    expect(model.count).to(equal(20))
                    expect(model[0].popularity).to(equal(2716.426))
                    expect(model[0].voteCount).to(equal(21))
                    expect(model[0].hasVideo).to(beFalse())
                    expect(model[0].poster).to(equal("/ugZW8ocsrfgI95pnQ7wrmKDxIe.jpg"))
                    expect(model[0].id).to(equal(724989))
                    expect(model[0].adult).to(beFalse())
                    expect(model[0].backdrop).to(equal("/86L8wqGMDbwURPni2t7FQ0nDjsH.jpg"))
                    expect(model[0].originalLanguage).to(equal("en"))
                    expect(model[0].originalTitle).to(equal("Hard Kill"))
                    expect(model[0].genreIDs).to(equal([28, 53]))
                    expect(model[0].title).to(equal("Hard Kill"))
                    expect(model[0].voteAverage).to(equal(4))
                    expect(model[0].releaseDate).to(equal("2020-10-23"))
                    expect(model[0].overview).to(equal("The work of billionaire tech CEO Donovan Chalmers is so valuable that he hires mercenaries to protect it, and a terrorist group kidnaps his daughter just to get it."))
                case .failure(let error):
                    fail(error.localizedDescription)
                }
                done()
            }
        }
    }
    
    func mockDiscoverFailure() {
        Mock.shared.add(target: DiscoverAPIs.discoverMovie(config: config, genre: 28), endpoint: DiscoverMock.discoverGenericError)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            DiscoverNetwork().movies(genre: 28) { result in
                switch result {
                case .success:
                    fail("Not supposed to return any movie")
                case .failure(let error):
                    expect(error.statusCode).to(equal(400))
                    expect(error.errorCode).to(equal(34))
                    expect(error.message).to(equal("The resource you requested could not be found."))
                }
                done()
            }
        }
    }
    
    func mockDiscoverMapError() {
        Mock.shared.add(target: DiscoverAPIs.discoverMovie(config: config, genre: 28), endpoint: DiscoverMock.discoverMapError)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            DiscoverNetwork().movies(genre: 28) { result in
                switch result {
                case .success:
                    fail("Not supposed to return a valid movie")
                case .failure(let error):
                    expect(error.type).to(equal(.encodingError))
                }
                done()
            }
        }
    }
    
    func mockDiscoverEmpty() {
        Mock.shared.add(target: DiscoverAPIs.discoverMovie(config: config, genre: 28), endpoint: DiscoverMock.discoverEmpty)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            DiscoverNetwork().movies(genre: 28) { result in
                switch result {
                case .success(let model):
                    expect(model.count).to(equal(0))
                case .failure(let error):
                    fail(error.localizedDescription)
                }
                done()
            }
        }
    }
}

