//
//  Location.swift
//  Random Users
//
//  Created by Ossama Abdelwahab on 18/06/21.
//

import UIKit

struct Location : Codable {
	let street : Street?
	let city : String?
	let state : String?
	let country : String?
	let postcode : String?
	let coordinates : Coordinates?
	let timezone : Timezone?

	enum CodingKeys: String, CodingKey {
        
		case street = "street"
		case city = "city"
		case state = "state"
		case country = "country"
		case postcode = "postcode"
		case coordinates = "coordinates"
		case timezone = "timezone"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		street = try values.decodeIfPresent(Street.self, forKey: .street)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		state = try values.decodeIfPresent(String.self, forKey: .state)
		country = try values.decodeIfPresent(String.self, forKey: .country)
        // Using codable with value that is sometimes an Int and other times a String
        do {
            postcode = try String(values.decode(Int.self, forKey: .postcode))
        } catch DecodingError.typeMismatch {
            postcode = try values.decode(String.self, forKey: .postcode)
        }
		coordinates = try values.decodeIfPresent(Coordinates.self, forKey: .coordinates)
		timezone = try values.decodeIfPresent(Timezone.self, forKey: .timezone)
	}

}
