//
//  ProfilesViewModel.swift
//  SOProfiles
//
//  Created by Galia Kaufman on 2/9/25.
//

class ProfilesViewModel {

  private(set) var profiles: [Profile] = []
  var service: ProfilesServiceProtocol = ProfilesService.shared

  var isFetching = false
  private var currentPage = 1

  func fetchProfiles(next: Bool = false) async {
    guard !isFetching else { return }
    isFetching = true
    if next {
      currentPage += 1
    }

    let result = await service.fetchProfiles(page: currentPage)
    isFetching = false

    switch (result) {
    case .success(let profiles):
      self.profiles.append(contentsOf: profiles)
    case .failure(let error):
      profiles = []
      print("Error fetching StackOverflow profiles data:\n\n", error)
    }
  }
}
