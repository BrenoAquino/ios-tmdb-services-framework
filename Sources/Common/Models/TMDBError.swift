//
//  TMDBError.swift
//  
//
//  Created by Breno Aquino on 27/10/20.
//

import Foundation
import Moya

public struct TMDBErrorModel: Codable {
    public var statusCode: Int?
    public let errorCode: Int?
    public let message: String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case message = "status_message"
        case errorCode = "status_code"
    }
}

public struct TMDBError: Error {
    
    public enum ErrorType: Int {
        case generic = -1
        case encodingError = -2
        case networkUnavailable1 = -1009
        case networkUnavailable2 = -1008
        case requestCancelled = -999
    }
    
    private var model: TMDBErrorModel?
    
    public var response: Response?
    public var type: ErrorType = .encodingError
    public var message: String? { model?.message }
    public var statusCode: Int? { model?.statusCode }
    public var errorCode: Int? { model?.errorCode }
    
    // MARK: - Inits
    public init(_ error: Error) {
        type = .encodingError
    }
    
    public init(_ moyaError: MoyaError) {
        response = moyaError.response
        
        if let nsError = moyaError.errorUserInfo[NSUnderlyingErrorKey] as? NSError,
               nsError.code == ErrorType.networkUnavailable1.rawValue ||
               nsError.code == ErrorType.networkUnavailable2.rawValue {
            type = .networkUnavailable1
            return
        }
        
        if let nsError = moyaError.errorUserInfo[NSUnderlyingErrorKey] as? NSError, nsError.code == ErrorType.requestCancelled.rawValue {
            type = .requestCancelled
            return
        }
        
        guard let response = moyaError.response else { return }
        do {
            model = try response.map(TMDBErrorModel.self, using: JSONDecoder(), failsOnEmptyData: false)
            model?.statusCode = response.statusCode
            type = ErrorType(rawValue: model?.statusCode ?? -1) ?? .encodingError
        } catch {
            type = .encodingError
        }
    }
}


