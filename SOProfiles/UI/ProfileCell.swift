//
//  ProfileCell.swift
//  SOProfiles
//
//  Created by Galia Kaufman on 2/9/25.
//

import UIKit

class ProfileCell: UITableViewCell {

  static let identifier = "ProfileCell"

  var profile: Profile? {
    didSet {
      configureProfile()
    }
  }

  private func configureProfile() {
    if let profile = profile {
      nameLabel.text = profile.display_name
      locationLabel.text = profile.location

      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd MMM, yyyy"
      dateFormatter.locale = Locale.current
      let member_since = dateFormatter.string(from: profile.member_date)
      dateLabel.text = "Member since: \(member_since)"
    }
  }

  private let userImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(systemName: "person.circle")?
      .withTintColor(.secondarySystemFill, renderingMode: .alwaysOriginal)

    return imageView
  }()

  private let nameLabel: UILabel = {
    return UILabel(textStyle: .headline)
  }()

  private let locationLabel: UILabel = {
    return UILabel(textStyle: .body)
  }()

  private let dateLabel: UILabel = {
    let label = UILabel(textStyle: .caption1)
    label.numberOfLines = 2
    return label
  }()

  // MARK: - cell setup

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("\(ProfileCell.self) init(coder:) has not been implemented")
  }

  private func setupUI() {
    contentView.addSubview(userImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(locationLabel)
    contentView.addSubview(dateLabel)

    let space: CGFloat = 16
    let edgeSpace: CGFloat = 24

    NSLayoutConstraint.activate([
      userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: edgeSpace),
      userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor),
      userImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
      userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: space),
      userImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -space),

      nameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: space),
      nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -edgeSpace),
      locationLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: space),
      locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -edgeSpace),
      dateLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: space),
      dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -edgeSpace),

      nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: space),
      locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: space/2),
      dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: space/2),
    ])
  }
}

private extension UILabel {
  convenience init(textStyle: UIFont.TextStyle) {
    self.init()
    font = UIFont.preferredFont(forTextStyle: textStyle)
    adjustsFontForContentSizeCategory = true
    numberOfLines = 1
    lineBreakMode = .byTruncatingTail
    translatesAutoresizingMaskIntoConstraints = false
  }
}
