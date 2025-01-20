//
//  StudentCell.swift
//  AlfaAcademy
//
//  Created by Rangga Biner on 15/01/25.
//

import UIKit

class StudentCell: UITableViewCell {
    static let identifier = "StudentCell"

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        detailTextLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        if let textLabel = textLabel, let detailTextLabel = detailTextLabel {
            NSLayoutConstraint.activate([
                textLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
                textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                
                detailTextLabel.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
                detailTextLabel.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor),
                detailTextLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 4),
                detailTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ])
        }
    }
    
    func configure(with student: Student) {
        textLabel?.text = student.name
        detailTextLabel?.text = student.address
        
        if let url = URL(string: student.profile_picture) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.profileImageView.image = image
                    }
                }
            }.resume()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }
}
