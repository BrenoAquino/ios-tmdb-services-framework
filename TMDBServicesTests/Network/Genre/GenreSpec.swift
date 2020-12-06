//
//  GenreSpec.swift
//  
//
//  Created by Breno Aquino on 28/10/20.
//

import Foundation
import XCTest
import Quick
import Nimble

@testable import TMDBServices

class GenreSpec: QuickSpec {
    
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
                context("to get all genres") {
                    it("and returning success") {
                        self.endToEndGenresSuccess()
                    }
                }
            }
        }
        
        describe("Use mock") {
            context("to get all genres") {
                it("and returning success") {
                    self.mockGenresSuccess()
                }

                it("and returning some error") {
                    self.mockGenresFailure()
                }

                it("and returning unexpected object") {
                    self.mockGenresMapError()
                }

                it("and returning empty result") {
                    self.mockGenresEmpty()
                }
            }
        }
    }
}

// MARK: - Tests
extension GenreSpec {
    func endToEndGenresSuccess() {
        Mock.shared.isActive = false
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            GenreNetwork().genres { result in
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
    
    func mockGenresSuccess() {
        Mock.shared.add(target: GenreAPIs.genres(config: config), endpoint: GenreMock.genresSuccess)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            GenreNetwork().genres { result in
                switch result {
                case .success(let model):
                    expect(model.count).to(equal(19))
                    expect(model[0].id).to(equal(28))
                    expect(model[0].name).to(equal("Action"))
                case .failure(let error):
                    fail(error.localizedDescription)
                }
                done()
            }
        }
    }
    
    func mockGenresFailure() {
        Mock.shared.add(target: GenreAPIs.genres(config: config), endpoint: GenreMock.genresGenericError)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            GenreNetwork().genres { result in
                switch result {
                case .success:
                    fail("Not supposed to return any genres")
                case .failure(let error):
                    expect(error.statusCode).to(equal(400))
                    expect(error.errorCode).to(equal(34))
                    expect(error.message).to(equal("The resource you requested could not be found."))
                }
                done()
            }
        }
    }
    
    func mockGenresMapError() {
        Mock.shared.add(target: GenreAPIs.genres(config: config), endpoint: GenreMock.genresMapError)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            GenreNetwork().genres { result in
                switch result {
                case .success:
                    fail("Not supposed to return a valid genres")
                case .failure(let error):
                    expect(error.type).to(equal(.encodingError))
                }
                done()
            }
        }
    }
    
    func mockGenresEmpty() {
        Mock.shared.add(target: GenreAPIs.genres(config: config), endpoint: GenreMock.genresEmpty)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            GenreNetwork().genres { result in
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

