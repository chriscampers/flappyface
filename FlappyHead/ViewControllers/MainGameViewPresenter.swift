//
//  MainGameViewPresenter.swift
//  FlappyHead
//
//  Created by Chris Campanelli on 2022-01-04.
//

import Foundation
import GoogleMobileAds

protocol MainGameViewPresenterProtocol: AnyObject {
    func facialJestureActionOccured(action: FaceTrackingAction)
}

class MainGameViewPresenter: NSObject, MainGameViewPresenterProtocol {
    private var viewController: MainGameViewController!
    private var gameManagerMechanics: GameManagerMechanicsProtocol!
    private var gamePlayManager: GamePlayManagerProtocol!
    private var gameSettingsManager: GameSettingManager!
    private var instagramSharingManager = InstagramSharingManager.shared
    
    init(viewController: MainGameViewController,
         gameManagerMechanics: GameManagerMechanicsProtocol,
         gamePlayManager: GamePlayManagerProtocol,
         gameSettingsManager: GameSettingManager,
         instagramSharingManager: InstagramSharingManager,
         gameScene: GameScene) {
        super.init()
        
        self.viewController = viewController
        self.gameManagerMechanics = gameManagerMechanics
        self.gamePlayManager = gamePlayManager
        self.gameSettingsManager = gameSettingsManager
        self.instagramSharingManager = instagramSharingManager
        self.gamePlayManager.gameScene = gameScene
        
        // setup delegates
        self.gamePlayManager.delegate = self
        self.instagramSharingManager.delegate = self

        downloadFullScreenRewardAd()
    }
    
    func facialJestureActionOccured(action: FaceTrackingAction) {
        if !gameManagerMechanics.isFacialActionValid(action: action) {
            return
        }
        
        userTriggeredBirdMovement()
    }
    
    func downloadFullScreenRewardAd() {
        let adRequest = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-8448074232552599/6210888855", request: adRequest, completionHandler:  { (ad, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                self.viewController.rewardedAd = ad
                print("reward loaded")
                self.viewController.rewardedAd?.fullScreenContentDelegate = self
            }
        })
    }
    
    private func userTriggeredBirdMovement() {
        if gameSettingsManager.canRecordScreen {
            viewController.startRecording()
        }
        
        gamePlayManager.moveGameCharacter()
    }
}

extension MainGameViewPresenter: GameManagerDelegate {
    func displayFullScreenAd() {
//        showRewardAd()
    }
    
    func displayExtraLifePromptIfNeeded() {
        // TODO: this should not be a IfNeeded call, game manager should decide if prompt is displayed or not
        // displayExtraLifePrompt should be the function name. And this logic should be moved
        if Bool.random() {
            viewController.addPromptView()
            viewController.promptViewController.delegate = self
        } else {
            gamePlayManager.endGame()
        }
    }
    
    func currentActionChanged(newActionName: String) {
        // Yolo, same as above, this sucks!
        DispatchQueue.main.async {
            self.viewController.actionLabel.text = " " + self.gamePlayManager.currentFacialActionName() + " "
        }
    }
}

extension MainGameViewPresenter: GADFullScreenContentDelegate {
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        print("adDidRecordClick")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adDidDismissFullScreenContent")
    }
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("adDidRecordImpression")
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error)")
        print(error.localizedDescription)
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
        print("adWillDismissFullScreenContent")
    }
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adDidPresentFullScreenContent")
    }
}

extension MainGameViewPresenter: ModalPromptDelegate {
    private func promptPermissions() {
//        let permissions = [ISHPermissionCategory.photoCamera.rawValue as! NSNumber]
        let vc = PermissionPromptViewController()
        vc.permissionType = .camera
        viewController.present(vc, animated: true, completion: { return })
    }
    
    func reasonForDimissing(reason: ModalPromptViewController.ReasonForClosing) {
        removeOverlayAndPromptFromView()
        gamePlayManager.endGame()
        
        if reason == .okayBtn {
            viewController.showRewardAd()
        }
        
        if reason == .cancel {
            // TODO: Remove promptPermissions down the line
            promptPermissions()
            viewController.stopRecording()
            gamePlayManager.endGame()
            instagramSharingManager.postToStories(image: captureScreen(),
                                                  backgroundTopColorHex: "",
                                                  backgroundBottomColorHex: "",
                                                  deepLink: "")
        }
    }
    
    func captureScreen() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.viewController.view.bounds.size, true, 0)
        self.viewController.view.drawHierarchy(in: self.viewController.view.bounds, afterScreenUpdates: true)


        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func removeOverlayAndPromptFromView() {
        viewController.promptViewController.view.removeFromSuperview()
        viewController.overlayView.removeFromSuperview()
    }
    
}

extension MainGameViewPresenter: InstagramSharingDelegate {
    func error(message: String) {
        print("error")
    }

    func success() {
        print("Success")
    }
}
