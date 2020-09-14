//
//  AddressAutoCompleteManager.swift
//  Place
//
//  Created by Narendra Kathayat on 3/15/20.
//  Copyright © 2020 Narendra Kathayat. All rights reserved.
//

import Foundation
import Alamofire
import Combine

public class AddressAutoCompleteManager {
    
    /// The google configuration data
    private let config: AddressAutoCompleteConfig
    
    /// The trigger when the addresses are fetched
    public let addresses = CurrentValueSubject<[Address], Never>([])
    
    /// The networking instance
    private let networking = AutoCompleteNetworkingFactory.get()
    
    /// Initializer
    public init(config: AddressAutoCompleteConfig) {
        self.config = config
    }
    
    /// Method to start the search with given input string
    /// - Parameter input: the input string
    public func search(_ input: String) {
        guard !input.isEmpty else {
            addresses.send([])
            return
        }
        let searchParams = getParameters(input)
        networking.requestObject(type: [Place].self, router: AutoCompleteRouter.place(searchParams)) { [weak self ](response) in
            guard let self = self else { return }
            if response.success {
                if let places = response.result, places.count > 0 {
                    self.searchAddress(places: places)
                } else {
                    self.addresses.send([])
                }
            } else {
                self.addresses.send([])
            }
        }
    }
    
    /// Method to fetch the formatted address and geometry from the resultant place
    /// - Parameter places: The auto completed place
    private func searchAddress(places: [Place]) {
        let group = DispatchGroup()
        var requiredAddress = [Address]()
        places.forEach {
            group.enter()
            let addressParam = ["place_id":$0.placeId, "key": config.apiKey]
            networking.requestObject(type: Address.self, router: AutoCompleteRouter.address(addressParam)) { [weak self ](response) in
                group.leave()
                guard let self = self else { return }
                if response.success {
                    if let address = response.result {
                        requiredAddress.append(address)
                    } else {
                        self.addresses.send([])
                    }
                } else {
                    self.addresses.send([])
                }
            }
        }
        
        group.notify(queue: .main) {[weak self] in
            guard let self = self else { return }
            self.addresses.send(requiredAddress)
        }
    }
    
    
    /// Method to build the parameters for places
    /// - Parameter input: the search text
    private func getParameters(_ input: String) -> [String: Any] {
        var params = [String: Any]()
        // remove this comment to assign australia places search only
        //        params["components"] = "country:\(config.country)"
        params["input"] = input
        params["language"] = config.language
        params["key"] = config.apiKey
        params["sessiontoken"] = config.sessionToken
        return params
    }
}

// MARK: - GeoLocation
extension AddressAutoCompleteManager {
    public func searchGeolocation(_ input: String) {
        guard !input.isEmpty else {
            addresses.send([])
            return
        }
        let params = ["address": input, "key": config.apiKey]
        
        networking.requestObject(type: [Address].self, router: AutoCompleteRouter.geocode(params)) { [weak self ](response) in
            guard let self = self else { return }
            if response.success {
                if let address = response.result, address.count > 0 {
                    self.addresses.send(address)
                } else {
                    self.addresses.send([])
                }
            } else {
                self.addresses.send([])
            }
        }
    }
}
