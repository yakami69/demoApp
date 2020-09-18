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
     private lazy var screenView: CategoryListView = {
         return baseView as! CategoryListView //swiftlint:disable:this force_cast
     }()
     
     /// View Model
     private lazy var viewModel: DashboardViewModel = {
         return baseViewModel as! DashboardViewModel //swiftlint:disable:this force_cast
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        screenView.collectionView.delegate = self
        screenView.collectionView.dataSource = self
    }
    
    override func setupUI() {
        showLeftBarButton = false
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = LocalizedKey.home.value
    }
    
    func loadData() {
        guard let jSONURL = Bundle.main.url(forResource: "MOCK_DATA", withExtension: ".json"),
            let jSONData = try? Data(contentsOf: jSONURL) else {
                debugPrint("File Not Found / File Not Loaded")
                return
        }
        let decoder = JSONDecoder()

        do {
            let people = try decoder.decode([Category].self, from: jSONData)
            viewModel.categoryCollection.append(contentsOf: people)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

extension DashboardController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoryCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.backgroundImage.contentMode = .scaleAspectFill
        cell.backgroundImage.kf.setImage(with: URL(string: viewModel.categoryCollection[indexPath.row].categoryImageURL!))
        cell.categoryLabelText = viewModel.categoryCollection[indexPath.row].categoryName!
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
        
        if let subcategory = viewModel.categoryCollection[indexPath.row].subCategory, subcategory.count > 0 {
            viewModel.trigger.send(AppRoute.subCategory(viewModel.categoryCollection[indexPath.row]))
        }
        else {
            if let business = viewModel.categoryCollection[indexPath.row].business, business.count > 0{
                viewModel.trigger.send(AppRoute.businessList(business, viewModel.categoryCollection[indexPath.row].categoryName!))
            } else {
                print("NO BUSINESS RELATED TO SELECTED CATEGORY")
            }
            
        }
        
    }
}
