//
//  Profile.swift
//  SOProfiles
//
//  Created by Galia Kaufman on 2/9/25.
//

import Foundation

class ProfilesList: Decodable {
  var profiles: [Profile]
}

class Profile: Decodable {
  var account_id: Int
  var display_name: String
  var location: String?
  var creation_date: TimeInterval
  var profile_image: String
}
