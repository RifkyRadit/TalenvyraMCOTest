//
//  NewsArticleCell.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 06/06/26.
//

import UIKit
import Kingfisher

class NewsArticleCell: UITableViewCell {
    private let articleImageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        articleImageView.clipsToBounds = true
        articleImageView.layer.cornerRadius = 4
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(articleImageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            articleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            articleImageView.heightAnchor.constraint(equalToConstant: 40),
            articleImageView.widthAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configureCell(with article: ArticleData) {
        titleLabel.text = article.title
        setupImageView(urlImageString: article.urlToImage)
    }
    
    private func setupImageView(urlImageString: String?) {
        let placeholderImage = UIImage(systemName: "photo")?
                .withTintColor(.systemGray4, renderingMode: .alwaysOriginal)
        
        if let urlImageString = urlImageString, let urlImage = URL(string: urlImageString) {
            articleImageView.contentMode = .scaleAspectFill
            articleImageView.kf.setImage(
                with: urlImage,
                placeholder: placeholderImage,
                options: [
                    .cacheOriginalImage,
                    .transition(.fade(0.25)),
                    .backgroundDecode
                ]
            )
        } else {
            articleImageView.image = placeholderImage
            articleImageView.contentMode = .scaleAspectFit
        }
    }
}
