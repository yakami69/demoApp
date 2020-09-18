//
//  BusinessDetailScreenView.swift
//  Demo App
//
//  Created by Mahesh Yakami on 1/9/20.
//

import UIKit
import Hero
import Framework

class BusinessDetailScreenView: BaseView {
    
    //MARK: - UIComponents
    
    lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    //MARK: - seperators
    lazy var telephoneSeparator: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .appGrey
        return view
    }()
    
    lazy var emailSeparator: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .appGrey
        return view
    }()
    
    lazy var addressSeparator: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .appGrey
        return view
    }()
    
    //MARK: - content view
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    /// Image View of busisness
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //MARK: - labels
    lazy var businessNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.appFont(type: FontType.gotham(.bold), size: 18)
        label.textAlignment = .right
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    /// Category of Business
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.appFont(type: FontType.gotham(.light), size: 14)
        label.textAlignment = .right
        label.textColor = .appGrey
        return label
    }()
    
    /// View holding Description of business
    lazy var descriptionView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    /// A label text with "Description:"
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description: "
        label.numberOfLines = 1
        label.font = UIFont.appFont(type: FontType.gotham(.bold), size: 16)
        label.textColor = .appGrey
        return label
    }()
    
    /// Label to show Business Description
    lazy var descriptionTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.appFont(type: FontType.gotham(.light), size: 14)
        label.textAlignment = .left
        label.textColor = .appGrey
        return label
    }()
    
    /// View holding telephone details of View
    lazy var telephoneLabelView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    /// Telephone Icon
    lazy var telephoneIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "telephone-black").withRenderingMode(.alwaysOriginal).withTintColor(.appDarkGrey)
        imageView.tintColor = .appYellow
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    /// Telephone number  label
    lazy var telephoneLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.appFont(type: FontType.gotham(.light), size: 14)
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        label.textColor = .appGrey
        return label
    }()
    
    /// View holding email details of business
    lazy var emailLabelView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    /// email icon
    lazy var emailIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "email-black").withRenderingMode(.alwaysOriginal).withTintColor(.appDarkGrey)
        imageView.tintColor = .appYellow
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    /// Email label
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.appFont(type: FontType.gotham(.light), size: 14)
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        label.textColor = .appGrey
        return label
    }()
    
    /// View holding address of business
    lazy var addressLabelView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    /// Address icon
    lazy var addressIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "address-black").withRenderingMode(.alwaysOriginal).withTintColor(.appDarkGrey)
        imageView.tintColor = .appYellow
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    /// Address label
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.appFont(type: FontType.gotham(.light), size: 14)
        label.textAlignment = .left
        label.textColor = .appGrey
        return label
    }()
    
    /// Contact Business Button
    lazy var contactBusinessButton: UIButton = {
        let button = UIButton()
        button.setTitle("Contact this Business", for: .normal)
        button.titleLabel?.font = UIFont.appFont(type: FontType.gotham(.bold), size: 20)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.appLightGrey.cgColor
        button.setTitleColor(.appYellow, for: .normal)
        button.setImage(#imageLiteral(resourceName: "contactBusiness").withRenderingMode(.alwaysOriginal).withTintColor(.appYellow), for: .normal)
        let buttonWidth = CGFloat(300)
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: buttonWidth - 40, bottom: 15, right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 40)
        return button
    }()
    

    
    //overlay for image view
    lazy var overlayView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        return view
    }()

    //tap gestures
    let contactTapGesture = UITapGestureRecognizer()
    let emailTapGesture = UITapGestureRecognizer()


    // MARK: - Adding UI Elemnts to View
    override func create() {
        
        // MARK: - Content View
        backgroundColor = .appBackground
        
        addSubview(contentScrollView)
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
        
        contentScrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        // MARK: - Image View
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 250),
        ])
        
        //MARK: - overlay
        imageView.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            overlayView.topAnchor.constraint(equalTo: imageView.topAnchor)
        ])
               
        
        //MARK: - Business Name
        overlayView.addSubview(businessNameLabel)
        businessNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            businessNameLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 10),
            businessNameLabel.heightAnchor.constraint(equalToConstant: 20),
            businessNameLabel.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -5)
        ])
        
        // MARK: - Category
        contentView.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            categoryLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        // MARK: - Description View
        contentView.addSubview(descriptionView)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10),
            descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
        
        descriptionView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 5),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 15),
            descriptionLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
        
        descriptionView.addSubview(descriptionTextLabel)
        descriptionTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionTextLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            descriptionTextLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 5),
            descriptionTextLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor),
            descriptionTextLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: -5)
        ])
                
        // MARK: - Telephone View
        contentView.addSubview(telephoneLabelView)
        telephoneLabelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            telephoneLabelView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 10),
            telephoneLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            telephoneLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
        
        telephoneLabelView.addSubview(telephoneIconView)
        telephoneIconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            telephoneIconView.leadingAnchor.constraint(equalTo: telephoneLabelView.leadingAnchor, constant: 5),
            telephoneIconView.topAnchor.constraint(equalTo: telephoneLabelView.topAnchor, constant: 15),
            telephoneIconView.bottomAnchor.constraint(equalTo: telephoneLabelView.bottomAnchor, constant: -5),
            telephoneIconView.heightAnchor.constraint(equalToConstant: 32),
            telephoneIconView.widthAnchor.constraint(equalToConstant: 32)
        ])
        
        telephoneLabelView.addSubview(telephoneLabel)
        telephoneLabel.addGestureRecognizer(contactTapGesture)
        telephoneLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            telephoneLabel.leadingAnchor.constraint(equalTo: telephoneIconView.trailingAnchor, constant: 10),
            telephoneLabel.trailingAnchor.constraint(equalTo: telephoneLabelView.trailingAnchor, constant: -5),
            telephoneLabel.topAnchor.constraint(equalTo: telephoneIconView.topAnchor),
            telephoneLabel.bottomAnchor.constraint(equalTo: telephoneIconView.bottomAnchor)
        ])
        
        contentView.addSubview(telephoneSeparator)
        telephoneSeparator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            telephoneSeparator.topAnchor.constraint(equalTo: telephoneLabelView.bottomAnchor),
            telephoneSeparator.leadingAnchor.constraint(equalTo: telephoneLabel.leadingAnchor),
            telephoneSeparator.trailingAnchor.constraint(equalTo: telephoneLabel.trailingAnchor),
            telephoneSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        // MARK: - Email View
        contentView.addSubview(emailLabelView)
        emailLabelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailLabelView.topAnchor.constraint(equalTo: telephoneSeparator.bottomAnchor, constant: 10),
            emailLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            emailLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
        
        emailLabelView.addSubview(emailIconView)
        emailIconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailIconView.leadingAnchor.constraint(equalTo: emailLabelView.leadingAnchor, constant: 5),
            emailIconView.topAnchor.constraint(equalTo: emailLabelView.topAnchor, constant: 15),
            emailIconView.bottomAnchor.constraint(equalTo: emailLabelView.bottomAnchor, constant: -5),
            emailIconView.heightAnchor.constraint(equalToConstant: 32),
            emailIconView.widthAnchor.constraint(equalToConstant: 32)
        ])
        
        emailLabelView.addSubview(emailLabel)
        emailLabel.addGestureRecognizer(emailTapGesture)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailLabel.leadingAnchor.constraint(equalTo: emailIconView.trailingAnchor, constant: 10),
            emailLabel.trailingAnchor.constraint(equalTo: emailLabelView.trailingAnchor, constant: -5),
            emailLabel.topAnchor.constraint(equalTo: emailIconView.topAnchor),
            emailLabel.bottomAnchor.constraint(equalTo: emailIconView.bottomAnchor)
        ])
        
        contentView.addSubview(emailSeparator)
        emailSeparator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailSeparator.topAnchor.constraint(equalTo: emailLabelView.bottomAnchor),
            emailSeparator.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            emailSeparator.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            emailSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        // MARK: - Address View
        contentView.addSubview(addressLabelView)
        addressLabelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addressLabelView.topAnchor.constraint(equalTo: emailSeparator.bottomAnchor, constant: 10),
            addressLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            addressLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
        
        addressLabelView.addSubview(addressIconView)
        addressIconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addressIconView.leadingAnchor.constraint(equalTo: addressLabelView.leadingAnchor, constant: 5),
            addressIconView.topAnchor.constraint(equalTo: addressLabelView.topAnchor, constant: 15),
            addressIconView.bottomAnchor.constraint(equalTo: addressLabelView.bottomAnchor, constant: -5),
            addressIconView.heightAnchor.constraint(equalToConstant: 32),
            addressIconView.widthAnchor.constraint(equalToConstant: 32)
        ])
        
        addressLabelView.addSubview(addressLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addressLabel.leadingAnchor.constraint(equalTo: addressIconView.trailingAnchor, constant: 10),
            addressLabel.trailingAnchor.constraint(equalTo: addressLabelView.trailingAnchor, constant: -5),
            addressLabel.topAnchor.constraint(equalTo: addressIconView.topAnchor),
            addressLabel.bottomAnchor.constraint(equalTo: addressIconView.bottomAnchor)
        ])
        
        contentView.addSubview(addressSeparator)
        addressSeparator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addressSeparator.topAnchor.constraint(equalTo: addressLabelView.bottomAnchor),
            addressSeparator.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor),
            addressSeparator.trailingAnchor.constraint(equalTo: addressLabel.trailingAnchor),
            addressSeparator.heightAnchor.constraint(equalToConstant: 1),
        ])
        
        //MARK: - contact view
        contentView.addSubview(contactBusinessButton)
        contactBusinessButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contactBusinessButton.topAnchor.constraint(equalTo: addressSeparator.bottomAnchor, constant: 30),
            contactBusinessButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            contactBusinessButton.heightAnchor.constraint(equalToConstant: 60),
            contactBusinessButton.widthAnchor.constraint(equalToConstant: 300),
            contactBusinessButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }

}
