//
//  BusinessListController.swift
//  DemoApp
//
//  Created by Mahesh Yakami on 9/19/20.
//  Copyright © 2020 Mahesh Yakami. All rights reserved.
//

import UIKit
import Framework

class BusinessListController: AppBaseController {
    
    /// View
     private lazy var screenView: BusinessListView = {
         return baseView as! BusinessListView //swiftlint:disable:this force_cast
     }()
     
     /// View Model
     private lazy var viewModel: BusinessListViewModel = {
         return baseViewModel as! BusinessListViewModel //swiftlint:disable:this force_cast
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.collectionView.delegate = self
        screenView.collectionView.dataSource = self
    }
    
    override func setupUI() {
        navigationItem.title = viewModel.title
    }

}

extension BusinessListController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.business.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "businessListCell", for: indexPath) as! BusinessListCell
        cell.businessLogo.kf.setImage(with: URL(string: (viewModel.business[indexPath.row].businessImageURL!)))
        cell.businessTitle.text = viewModel.business[indexPath.row].businessName
        cell.businessDescription.text = viewModel.business[indexPath.row].businessDescription
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.width - 39), height: 123)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.trigger.send(AppRoute.businessDetail(viewModel.business[indexPath.row]))
        
    }
}

