//
//  PermissionsManager.swift
//  FlappyHead
//
//  Created by Chris Campanelli on 2022-01-06.
//

import Foundation
import AVFoundation
import UIKit

protocol CameraPermissionsManager {
    
}

class PermissionsManager {
    static let shared = PermissionsManager()
    
    init() {
    }
    
    func openAppSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                  options: [:],
                                  completionHandler: nil)
    }
}
    
extension PermissionsManager: CameraPermissionsManager {
    func promptForCameraPermissionsIfNeeded() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .authorized, .notDetermined:
            // User has already accepted camera permissions or it might be
            // their first time in the app
            break
        case .restricted, .denied:
            presentCameraPermissionScreen()
        @unknown default:
            // TODO: Log error
            break
        }
    }
    
    func isCameraAuthorizeOrWaitingAutorization() -> Bool {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        return cameraAuthorizationStatus == .authorized
            || cameraAuthorizationStatus == .notDetermined
    }
    
    func presentCameraPermissionScreen() {
        let vc = PermissionPromptViewController()
        vc.permissionType = .camera
        UIApplication.shared.keyWindow?.rootViewController?.present(vc,
                                                                    animated: true,
                                                                    completion: { return })
    }
}
