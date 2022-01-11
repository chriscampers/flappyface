//
//  StringConstants.swift
//  FlappyHead
//
//  Created by Chris Campanelli on 2022-01-06.
//

import Foundation

struct StringConstants {

    // MARK: Permissions Page
    static func cameraPermissionsPrompt_title() -> String {
        return NSLocalizedString("cameraPermissionsPrompt_title",
                                 tableName: nil,
                                 bundle: Bundle.main,
                                 value: "Camera Permissions Requried",
                                 comment: "permissions page title text")
    }
    
    static func cameraPermissionsPrompt_body() -> String {
        return NSLocalizedString("cameraPermissionsPrompt_body",
                                 tableName: nil,
                                 bundle: Bundle.main,
                                 value: "Camera permissions are required to be enabled in order to play Fappy Face. Flappy Face uses facial experssions to control characters in the game.",
                                 comment: "permissions page main body text")
    }
    
    static func cameraPermissionsPrompt_button() -> String {
        return NSLocalizedString("cameraPermissionsPrompt_button",
                                 tableName: nil,
                                 bundle: Bundle.main,
                                 value: "Go To Settings",
                                 comment: "Button title")
    }
    
    // MARK: Settings page
    static func settings_canRecordTitle() -> String {
        return NSLocalizedString("settings_canRecordTitle",
                                 tableName: nil,
                                 bundle: Bundle.main,
                                 value: "Record Playback Video",
                                 comment: "Settings title body")
    }
    
    static func settings_canRecordBody() -> String {
        return NSLocalizedString("settings_canRecordBody",
                                 tableName: nil,
                                 bundle: Bundle.main,
                                 value: "In order to create gameplay playback snippits, for security purposes you will be prompted every time the app starts to allow gameplay recordings. This toggle will always disable permissions",
                                 comment: "Settings title body")
    }
    
    static func settings_notificationEnabledTitle() -> String {
        return NSLocalizedString("settings_notificationEnabledTitle",
                                 tableName: nil,
                                 bundle: Bundle.main,
                                 value: "Push Notifications",
                                 comment: "Settings title body")
    }
    
    static func settings_notificationEnabledBody() -> String {
        return NSLocalizedString("settings_notificationEnabledBody",
                                 tableName: nil,
                                 bundle: Bundle.main,
                                 value: "Push notifications relating to game reminders, promotions, etc",
                                 comment: "Settings title body")
    }
    
    
}
