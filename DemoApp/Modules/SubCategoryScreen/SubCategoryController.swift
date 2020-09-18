//
//  SubCategoryController.swift
//  DemoApp
//
//  Created by Mahesh Yakami on 9/18/20.
//  Copyright © 2020 Mahesh Yakami. All rights reserved.
//

import UIKit
import Framework

class SubCategoryController: AppBaseController {
    // View
     private lazy var screenView: CategoryListView = {
         return baseView as! CategoryListView //swiftlint:disable:this force_cast
     }()
     
     /// View Model
     private lazy var viewModel: SubCategoryViewModel = {
         return baseViewModel as! SubCategoryViewModel //swiftlint:disable:this force_cast
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.collectionView.delegate = self
        screenView.collectionView.dataSource = self
    }
    
    override func setupUI() {
        navigationItem.title = viewModel.category.categoryName
    }
    
}

extension SubCategoryController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.category.subCategory!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.backgroundImage.contentMode = .scaleAspectFill
        cell.backgroundImage.kf.setImage(with: URL(string: viewModel.category.subCategory![indexPath.row].subCategoryImageURL!))
        cell.categoryLabelText = viewModel.category.subCategory![indexPath.row].subCategoryName!
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let business = viewModel.category.subCategory![indexPath.row].business, business.count > 0 {
            viewModel.trigger.send(AppRoute.businessList(business, viewModel.category.subCategory![indexPath.row].subCategoryName!))
        } else {
            print("NO BUSINESS RELATED TO SELECTED CATEGORY")
        }
    }
    
}
