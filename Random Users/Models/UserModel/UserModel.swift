//
//  UserModel.swift
//  Random Users
//
//  Created by Ossama Abdelwahab on 18/06/21.
//

import UIKit

struct UserModel : Codable {
    var results : [Results]?
    var info : Info?
    
    enum CodingKeys: String, CodingKey {
        
        case results = "results"
        case info = "info"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([Results].self, forKey: .results)
        info = try values.decodeIfPresent(Info.self, forKey: .info)
    }
    
}
