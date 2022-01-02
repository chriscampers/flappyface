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

class GameSettingManager: GamePhysicsSettingsProtocol {
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
    
    init() {
        
    }
}
