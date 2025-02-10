//
//  ProfilesViewModelTest.swift
//  SOProfilesTests
//
//  Created by Galia Kaufman on 2/9/25.
//

import Testing

struct ProfilesViewModelTest {

  let service: MockProfilesService
  let dataModel: ProfilesViewModel

  init() {
    service = MockProfilesService()
    dataModel = ProfilesViewModel(service: service)
  }

  @Test("FetchProfiles has profiles when successful")
  func test_fetchProfilesReturnsProfiles() async {
    await dataModel.fetchProfiles()

    #expect(!dataModel.profiles.isEmpty, "Profiles should be fetched")
    #expect(dataModel.profiles.count == 2, "Profiles list should include 2 profiles")
    #expect(dataModel.profiles[0].display_name == "VonC",
            "The first profile's display name should be decoded corrrectly")
  }

  @Test("FetchProfiles failsGracefully when the service fails")
  func test_fetchProfilesFailsGracefully() async {
    service.shouldSucceed = false
    await dataModel.fetchProfiles()

    #expect(dataModel.profiles.isEmpty, "Profiles should be empty")
  }
}
