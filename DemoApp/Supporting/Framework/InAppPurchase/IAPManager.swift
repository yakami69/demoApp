//
//  IAPManager.swift
//  Framework
//
//  Created by Narendra Kathayat on 8/21/20.
//  Copyright © 2020 EBPearls. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import Combine
import StoreKit

/// The state of purchase flow
public enum IAPProductState {
    case processing
    case failed(SKError)
    case purchased(InAppPurchase)
}

final public class IAPManager {
    
    public static let shared = IAPManager()
    private init() { self.completeTransactions() }
    
    /// The product list fetched from AppStoer with the provided identifiers
    public let products = CurrentValueSubject<[IAPProduct], Never>([])
    
    /// the product fetch result
    public let productsFetchResult = CurrentValueSubject<Result<[IAPProduct], Error>, Never>(.success([]))
    
    /// The available products to purchase for this app
    private var availableProducts = [IAPProductIdentifiable]()
    
    /// States when purchasing product
    public var productPurchaseState = PassthroughSubject<IAPProductState, Never>()
    
    /// set's the products
    public func setProducts(availableProducts: [IAPProductIdentifiable]) {
        self.availableProducts = availableProducts
        self.fetchAvailableProductsInfo()
    }
    
    /// Method that will be called for every app launch to complete the remaining transactions
    private func completeTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                case .failed, .purchasing, .deferred:
                    break // do nothing
                default:
                    break
                }
            }
        }
    }
    
    /// Retrieve the payment term from the identifiers list
    /// - Parameter identifier: the product identifire
    /// - Returns: the matching payment term for that product identifier
    private func getPaymentTerm(identifier: String) -> PaymentTerm {
        if let termsData = availableProducts.filter ({ $0.identifier == identifier }).first {
            return termsData.term
        }
        fatalError("The term is not setup for this identifier, Please check and update")
    }
    
    /// Method to fetch the product description for appstore
    public func fetchAvailableProductsInfo() {
        let products = Set(availableProducts.map { $0.identifier })
        SwiftyStoreKit.retrieveProductsInfo(products) { [weak self] result in
            guard let self = self else { return }
            var allProducts = [IAPProduct]()
            for product in result.retrievedProducts {
                let price = product.localizedPrice ?? product.price.stringValue
                let identifier = product.productIdentifier
                let requiredProduct = IAPProduct(localizedPrice: price, term: self.getPaymentTerm(identifier: identifier), identifier: identifier, amount: product.price.doubleValue)
                allProducts.append(requiredProduct)
            }
            self.products.send(allProducts)
            if result.error == nil {
                self.productsFetchResult.send(.success(allProducts))
            } else {
                self.productsFetchResult.send(.failure(result.error!))
            }
        }
    }
    
    /// Purchase the product
    /// - Parameters:
    ///   - product: the product to purchase
    ///   - quantity: the quantity to purchase default to 1
    public func purchase(product: IAPProduct, quantity: Int = 1) {
        SwiftyStoreKit.purchaseProduct(product.identifier, quantity: quantity, atomically: false) { [weak self] (result) in
            guard let self = self else { return }
            self.handlePurchaseResult(result, product: product)
        }
    }
    
    /// Method to handle the purchase result of the product
    ///
    /// - Parameters:
    ///   - result: the purchase result after purchasing flow
    ///   - product: the product we are purchasing
    private func handlePurchaseResult(_ result: PurchaseResult, product: IAPProduct) {
        switch result {
        case .success(purchase: let details):
            self.fetchPurchaseReceipt(for: details, product: product)
        case .error(error: let error):
            productPurchaseState.send(.failed(error))
        }
    }
    
    /// Method to get the latest receipt
    /// - Parameters:
    ///   - force: should the recipt be loaded forcefully
    ///   - completion: the completion handler for the result
    public func fetchLatestReceipt(force: Bool = false, completion: @escaping (_ receiptData: Data?, _ error: ReceiptError?) -> Void) {
        SwiftyStoreKit.fetchReceipt(forceRefresh: force) { (result) in
            switch result {
            case .success(let receiptData):
                completion(receiptData, nil)
            case .error(error: let error):
                completion(nil, error)
            }
        }
    }
    
    /// This method will fetch the receipt so that we can get the receipt details and base64 data to be verified by server
    ///
    /// - Parameters:
    ///   - details: the purchase details
    ///   - product: the product we are purchasing
    private func fetchPurchaseReceipt(for details: PurchaseDetails, product: IAPProduct) {
        fetchLatestReceipt { (receiptData, error) in
            if let receiptData = receiptData {
                let receiptValue = receiptData.base64EncodedString(options: [])
                let iap = InAppPurchase(product: product, receiptData: receiptData, receiptValue: receiptValue, purchasedDate: details.transaction.transactionDate)
                self.productPurchaseState.send(.purchased(iap))
            }
        }
    }
}
