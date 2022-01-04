//
//  ViewController.swift
//  FaceTriggerExample
//
//  Created by Mike Peterson on 12/26/17.
//  Copyright © 2017 Blinkloop. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds
import ReplayKit
import ISHPermissionKit

class MainGameViewController: UIViewController {

    @IBOutlet var previewContainer: UIView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet var logTextView: UIView!
    var overlayView: UIView!
    var promptViewController: ModalPromptViewController!
    var gameScene: GameScene!
    var shareImageInstagram = ShareImageInstagram.shared

    let gameSettingsManager = GameSettingManager.shared
    var gamePlayManager: GamePlayManagerProtocol = GameManager.shared
    var gameManagerMechanics: GameManagerMechanicsProtocol = GameManager.shared
    var faceTrigger: FaceTrigger?
    var bird: BirdMovingDelegate?

    var bannerView: GADBannerView!
    var rewardedAd: GADRewardedAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamePlayManager.delegate = self
        shareImageInstagram.delegate = self
        actionLabel.text = " " + gamePlayManager.currentFacialActionName() + " "
        loadOrReloadLevel()
        setupNotifications()
        
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
        
        bannerView.delegate = self
        
        loadRewardAd()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(startRecording))
    
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        faceTrigger = FaceTrigger(hostView: previewContainer, delegate: self)
        faceTrigger?.start()
    }
    
    func loadRewardAd() {
        let adRequest = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-8448074232552599/6210888855", request: adRequest, completionHandler:  { (ad, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                self.rewardedAd = ad
                print("reward loaded")
                self.rewardedAd.fullScreenContentDelegate = self
            }
            
        })
        
    }
    
    func showRewardAd() {
        if rewardedAd != nil {
            rewardedAd.present(fromRootViewController: self, userDidEarnRewardHandler: {
                // todo: let user restart from samespot
            })
        }
    }
    
    func addPromptView() {
        // setup overlay
        overlayView = addOverlayView()
        
        // setup prompt
        promptViewController = ModalPromptViewController(photo: "test")
        promptViewController.delegate = self
        
        view.addSubview(promptViewController.view)
        promptViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(
            [NSLayoutConstraint(item: promptViewController.view as Any,
                              attribute: .centerY,
                              relatedBy: .equal,
                                toItem: view,
                              attribute: .centerY,
                              multiplier: 1,
                              constant: 0),
             NSLayoutConstraint(item: promptViewController.view as Any,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: previewContainer,
                            attribute: .bottom,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
     }
    
    @objc private func pause() {
        faceTrigger?.pause()
    }
    
    @objc private func unpause() {
        faceTrigger?.unpause()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(pause), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unpause), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    private func loadOrReloadLevel() {
        gameScene = GameScene.unarchiveFromFile("GameScene") as! GameScene
        // Configure the view.
        let skView = self.logTextView as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        gameScene.scaleMode = .aspectFill
        
        skView.presentScene(gameScene)
        
        bird = gameScene
    }
}

extension MainGameViewController: FaceTriggerDelegate {
    // MARK: Smile
    func onSmileDidChange(smiling: Bool) {}
    func onSmile() {
        if gameManagerMechanics.isFacialActionValid(action: .smile) {
            callMoveBird()
        }
    }
    
    // MARK: Left blink
    func onBlinkLeftDidChange(blinkingLeft: Bool) {}
    func onBlinkLeft() {
        if gameManagerMechanics.isFacialActionValid(action: .leftWink) {
            callMoveBird()
        }
    }
    
    // MARK: Right blink
    func onBlinkRightDidChange(blinkingRight: Bool) {}
    func onBlinkRight() {
        if gameManagerMechanics.isFacialActionValid(action: .rightWink) {
            callMoveBird()
        }
    }
    
    // MARK: Full Blink
    func onBlinkDidChange(blinking: Bool) {}
    func onBlink() {
        if gameManagerMechanics.isFacialActionValid(action: .blink) {
            callMoveBird()
        }
    }
    
    // MARK: Eyebrows
    func onBrowDownDidChange(browDown: Bool) {}
    func onBrowDown() {}
    
    func onBrowUpDidChange(browUp: Bool) {}
    func onBrowUp() {}
    
    // MARK: Cheek Puffing
    func onCheekPuffDidChange(cheekPuffing: Bool) {}
    func onCheekPuff() {
        if gameManagerMechanics.isFacialActionValid(action: .puffyFace) {
            callMoveBird()
        }
    }
    
    // MARK: Kissy Lips
    func onMouthPuckerDidChange(mouthPuckering: Bool) {}
    func onMouthPucker() {
        if gameManagerMechanics.isFacialActionValid(action: .kissyFace) {
            callMoveBird()
        }
    }
    
    // MARK: Jaw
    func onJawOpenDidChange(jawOpening: Bool) {}
    func onJawOpen() {}
    
    func onJawLeftDidChange(jawLefting: Bool) {}
    func onJawLeft() {}
    
    func onJawRightDidChange(jawRighting: Bool) {}
    func onJawRight() {}
    
    // MARK: Squint
    func onSquintDidChange(squinting: Bool) {}
    func onSquint() {}
    
    private func callMoveBird() {
        if gamePlayManager.gameState.status != .inProgress {
            startRecording()
        }
        bird?.moveBird()
    }
}

extension MainGameViewController: GameManagerDelegate {
    func displayFullScreenAd() {
//        showRewardAd()
    }
    
    func displayExtraLifePromptIfNeeded() {
        if Bool.random() {
            addPromptView()
        } else {
            gameScene.registerEndOfGame()
        }
    }
    
    func currentActionChanged(newActionName: String) {
        DispatchQueue.main.async {
            self.actionLabel.text = " " + self.gamePlayManager.currentFacialActionName() + " "
        }
    }
}

extension MainGameViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
}

extension MainGameViewController: GADFullScreenContentDelegate {
    
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

extension MainGameViewController: ISHPermissionsViewControllerDataSource {
    func permissionsViewController(_ vc: ISHPermissionsViewController, requestViewControllerFor category: ISHPermissionCategory) -> ISHPermissionRequestViewController {
        return ISHPermissionRequestViewController()
    }


}

extension MainGameViewController: ModalPromptDelegate {
    private func promptPermissions() {
        let permissions = [ISHPermissionCategory.photoCamera.rawValue as! NSNumber]
        let permissionVc = ISHPermissionsViewController(categories: permissions, dataSource: self)!
        present(permissionVc, animated: true, completion: { return })
    }
    
    func reasonForDimissing(reason: ModalPromptViewController.ReasonForClosing) {
        removeOverlayAndPromptFromView()
        promptPermissions()
        
        if reason == .watched {
            showRewardAd()
        }
        
        if reason == .cancel {
            stopRecording()
            gameScene.registerEndOfGame()
            shareImageInstagram.postToStories(image: captureScreen(), backgroundTopColorHex: "", backgroundBottomColorHex: "", deepLink: "")
        }
    }
    
    func captureScreen() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, 0)

        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)


        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func removeOverlayAndPromptFromView() {
        promptViewController.view.removeFromSuperview()
        overlayView.removeFromSuperview()
    }
    
}

extension MainGameViewController: ShareStoriesDelegate {
    func error(message: String) {
        print("error")
    }

    func success() {
        print("Success")
    }
}

extension MainGameViewController: RPPreviewViewControllerDelegate {
    @objc func startRecording() {
            let recorder = RPScreenRecorder.shared()

            recorder.startRecording{ [unowned self] (error) in
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                } else {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(self.stopRecording))
                }
            }
        }

        @objc func stopRecording() {
            let recorder = RPScreenRecorder.shared()

            recorder.stopRecording { [unowned self] (preview, error) in
                if let unwrappedPreview = preview {
                    unwrappedPreview.previewControllerDelegate = self
                    self.present(unwrappedPreview, animated: true)
                }
            }
        }

        func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
            dismiss(animated: true)
        }
}
