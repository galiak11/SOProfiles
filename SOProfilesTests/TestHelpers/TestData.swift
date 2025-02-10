//
//  TestData.swift
//  SOProfiles
//
//  Created by Galia Kaufman on 2/9/25.
//

import Foundation

struct TestData {

  static func getProfiles() -> [Profile] {
    let jsonData = """
    [
      {
        "badge_counts": {
          "bronze": 5583,
          "silver": 4709,
          "gold": 563
        },
        "account_id": 4243,
        "is_employee": false,
        "last_modified_date": 1738629619,
        "last_access_date": 1739024257,
        "reputation_change_year": 6553,
        "reputation_change_quarter": 6553,
        "reputation_change_month": 1283,
        "reputation_change_week": 1163,
        "reputation_change_day": 90,
        "reputation": 1324258,
        "creation_date": 1221344553,
        "user_type": "registered",
        "user_id": 6309,
        "accept_rate": 100,
        "location": "France",
        "website_url": "https://devstory.fyi/vonc",
        "link": "https://stackoverflow.com/users/6309/vonc",
        "profile_image": "https://i.sstatic.net/I4fiW.jpg?s=256",
        "display_name": "VonC"
      },
      {
        "badge_counts": {
          "bronze": 693,
          "silver": 580,
          "gold": 38
        },
        "account_id": 4601727,
        "is_employee": false,
        "last_modified_date": 1737115800,
        "last_access_date": 1709580221,
        "reputation_change_year": 831,
        "reputation_change_quarter": 831,
        "reputation_change_month": 200,
        "reputation_change_week": 190,
        "reputation_change_day": 10,
        "reputation": 887118,
        "creation_date": 1402536093,
        "user_type": "registered",
        "user_id": 3732271,
        "website_url": "http://linkedin.com/in/akrun1",
        "link": "https://stackoverflow.com/users/3732271/akrun",
        "profile_image": "https://i.sstatic.net/4WkGW.jpg?s=256",
        "display_name": "akrun"
      },
    ]
    """.data(using: .utf8)!

    do {
      return try JSONDecoder().decode([Profile].self, from: jsonData)
    } catch {
      fatalError("Test error: Cannot create Profiles List")
    }
  }
}
