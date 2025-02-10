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

  var faces: Int = 0 {
    didSet {
      self.infoLabel.text =
        switch faces {
        case 0: NSLocalizedString("No face detected", comment: "")
        case 1: NSLocalizedString("Detected One face", comment: "")
        case -1: ""
        default: NSLocalizedString("Detected \(faces) faces", comment: "")
        }
    }
  }

  private let nameLabel: UILabel = {
    return UILabel(textStyle: .headline)
  }()

  private let infoLabel: UILabel = {
    return UILabel(textStyle: .body)
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
      { [weak self] result in
        switch result {
        case .success(_): self?.detectFaces()
        case .failure(let error):
          print("Failed to detect faces for image from url: \(url). Error: \(error)")
        }
      }
    } else {
      profileImageView.image = placeholderImage
    }
  }

  func detectFaces() {
    if let image = profileImageView.image,
       let count = image.countFaces() {
      faces = count
    } else {
      faces = -1
    }
  }

  private func setupUI() {
    title = NSLocalizedString("Profile", comment: "")
    view.backgroundColor = .systemBackground

    view.addSubview(nameLabel)
    view.addSubview(infoLabel)
    view.addSubview(profileImageView)

    let space: CGFloat = 16
    let edgeSpace: CGFloat = 24
    NSLayoutConstraint.activate([
      profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

      nameLabel.bottomAnchor.constraint(equalTo: profileImageView.topAnchor, constant: -space),
      nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edgeSpace),
      nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edgeSpace),

      infoLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: space),
      infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edgeSpace),
      infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edgeSpace),
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

extension UIImage {
  func countFaces() -> Int? {
    if let observations = VisionService.shared.detectFaces(for: self) {
      return observations.count
    }
    return nil
  }
}

