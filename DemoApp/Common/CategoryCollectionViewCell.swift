//
//  CategoryCollectionViewCell.swift
//  Wedding App
//
//  Created by Mahesh Yakami on 1/7/20.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    var categoryLabelText : String = "" {
        didSet{
            categoryLabel.text = categoryLabelText
        }
    }
    
    var categoryImage : UIImage = UIImage.backgroundImage! {
        didSet{
            backgroundImage.image = categoryImage
        }
    }
    
    lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .backgroundImage
        return imageView
    }()
    
    lazy var shadeLayer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        return view
    }()
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.appFont(type: FontType.gotham(.bold), size: 15)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Decoration Department"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        create()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func create(){
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        addSubview(shadeLayer)
        shadeLayer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shadeLayer.topAnchor.constraint(equalTo: topAnchor),
            shadeLayer.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadeLayer.trailingAnchor.constraint(equalTo: trailingAnchor),
            shadeLayer.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
}
