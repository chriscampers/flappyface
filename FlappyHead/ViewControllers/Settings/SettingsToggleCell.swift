//
//  SettingsToggleCell.swift
//  FlappyHead
//
//  Created by Chris Campanelli on 2022-01-10.
//

import Foundation
import UIKit

class SettingsToggleCell: UITableViewCell {
    let id: String = "SettingsToggleCell"
    let toggle: UISwitch!
    
    var cellModel: SettingsToggleCellDataModel!
    
    init(cellModel: SettingsToggleCellDataModel) {
        self.toggle = UISwitch(frame: .zero)
        self.cellModel = cellModel
        super.init(style: .subtitle, reuseIdentifier: id)
        
        self.accessoryView = toggle
        
        toggle.addTarget(self, action: #selector(toggleChanged), for: UIControl.Event.valueChanged)
        toggle.setOn(cellModel.settingsProperty, animated: false)
        
        self.textLabel?.text = cellModel.titleName
        self.detailTextLabel?.text = cellModel.subtitleName
        self.detailTextLabel?.isHidden = false
        self.detailTextLabel?.numberOfLines = 0
        
        if cellModel.titleName == StringConstants.settings_canRecordTitle() {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(cameraCanRecordNotification),
                                                   name: NSNotification.Name(rawValue: CanRecordNotificationName),
                                                   object: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    @objc func toggleChanged(mySwitch: UISwitch) {
        cellModel.toggleClosure(mySwitch.isOn)
        mySwitch.setOn(mySwitch.isOn, animated: true)
    }
 
    @objc private func cameraCanRecordNotification() {
        toggle.isOn = GameSettingManager.shared.canRecordScreen
    }
}
