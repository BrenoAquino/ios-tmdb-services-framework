//
//  DetailInterfaceSpec.swift
//  
//
//  Created by Breno Aquino on 28/10/20.
//

import Foundation
import XCTest
import Quick
import Nimble

@testable import TMDBServices

class DetailInterfaceSpec: QuickSpec {
    
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
                context("to get movie detail") {
                    it("and returning success") {
                        self.endToEndDetailSuccess()
                    }
                }
            }
        }
    }
}

// MARK: - Tests
extension DetailInterfaceSpec {
    func endToEndDetailSuccess() {
        Mock.shared.isActive = false
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            DetailInterface().detail(id: 345920) { result in
                switch result {
                case .success(let model):
                    expect(model.movie).notTo(beNil())
                    expect(model.keywords).notTo(beNil())
                    expect(model.recommendations).notTo(beNil())
                case .failure(let error):
                    fail(error.localizedDescription)
                }
                done()
            }
        }
    }
}

