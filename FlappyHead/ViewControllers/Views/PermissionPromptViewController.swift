//
//  PermissionPromptViewController.swift
//  FlappyHead
//
//  Created by Chris Campanelli on 2022-01-03.
//

import Foundation
import UIKit
import ISHPermissionKit

class PermissionPromptViewController: UIViewController {
    enum PermissionType: String {
        case camera
        case recording
    }
    @IBOutlet weak var permissionIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var positiveButton: UIButton!
    @IBOutlet weak var negativeButton: UIButton!
    var permissionType: PermissionType!
    
    override func viewDidLoad() {
        // Prevent swipe down dismissal
        isModalInPresentation = true
        
        switch permissionType {
        case .camera:
            permissionIcon.image = UIImage(systemName: "camera")
            titleLabel.text = StringConstants.cameraPermissionsPrompt_title()
            bodyLabel.text = StringConstants.cameraPermissionsPrompt_body()
            negativeButton.isHidden = true
        case .recording:
            permissionIcon.image = UIImage(systemName: "video.circle")
        case .none:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch permissionType {
        case .camera:
            if PermissionsManager.shared.isCameraAuthorizeOrWaitingAutorization() {
                dismiss(animated: true, completion: nil)
            }
        case .recording:
            break
        case .none:
            break
        }
    }
    
    @IBAction func positiveButtonPressed(_ sender: Any) {
        switch permissionType {
        case .camera:
            PermissionsManager.shared.openAppSettings()
        case .recording:
            break
        case .none:
            break
        }
    }
    
    @IBAction func negativeButtonPressed(_ sender: Any) {
    }
    
}
