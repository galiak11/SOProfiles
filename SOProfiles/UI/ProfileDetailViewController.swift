//
//  ProfileDetailViewController.swift
//  SOProfiles
//
//  Created by Galia Kaufman on 2/10/25.
//

import UIKit
import Kingfisher

class ProfileDetailViewController: UIViewController {

  var profile: Profile {
    didSet {
      configUI()
    }
  }

  private let nameLabel: UILabel = {
    return UILabel(textStyle: .headline)
  }()

  private let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  init(profile: Profile) {
    self.profile = profile
    super.init(nibName: nil, bundle: nil)
    configUI()
  }

  required init?(coder: NSCoder) {
    fatalError("\(ProfileDetailViewController.self): init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func configUI() {
    nameLabel.text = profile.display_name

    let placeholderImage = UIImage(systemName: "person.circle")?
        .withTintColor(.secondarySystemFill, renderingMode: .alwaysOriginal)

    if let url = profile.profile_image_url {
      let processor = RoundCornerImageProcessor(cornerRadius: 25)

      profileImageView.kf.setImage(with: url,
                                placeholder: placeholderImage,
                                    options: [
                                      .diskCacheExpiration(.never),
                                      .processor(processor),
                                       .forceRefresh, // debug
                                      .transition(.fade(0.3)),
                                    ])
    } else {
      profileImageView.image = placeholderImage
    }
  }

  private func setupUI() {
    title = NSLocalizedString("Profile", comment: "")
    view.backgroundColor = .systemBackground

    view.addSubview(nameLabel)
    view.addSubview(profileImageView)

    let space: CGFloat = 16
    let edgeSpace: CGFloat = 24
    NSLayoutConstraint.activate([
      profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

      nameLabel.bottomAnchor.constraint(equalTo: profileImageView.topAnchor, constant: -space),
      nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edgeSpace),
      nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edgeSpace),
    ])
  }
}

private extension UILabel {
  convenience init(textStyle: UIFont.TextStyle) {
    self.init()
    textAlignment = .center
    font = UIFont.preferredFont(forTextStyle: textStyle)
    adjustsFontForContentSizeCategory = true
    translatesAutoresizingMaskIntoConstraints = false
  }
}

