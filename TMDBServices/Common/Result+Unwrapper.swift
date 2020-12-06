//
//  File.swift
//  
//
//  Created by Breno Aquino on 27/10/20.
//

import Foundation

extension Result {
    func unwrapper<T>(_ success: inout Success?, _ failure: inout T?) {
        switch self {
        case .success(let model):
            success = model
        case .failure(let model):
            if let error = model as? T {
                failure = error
            }
        }
    }
}
