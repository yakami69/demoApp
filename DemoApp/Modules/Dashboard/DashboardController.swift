//
//  DashboardController.swift
//  DemoApp
//
//  Created by Mahesh Yakami on 9/15/20.
//  Copyright © 2020 Mahesh Yakami. All rights reserved.
//

import UIKit
import Framework

class DashboardController: AppBaseController {
    
    
    /// View
     private lazy var screenView: DashboardView = {
         return baseView as! DashboardView //swiftlint:disable:this force_cast
     }()
     
     /// View Model
     private lazy var viewModel: DashboardViewModel = {
         return baseViewModel as! DashboardViewModel //swiftlint:disable:this force_cast
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.collectionView.delegate = self
        screenView.collectionView.dataSource = self
    }
    
    
}

extension DashboardController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.backgroundColor = .red
//        cell.categoryLabelText = "Title" //viewModel.categoryData.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.width < UIScreen.main.bounds.height{
            //screen with bounds width < height then 2 cells in a row
            return CGSize(width: (collectionView.bounds.width - 39) / 2, height: 123)
        }
        else {
            //screen with bounds width > height then 3 cells in a row
            return CGSize(width: (collectionView.bounds.width - 48) / 3, height: 123)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
}
