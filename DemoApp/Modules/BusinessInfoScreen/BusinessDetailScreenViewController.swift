//
//  BusinessDetailScreenViewController.swift
//  Demo App
//
//  Created by Mahesh Yakami on 1/9/20.
//

import UIKit
import RxSwift
import RxCocoa
import MessageUI
import Hero
import Kingfisher
import Framework

class BusinessDetailScreenViewController: BaseController {
    
    //MARK: - properties
    lazy var businessDetailScreenView: BusinessDetailScreenView = {
        return baseView as! BusinessDetailScreenView
    }()
    
    lazy var businessDetailScreenViewModel: BusinessDetailScreenViewModel = {
        return baseViewModel as! BusinessDetailScreenViewModel
    }()
    
    //MARK: - functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.businessDetailScreenView.imageView.hero.id = String(businessDetailScreenViewModel.businessInfo.objectId!)
    }
    
    override func observeEvents() {
    }
    
    
    override func setupUI() {
        self.navigationItem.title = "Business Profile"
        businessDetailScreenView.imageView.kf.setImage(with: businessDetailScreenViewModel.imageUrl, placeholder: UIImage.backgroundImage)
        
        businessDetailScreenView.businessNameLabel.text = businessDetailScreenViewModel.businessInfo.businessName
        
        let firstString = NSMutableAttributedString(string: "Price: ", attributes: generateFontWith(fontStyle: UIFont.appFont(type: FontType.gotham(.bold), size: 14), maxLineHeight: nil, textColor: .appGrey))
        let secondString = NSAttributedString(string: (businessDetailScreenViewModel.businessInfo.businessPrice)! + "/Day")
        firstString.append(secondString)
        
        businessDetailScreenView.categoryLabel.attributedText = firstString
        
        businessDetailScreenView.descriptionTextLabel.text = businessDetailScreenViewModel.businessInfo.businessDescription
        
        businessDetailScreenView.telephoneLabel.text = String(businessDetailScreenViewModel.businessInfo.businessContact!)
        
        businessDetailScreenView.emailLabel.text = businessDetailScreenViewModel.businessInfo.businessEmail
        
        businessDetailScreenView.addressLabel.text = businessDetailScreenViewModel.businessInfo.businessAddress
        
    }
    
    func makePhoneCall(toNumber: String) {
        if let phoneURL = NSURL(string: ("tel://" + toNumber)) {
            UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
        }
    }
}

extension BusinessDetailScreenViewController: MFMailComposeViewControllerDelegate {
    
    func sendMail(to: String){
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([to])
            mail.setCcRecipients(["mahesh.yakami@ebpearls.com","mukesh.awal@ebpearls.com"])
            present(mail, animated: true)
        } else {
            debugPrint("mail could not be send from here")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
