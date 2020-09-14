//
//  DeviceInfo.swift
//  
//
//  Created by Rojee on 11/14/19.
//

import Foundation

/// he device info model
public struct DeviceInfo: Codable,  Parameterizable{
    
    /// The type of device
    public var deviceType: String
    
    /// The device ID
    public var deviceId: String
    
    /// The notification token
    public var deviceToken: String
    
    /// Initializer
    init(deviceType: String = "IOS", deviceId: String, deviceToken: String = "") {
        self.deviceId = deviceId
        self.deviceType = deviceType
        self.deviceToken = deviceToken
    }
    
    /// The current Device Info
    public static func current() -> DeviceInfo {
        let cacheManager = UserDefaultCacheManagerFactory.get()
        if let savedId = cacheManager.get(String.self, forKey: FrameworkCacheKey.deviceId) {
            return DeviceInfo(deviceId: savedId)
        } else {
            let newId = UUID().uuidString
            cacheManager.set(String.self, value: newId, key: FrameworkCacheKey.deviceId)
            return DeviceInfo(deviceId: newId)
        }
    }
}
