//
//  PermissionPromptViewController.swift
//  FlappyHead
//
//  Created by Chris Campanelli on 2022-01-03.
//

import Foundation
import UIKit
import ISHPermissionKit
import L10n_swift

class PermissionPromptViewController: UIViewController {
    enum PermissionType: String {
        case camera
        case recording
    }
    @IBOutlet weak var permissionIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var permissionType: PermissionType!
    
    override func viewDidLoad() {
        // TODO: set text
        switch permissionType {
        case .camera:
            permissionIcon.image = UIImage(systemName: "camera")
            titleLabel.text = "Camera Permissions".l10n()
            bodyLabel.text = "test pizza test".l10n()
        case .recording:
            permissionIcon.image = UIImage(systemName: "video.circle")
        case .none:
            break
        }
    }
    
    @IBAction func allowButtonPressed(_ sender: Any) {
    }
    
    @IBAction func dontAskButtonPressed(_ sender: Any) {
    }
    
    @IBAction func laterButtonPressed(_ sender: Any) {
    }
}
