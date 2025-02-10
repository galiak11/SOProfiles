//
//  ProfilesViewController.swift
//  SOProfiles
//
//  Created by Galia Kaufman on 2/9/25.
//

import UIKit

class ProfilesViewController: UIViewController {

  private let viewModel: ProfilesViewModel
  private let tableView = UITableView()

  init(viewModel: ProfilesViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { fatalError("\(ProfilesViewController.self) init(coder:) has not been implemented") }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    Task {
      await fetchProfiles()
    }
  }

  func fetchProfiles(next: Bool = false) async {
    await viewModel.fetchProfiles(next: next)
    updateUI()
  }

  func updateUI() {

    if viewModel.profiles.isEmpty {
      // TODO: Add empty state
      print ("No profiles")
    }
    tableView.reloadData()
  }
}

// MARK: UI Setup

extension ProfilesViewController {

  private func setupUI() {
    title = NSLocalizedString("StackOverflow Profiles", comment: "")
    view.backgroundColor = .white

    setupTableView()
  }

  private func setupTableView() {
    if tableView.superview == nil {
      tableView.translatesAutoresizingMaskIntoConstraints = false
      tableView.dataSource = self
      tableView.delegate = self
      tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)

      tableView.rowHeight = UITableView.automaticDimension
      tableView.estimatedRowHeight = 120

      view.addSubview(tableView)

      NSLayoutConstraint.activate([
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
    }
    tableView.isHidden = false
    self.tableView.reloadData()
  }
}

// MARK: TableView Delegate

extension ProfilesViewController: UITableViewDelegate {

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let height = scrollView.frame.size.height

    if offsetY > contentHeight - height {
      if !viewModel.isFetching {
        Task {
          await fetchProfiles(next: true)
        }
      }
    }
  }
}

// MARK: TableView Data Source

extension ProfilesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.profiles.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath)
    guard let profileCell = cell as? ProfileCell else { return cell }

    profileCell.profile = viewModel.profiles[indexPath.row]
    return cell
  }
}
