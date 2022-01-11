//
//  SettingsViewController.swift
//  FlappyHead
//
//  Created by Chris Campanelli on 2022-01-10.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    private var presenter: SettingsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        presenter = SettingsPresenter.init(vc: self,
                                           globalSettingsManager: GameSettingManager.shared)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.toggleSettingsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataModal = presenter.toggleSettingsList[indexPath.row]
        return SettingsToggleCell(cellModel: dataModal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
}
