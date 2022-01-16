//
//  RemoteConfigManager.swift
//  FlappyHead
//
//  Created by Chris Campanelli on 2022-01-15.
//

import Foundation
import FirebaseRemoteConfig

protocol RemoteConfigManagerType {
    func smileThreshold() -> NSNumber?
    func blinkThreshold() -> NSNumber?
    func browDownThreshold() -> NSNumber?
    func browUpThreshold() -> NSNumber?
    func cheekPuffThreshold() -> NSNumber?
    func mouthPuckerThreshold() -> NSNumber?
    func jawOpenThreshold() -> NSNumber?
    func jawLeftThreshold() -> NSNumber?
    func jawRightThreshold() -> NSNumber?
    func squintThreshold() -> NSNumber?
}

enum RemoteConfigKeys: String {
    case smileThreshold = "smileThreshold"
    case blinkThreshold = "blinkThreshold"
    case browDownThreshold = "browDownThreshold"
    case browUpThreshold = "browUpThreshold"
    case cheekPuffThreshold = "cheekPuffThreshold"
    case mouthPuckerThreshold = "mouthPuckerThreshold"
    case jawOpenThreshold = "jawOpenThreshold"
    case jawLeftThreshold = "jawLeftThreshold"
    case jawRightThreshold = "jawRightThreshold"
    case squintThreshold = "squintThreshold"
}

class RemoteConfigManager {
    static let shared = RemoteConfigManager()
    
    private let remoteConfig: RemoteConfig!
    private var valueTypeMapper: [RemoteConfigKeys: Any.Type] = [RemoteConfigKeys: Any.Type]()
    
    init() {
        remoteConfig = RemoteConfig.remoteConfig()
        
        valueTypeMapper = [RemoteConfigKeys.smileThreshold: NSNumber.self,
                           RemoteConfigKeys.blinkThreshold: NSNumber.self,
                           RemoteConfigKeys.browDownThreshold: NSNumber.self,
                           RemoteConfigKeys.browUpThreshold: NSNumber.self,
                           RemoteConfigKeys.cheekPuffThreshold: NSNumber.self,
                           RemoteConfigKeys.jawOpenThreshold: NSNumber.self,
                           RemoteConfigKeys.jawRightThreshold: NSNumber.self,
                           RemoteConfigKeys.squintThreshold: NSNumber.self]
        
        // setup
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        remoteConfig.fetch { (status, error) -> Void in
          if status == .success {
            print("Config fetched!")
            self.remoteConfig.activate { changed, error in
                //
            }
          } else {
            print("Config not fetched")
            print("Error: \(error?.localizedDescription ?? "No error available.")")
          }
        }
    }
    
    private func getRemoteValue(key: RemoteConfigKeys) -> Any? {
        guard let storedType = valueTypeMapper[key] else { return nil }
        
        if storedType == Bool.self {
            return remoteConfig.configValue(forKey: key.rawValue).boolValue
        } else if storedType == NSNumber.self{
            return remoteConfig.configValue(forKey: key.rawValue).numberValue
        }
        
        return nil
    }
}

extension RemoteConfigManager: RemoteConfigManagerType {
    func smileThreshold() -> NSNumber? {
        return getRemoteValue(key: .smileThreshold) as? NSNumber
    }
    
    func blinkThreshold() -> NSNumber? {
        return getRemoteValue(key: .blinkThreshold) as? NSNumber
    }
    
    func browDownThreshold() -> NSNumber? {
        return getRemoteValue(key: .browDownThreshold) as? NSNumber
    }
    
    func browUpThreshold() -> NSNumber? {
        return getRemoteValue(key: .browUpThreshold) as? NSNumber
    }
    
    func cheekPuffThreshold() -> NSNumber? {
        return getRemoteValue(key: .cheekPuffThreshold) as? NSNumber
    }
    
    func mouthPuckerThreshold() -> NSNumber? {
        return getRemoteValue(key: .mouthPuckerThreshold) as? NSNumber
    }
    
    func jawOpenThreshold() -> NSNumber? {
        return getRemoteValue(key: .jawOpenThreshold) as? NSNumber
    }
    
    func jawLeftThreshold() -> NSNumber? {
        return getRemoteValue(key: .jawLeftThreshold) as? NSNumber
    }
    
    func jawRightThreshold() -> NSNumber? {
        return getRemoteValue(key: .jawRightThreshold) as? NSNumber
    }
    
    func squintThreshold() -> NSNumber? {
        return getRemoteValue(key: .squintThreshold) as? NSNumber
    }
}
