//
//  ProductCompany.swift
//  
//
//  Created by Breno Aquino on 28/10/20.
//

import Foundation

public struct ProductCompany: Codable {
    public let id: Int?
    public let logo: String?
    public let name: String?
    public let originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case logo = "logo_path"
        case originCountry = "origin_country"
    }
}
