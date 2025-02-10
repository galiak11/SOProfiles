//
//  ProfilesViewModel.swift
//  SOProfiles
//
//  Created by Galia Kaufman on 2/9/25.
//

class ProfilesViewModel {

  private(set) var profiles: [Profile] = []
  var service = ProfilesService.shared

  func fetchProfiles() async {
    let result = await service.fetchProfiles()
    switch (result) {
    case .success(let profiles):
      self.profiles.append(contentsOf: profiles)
    case .failure(let error):
      profiles = []
      print("Error fetching StackOverflow profiles data:\n\n", error)
    }
  }
}
