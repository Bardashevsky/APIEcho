//
//  CollectionViewCell.swift
//  APIEcho
//
//  Created by Oleksandr Bardashevskyi on 11.03.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    let containerView = UIView()
    let letterLabel = UILabel()
    let countLabel = UILabel()
    
    static var reuseID: String = "Cell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        backgroundColor = .white
        
        self.layer.cornerRadius = 4
        self.layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    public func configre(letter: Character, count: Int) {
        self.letterLabel.text = "\(letter)"
        self.letterLabel.textColor = .blue
        self.letterLabel.font = letterLabel.font.withSize(20)
        
        self.countLabel.text = "\(count)"
        self.countLabel.textColor = .red
        self.countLabel.font = countLabel.font.withSize(12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = 4
        self.containerView.clipsToBounds = true
    }
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(containerView)
        containerView.addSubview(countLabel)
        containerView.addSubview(letterLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            countLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            countLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            
            letterLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            letterLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            
        ])
    }
}

