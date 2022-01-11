//
//  GameSettingManager.swift
//  FaceTriggerExample
//
//  Created by Chris Campanelli on 2021-08-21.
//  Copyright © 2021 Blinkloop. All rights reserved.
//

import Foundation

protocol GamePhysicsSettingsProtocol: Any {
    var speed: Int { get }
    var tubeGap: Double { get }
}

protocol GlobalSettingsProtocol: Any {
    var canRecordScreen: Bool { get set }
    var isNotificationEnabled: Bool { get set }
}

class GameSettingManager: GamePhysicsSettingsProtocol, GlobalSettingsProtocol {
    
    static let shared = GameSettingManager()
    
    
    //MARK: Game physic settings
    var speed: Int = 1
    var tubeGap: Double = 180
    
    //MARK: Face settings
    var blinkEnabled: Bool = false
    var leftEyeWinkEnabled: Bool = false
    var rightEyeWinkEnabled: Bool = false
    var kissyFaceEnabled: Bool = false
    var smileEnabled:Bool = false
    
    //MARK: Privacy Settings
    @Storage(key: "canRecordScreen", defaultValue: false)
    var canRecordScreen: Bool
    
    @Storage(key: "isNotificationEnabled", defaultValue: false)
    var isNotificationEnabled: Bool
    
    init() {
        
    }
}


@propertyWrapper
struct Storage<T: Codable> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }

            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // Convert newValue to data
            let data = try? JSONEncoder().encode(newValue)
            
            // Set value to UserDefaults
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
