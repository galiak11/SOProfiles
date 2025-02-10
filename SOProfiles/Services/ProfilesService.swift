//
//  ProfilesService.swift
//  SOProfiles
//
//  Created by Galia Kaufman on 2/9/25.
//

import Foundation

protocol ProfilesServiceProtocol {
  func fetchProfiles() async -> Result<[Profile], NetworkError>
}

class ProfilesService: ProfilesServiceProtocol {
  static let shared = ProfilesService()

  private let URL_STRING = "https://api.stackexchange.com/2.2/users?site=stackoverflow"

  func fetchProfiles() async -> Result<[Profile], NetworkError> {
    do {
      // TODO: build URL
      guard let url = URL(string: URL_STRING) else {
        return .failure(.invalidUrl(URL_STRING))
      }

      let (data, _) = try await URLSession.shared.data(from: url)
      // TODO: validate response
      let profilesList = try JSONDecoder().decode(ProfilesList.self, from: data)
      return .success(profilesList.profiles)

    } catch let error as DecodingError {
      return .failure(.decoding(error))
    } catch {
      return .failure(.error(innerError: error))
    }
  }
}

// MARK: - Network errors

enum NetworkError: Error {
    case invalidUrl(String)
    case invalidResponse(statusCode: Int = -1)
    case decoding(DecodingError)
    case encoding(EncodingError)
    case error(innerError: Error)
}
