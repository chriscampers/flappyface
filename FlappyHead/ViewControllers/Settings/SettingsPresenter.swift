//
//  SettingsPresenter.swift
//  FlappyHead
//
//  Created by Chris Campanelli on 2022-01-10.
//

import Foundation

struct SettingsToggleCellDataModel {
    let titleName: String
    let subtitleName: String
    var settingsProperty: Bool
    var toggleClosure: (_ switchValue: Bool) -> Void
}


class SettingsPresenter {
    
    let vc: SettingsViewController
    var globalSettingsManager: GlobalSettingsProtocol
    
    var toggleSettingsList: [SettingsToggleCellDataModel]!
    
    init(vc: SettingsViewController,
         globalSettingsManager: GlobalSettingsProtocol) {
        self.vc = vc
        self.globalSettingsManager = globalSettingsManager
        
        self.toggleSettingsList = generateToggleList()
    }
    
    private func generateToggleList() -> [SettingsToggleCellDataModel] {
        return [SettingsToggleCellDataModel(titleName: StringConstants.settings_canRecordTitle(),
                                            subtitleName: StringConstants.settings_canRecordBody(),
                                            settingsProperty: globalSettingsManager.canRecordScreen,
                                            toggleClosure: { switchValue in self.globalSettingsManager.canRecordScreen = switchValue
                                            // Post a notification
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: CanRecordNotificationName), object: switchValue)}),
                SettingsToggleCellDataModel(titleName: StringConstants.settings_notificationEnabledTitle(),
                                            subtitleName: StringConstants.settings_notificationEnabledBody(),
                                            settingsProperty: globalSettingsManager.isNotificationEnabled,
                                            toggleClosure: { switchValue in self.globalSettingsManager.isNotificationEnabled = switchValue})
        ]
    }
}
