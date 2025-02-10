//
//  ProfilesService.swift
//  SOProfiles
//
//  Created by Galia Kaufman on 2/9/25.
//

import Foundation

protocol ProfilesServiceProtocol {
  func fetchProfiles(page: Int) async -> Result<[Profile], NetworkError>
}

class ProfilesService: ProfilesServiceProtocol {
  static let shared = ProfilesService()

  private let URL_STRING = "https://api.stackexchange.com/2.2/users"

  func fetchProfiles(page: Int = 1) async -> Result<[Profile], NetworkError> {
    do {
      let url = try urlString(page: page)

      let (data, response) = try await URLSession.shared.data(from: url)
      try validate(response)
      let profilesList = try JSONDecoder().decode(ProfilesList.self, from: data)
      return .success(profilesList.profiles)

    } catch let error as DecodingError {
      return .failure(.decoding(error))
    } catch {
      return .failure(.error(innerError: error))
    }
  }

  private func urlString(page: Int, limit: Int = 30) throws(NetworkError) -> URL {
    var urlComponents = URLComponents(string: URL_STRING)
    urlComponents?.queryItems = [
      URLQueryItem(name: "site", value: "stackoverflow"),
      URLQueryItem(name: "page", value: String(page)),
      URLQueryItem(name: "pagesize", value: String(limit)),
    ]
    guard let url = urlComponents?.url else {
      throw .invalidUrl(urlComponents?.description ?? URL_STRING)
    }
    return url
  }

  private func validate(_ response: URLResponse) throws(NetworkError) {
    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
      throw .invalidResponse()
    }
    guard (200...299).contains(statusCode) else {
      throw .invalidResponse(statusCode: statusCode)
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
