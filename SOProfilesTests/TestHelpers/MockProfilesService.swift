//
//  MockProfilesService.swift
//  SOProfiles
//
//  Created by Galia Kaufman on 2/9/25.
//

class MockProfilesService {

  var shouldSucceed = true

  func fetchProfiles() async -> Result<[Profile], NetworkError> {
    if shouldSucceed {
      return Result.success(TestData.getProfiles())
    } else {
      return Result.failure(.invalidResponse(statusCode: 404))
    }
  }
}
