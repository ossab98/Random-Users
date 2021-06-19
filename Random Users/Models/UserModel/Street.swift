//
//  Street.swift
//  Random Users
//
//  Created by Ossama Abdelwahab on 18/06/21.
//

import UIKit

struct Street : Codable {
	let number : Int?
	let name : String?

	enum CodingKeys: String, CodingKey {

		case number = "number"
		case name = "name"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		number = try values.decodeIfPresent(Int.self, forKey: .number)
		name = try values.decodeIfPresent(String.self, forKey: .name)
	}

}
