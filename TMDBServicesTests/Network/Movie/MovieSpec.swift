//
//  MovieSpec.swift
//  
//
//  Created by Breno Aquino on 28/10/20.
//

import Foundation
import XCTest
import Quick
import Nimble

@testable import TMDBServices

class MovieSpec: QuickSpec {
    
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
                context("to get upcoming movies") {
                    it("and returning success") {
                        self.endToEndUpcomingSuccess()
                    }
                }
                context("to get movie detail") {
                    it("and returning success") {
                        self.endToEndDetailSuccess()
                    }
                }
                context("to get movie keywords") {
                    it("and returning success") {
                        self.endToEndKeywordsSuccess()
                    }
                }
                context("to get movie recommendations") {
                    it("and returning success") {
                        self.endToEndRecommendationsSuccess()
                    }
                }
            }
        }
        
        describe("Use mock") {
            context("to get upcoming movies") {
                it("and returning success") {
                    self.mockUpcomingSuccess()
                }
                it("and returning some error") {
                    self.mockUpcomingFailure()
                }
                it("and returning unexpected object") {
                    self.mockUpcomingMapError()
                }
                it("and returning empty result") {
                    self.mockUpcomingEmpty()
                }
            }
            context("to get movie detail") {
                it("and returning success") {
                    self.mockDetailSuccess()
                }
                it("and returning some error") {
                    self.mockDetailFailure()
                }
                it("and returning unexpected object") {
                    self.mockDetailMapError()
                }
            }
            context("to get movie keywords") {
                it("and returning success") {
                    self.mockKeywordsSuccess()
                }
                it("and returning some error") {
                    self.mockKeywordsFailure()
                }
                it("and returning unexpected object") {
                    self.mockKeywordsMapError()
                }
                it("and returning empty result") {
                    self.mockKeywordsEmpty()
                }
            }
            context("to get movie recommendations") {
                it("and returning success") {
                    self.mockRecommendationsSuccess()
                }
                it("and returning some error") {
                    self.mockRecommendationsFailure()
                }
                it("and returning unexpected object") {
                    self.mockRecommendationsMapError()
                }
                it("and returning empty result") {
                    self.mockRecommendationsEmpty()
                }
            }
        }
    }
}

// MARK: - Tests
extension MovieSpec {
    // MARK: Hitting Internet
    func endToEndUpcomingSuccess() {
        Mock.shared.isActive = false
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            MovieNetwork().upcoming { result in
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
    
    func endToEndDetailSuccess() {
        Mock.shared.isActive = false
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            MovieNetwork().detail(id: 345920) { result in
                switch result {
                case .success(let model):
                    expect(model.id).to(equal(345920))
                    expect(model.originalTitle).to(equal("Collateral Beauty"))
                case .failure(let error):
                    fail(error.localizedDescription)
                }
                done()
            }
        }
    }
    
    func endToEndKeywordsSuccess() {
        Mock.shared.isActive = false
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            MovieNetwork().keywords(id: 345920) { result in
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
    
    func endToEndRecommendationsSuccess() {
        Mock.shared.isActive = false
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            MovieNetwork().recommendations(id: 345920) { result in
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
    
    // MARK: Mock
    // Upcoming
    func mockUpcomingSuccess() {
        Mock.shared.add(target: MovieAPIs.upcoming(config: config), endpoint: MovieMock.upcomingSuccess)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            MovieNetwork().upcoming { result in
                switch result {
                case .success(let model):
                    expect(model.count).to(equal(20))
                    expect(model[0].popularity).to(equal(1447.764))
                    expect(model[0].voteCount).to(equal(18))
                    expect(model[0].hasVideo).to(beFalse())
                    expect(model[0].poster).to(equal("/m9cn5mhW519QKr1YGpGxNWi98VJ.jpg"))
                    expect(model[0].id).to(equal(635302))
                    expect(model[0].adult).to(beFalse())
                    expect(model[0].backdrop).to(equal("/xoqr4dMbRJnzuhsWDF3XNHQwJ9x.jpg"))
                    expect(model[0].originalLanguage).to(equal("ja"))
                    expect(model[0].originalTitle).to(equal("劇場版「鬼滅の刃」無限列車編"))
                    expect(model[0].genreIDs).to(equal([28, 12, 16, 18, 14, 36]))
                    expect(model[0].title).to(equal("劇場版「鬼滅の刃」無限列車編"))
                    expect(model[0].voteAverage).to(equal(7.5))
                    expect(model[0].releaseDate).to(equal("2020-10-16"))
                    expect(model[0].overview).to(equal(""))
                case .failure(let error):
                    fail(error.localizedDescription)
                }
                done()
            }
        }
    }
    
    func mockUpcomingFailure() {
        Mock.shared.add(target: MovieAPIs.upcoming(config: config), endpoint: MovieMock.upcomingGenericError)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            MovieNetwork().upcoming { result in
                switch result {
                case .success:
                    fail("Not supposed to return any upcoming movie")
                case .failure(let error):
                    expect(error.statusCode).to(equal(400))
                    expect(error.errorCode).to(equal(34))
                    expect(error.message).to(equal("The resource you requested could not be found."))
                }
                done()
            }
        }
    }
    
    func mockUpcomingMapError() {
        Mock.shared.add(target: MovieAPIs.upcoming(config: config), endpoint: MovieMock.upcomingMapError)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            MovieNetwork().upcoming { result in
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
    
    func mockUpcomingEmpty() {
        Mock.shared.add(target: MovieAPIs.upcoming(config: config), endpoint: MovieMock.upcomingEmpty)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            MovieNetwork().upcoming { result in
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
    
    // Detail
    func mockDetailSuccess() {
        Mock.shared.add(target: MovieAPIs.detail(id: 345920, config: config), endpoint: MovieMock.detailSuccess)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            MovieNetwork().detail(id: 345920) { result in
                switch result {
                case .success(let model):
                    expect(model.popularity).to(equal(13.694))
                    expect(model.voteCount).to(equal(4301))
                    expect(model.hasVideo).to(beFalse())
                    expect(model.poster).to(equal("/l7rwGxhH2ZDaViuxzT0qMPfhfo3.jpg"))
                    expect(model.id).to(equal(345920))
                    expect(model.adult).to(beFalse())
                    expect(model.backdrop).to(equal("/svkdWRdho4tfTXUSEvCTBmD8y60.jpg"))
                    expect(model.originalLanguage).to(equal("en"))
                    expect(model.originalTitle).to(equal("Collateral Beauty"))
                    expect(model.genres?.count).to(equal(2))
                    expect(model.genreIDs).to(beNil())
                    expect(model.title).to(equal("Beleza Oculta"))
                    expect(model.voteAverage).to(equal(7.3))
                    expect(model.releaseDate).to(equal("2016-12-06"))
                    expect(model.overview).to(equal("Howard entra em depressão após uma tragédia pessoal e passa a escrever cartas para a Morte, o Tempo e o Amor, algo que preocupa seus amigos. Mas o que parece impossível, se torna realidade quando essas três partes do universo decidem responder. Morte, Tempo e Amor vão tentar ensinar o valor da vida para Howard."))
                    expect(model.budget).to(equal(36000000))
                    expect(model.homepage).to(equal("http://collateralbeauty-movie.com/"))
                    expect(model.imdbId).to(equal("tt4682786"))
                    expect(model.revenue).to(equal(88528280))
                    expect(model.runtime).to(equal(97))
                    expect(model.status).to(equal("Released"))
                    expect(model.tagline).to(equal("Estamos Todos Conectados"))
                    expect(model.productionCompanies?.count).to(equal(6))
                    expect(model.productionCompanies?[0].id).to(equal(79))
                    expect(model.productionCompanies?[0].logo).to(equal("/tpFpsqbleCzEE2p5EgvUq6ozfCA.png"))
                    expect(model.productionCompanies?[0].name).to(equal("Village Roadshow Pictures"))
                    expect(model.productionCompanies?[0].originCountry).to(equal("US"))
                case .failure(let error):
                    fail(error.localizedDescription)
                }
                done()
            }
        }
    }
    
    func mockDetailFailure() {
        Mock.shared.add(target: MovieAPIs.detail(id: 345920, config: config), endpoint: MovieMock.detailGenericError)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            MovieNetwork().detail(id: 345920) { result in
                switch result {
                case .success:
                    fail("Not supposed to return any movie detail")
                case .failure(let error):
                    expect(error.statusCode).to(equal(400))
                    expect(error.errorCode).to(equal(34))
                    expect(error.message).to(equal("The resource you requested could not be found."))
                }
                done()
            }
        }
    }
    
    func mockDetailMapError() {
        Mock.shared.add(target: MovieAPIs.detail(id: 345920, config: config), endpoint: MovieMock.detailMapError)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            MovieNetwork().detail(id: 345920) { result in
                switch result {
                case .success:
                    fail("Not supposed to return a valid movie detail")
                case .failure(let error):
                    expect(error.type).to(equal(.encodingError))
                }
                done()
            }
        }
    }
    
    // Keywords
    func mockKeywordsSuccess() {
        Mock.shared.add(target: MovieAPIs.keywords(id: 345920, config: config), endpoint: MovieMock.keywordsSuccess)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            MovieNetwork().keywords(id: 345920) { result in
                switch result {
                case .success(let model):
                    expect(model.count).to(equal(6))
                    expect(model[0].id).to(equal(2300))
                    expect(model[0].name).to(equal("despair"))
                case .failure(let error):
                    fail(error.localizedDescription)
                }
                done()
            }
        }
    }
    
    func mockKeywordsFailure() {
        Mock.shared.add(target: MovieAPIs.keywords(id: 345920, config: config), endpoint: MovieMock.keywordsGenericError)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            MovieNetwork().keywords(id: 345920) { result in
                switch result {
                case .success:
                    fail("Not supposed to return any keyword")
                case .failure(let error):
                    expect(error.statusCode).to(equal(400))
                    expect(error.errorCode).to(equal(34))
                    expect(error.message).to(equal("The resource you requested could not be found."))
                }
                done()
            }
        }
    }
    
    func mockKeywordsMapError() {
        Mock.shared.add(target: MovieAPIs.keywords(id: 345920, config: config), endpoint: MovieMock.keywordsMapError)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            MovieNetwork().keywords(id: 345920) { result in
                switch result {
                case .success:
                    fail("Not supposed to return a valid keyword")
                case .failure(let error):
                    expect(error.type).to(equal(.encodingError))
                }
                done()
            }
        }
    }
    
    func mockKeywordsEmpty() {
        Mock.shared.add(target: MovieAPIs.keywords(id: 345920, config: config), endpoint: MovieMock.keywordsEmpty)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            MovieNetwork().keywords(id: 345920) { result in
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
    
    // Recommendations
    func mockRecommendationsSuccess() {
        Mock.shared.add(target: MovieAPIs.recommendations(id: 345920, config: config), endpoint: MovieMock.recommendationsSuccess)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            MovieNetwork().recommendations(id: 345920) { result in
                switch result {
                case .success(let model):
                    expect(model.count).to(equal(20))
                    expect(model[0].popularity).to(equal(22.151))
                    expect(model[0].voteCount).to(equal(3373))
                    expect(model[0].hasVideo).to(beFalse())
                    expect(model[0].poster).to(equal("/57FDGagZiTxJdj56605UJM9cY4D.jpg"))
                    expect(model[0].id).to(equal(369885))
                    expect(model[0].adult).to(beFalse())
                    expect(model[0].backdrop).to(equal("/Acyjn5ITzMKX7o9hdOor6SE2IWZ.jpg"))
                    expect(model[0].originalLanguage).to(equal("en"))
                    expect(model[0].originalTitle).to(equal("Allied"))
                    expect(model[0].genreIDs).to(equal([28, 18, 53, 10749, 10752]))
                    expect(model[0].title).to(equal("Aliados"))
                    expect(model[0].voteAverage).to(equal(6.7))
                    expect(model[0].releaseDate).to(equal("2016-11-17"))
                    expect(model[0].overview).to(equal("Em uma missão para eliminar um embaixador nazista em Casablanca, no Marrocos, os espiões Max Vatan e Marianne Beausejour se apaixonam perdidamente e decidem se casar. Os problemas começam anos depois, com suspeitas sobre uma conexão entre Marianne e os alemães. Intrigado, Max decide investigar o passado da companheira e os dias de felicidade do casal vão por água abaixo."))
                case .failure(let error):
                    fail(error.localizedDescription)
                }
                done()
            }
        }
    }
    
    func mockRecommendationsFailure() {
        Mock.shared.add(target: MovieAPIs.recommendations(id: 345920, config: config), endpoint: MovieMock.recommendationsGenericError)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            MovieNetwork().recommendations(id: 345920) { result in
                switch result {
                case .success:
                    fail("Not supposed to return any recommendation")
                case .failure(let error):
                    expect(error.statusCode).to(equal(400))
                    expect(error.errorCode).to(equal(34))
                    expect(error.message).to(equal("The resource you requested could not be found."))
                }
                done()
            }
        }
    }
    
    func mockRecommendationsMapError() {
        Mock.shared.add(target: MovieAPIs.recommendations(id: 345920, config: config), endpoint: MovieMock.recommendationsMapError)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            MovieNetwork().recommendations(id: 345920) { result in
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
    
    func mockRecommendationsEmpty() {
        Mock.shared.add(target: MovieAPIs.recommendations(id: 345920, config: config), endpoint: MovieMock.recommendationsEmpty)
        
        waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
            MovieNetwork().recommendations(id: 345920) { result in
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
