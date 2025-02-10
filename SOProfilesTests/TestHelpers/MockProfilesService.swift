//
//  MockProfilesService.swift
//  SOProfiles
//
//  Created by Galia Kaufman on 2/9/25.
//

class MockProfilesService: ProfilesServiceProtocol {

  var shouldSucceed = true

  func fetchProfiles() async -> Result<[Profile], NetworkError> {
    if shouldSucceed {
      return Result.success(TestData.getProfiles())
    } else {
      return Result.failure(.invalidResponse(statusCode: 404))
    }
  }
}

extension ProfilesViewModel {

  // Enables injecting this Mock service in test cases.
  convenience init(service: MockProfilesService) {
    self.init()
    self.service = service
  }
}
