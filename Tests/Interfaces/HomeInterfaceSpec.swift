//
//  File.swift
//  
//
//  Created by Breno Aquino on 28/10/20.
//

import Foundation
import XCTest
import Quick
import Nimble

@testable import TMDBServices

class HomeInterfaceSpec: QuickSpec {
    
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
                context("to get home") {
                    it("and returning success") {
                        self.endToEndHomeSuccess()
                    }
                }
            }
        }
    }
}

// MARK: - Tests
extension HomeInterfaceSpec {
    func endToEndHomeSuccess() {
        Mock.shared.isActive = false
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            HomeInterface().home { result in
                switch result {
                case .success(let model):
                    expect(model.genres).notTo(beNil())
                    expect(model.upcomings).notTo(beNil())
                    expect(model.moviesByGenre.keys.count).to(beGreaterThanOrEqualTo(1))
                case .failure(let error):
                    fail(error.localizedDescription)
                }
                done()
            }
        }
    }
}

