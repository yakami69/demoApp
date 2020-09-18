//
//  BusinessListCell.swift
//  Demo App
//
//  Created by Mahesh Yakami on 1/8/20.
//

import UIKit

class BusinessListCell: UICollectionViewCell {
    
    var businessNameText : String = "" {
        didSet{
            businessTitle.text = businessNameText
        }
    }
    
    var businessDescriptionText : String = "" {
        didSet{
            businessDescription.text = businessDescriptionText
        }
    }
    
    /// Container for Cell Contents
    lazy var container: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    // MARK: - Cell Contents
    // Business Logo
    lazy var businessLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 31.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Business Title
    lazy var businessTitle : UILabel = {
        let label = UILabel()
        label.text = "EB Pearls Pvt. Ltd."
        label.font = UIFont.appFont(type: FontType.gotham(.book), size: 16)
        label.textColor = .appYellow
        label.numberOfLines = 1
        return label
    }()
    
    // Business Description
    lazy var businessDescription: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.appFont(type: FontType.gotham(.book), size: 14)
        label.textColor = .appGrey
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        create()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Creating Cell Row
    func create() {
        backgroundColor = .clear
        
        // Adding Container(Cell Row)
        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        // Adding Business Logo
        container.addSubview(businessLogo)
        businessLogo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            businessLogo.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            businessLogo.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 7),
            businessLogo.widthAnchor.constraint(equalToConstant: 100),
            businessLogo.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Adding Business Title
        container.addSubview(businessTitle)
        businessTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            businessTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: 9),
            businessTitle.leadingAnchor.constraint(equalTo: businessLogo.trailingAnchor, constant: 17),
            businessTitle.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5),
        ])
        
        // Adding Business Description
        container.addSubview(businessDescription)
        businessDescription.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            businessDescription.topAnchor.constraint(equalTo: businessTitle.bottomAnchor, constant: 8),
            businessDescription.leadingAnchor.constraint(equalTo: businessLogo.trailingAnchor, constant: 17),
            businessDescription.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5),
            businessDescription.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5)
        ])
    }
}
