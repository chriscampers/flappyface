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

class MainGameViewController: UIViewController {

    @IBOutlet var previewContainer: UIView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet var logTextView: UIView!

    let gameSettingsManager = GameSettingManager.shared
    var gamePlayManager: GamePlayManagerProtocol = GameManager.shared
    
    var faceTrigger: FaceTrigger?
    var bird: BirdMovingDelegate?
    
    var bannerView: GADBannerView!
    var rewardedAd: GADRewardedAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamePlayManager.delegate = self
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        faceTrigger = FaceTrigger(hostView: previewContainer, delegate: self)
        faceTrigger?.start()
    }
    
    func loadRewardAd() {
        let adRequest = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4806952744", request: adRequest, completionHandler:  { (ad, error) in
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
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: bottomLayoutGuide,
                            attribute: .top,
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
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.logTextView as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
            
            bird = scene
        }
    }
}

extension MainGameViewController: FaceTriggerDelegate {
    // MARK: Smile
    func onSmileDidChange(smiling: Bool) {}
    func onSmile() {
        if gamePlayManager.isFacialActionValid(action: .smile) {
            bird?.moveBird()
        }
    }
    
    // MARK: Left blink
    func onBlinkLeftDidChange(blinkingLeft: Bool) {}
    func onBlinkLeft() {
        if gamePlayManager.isFacialActionValid(action: .leftWink) {
            bird?.moveBird()
        }
    }
    
    // MARK: Right blink
    func onBlinkRightDidChange(blinkingRight: Bool) {}
    func onBlinkRight() {
        if gamePlayManager.isFacialActionValid(action: .rightWink) {
            bird?.moveBird()
        }
    }
    
    // MARK: Full Blink
    func onBlinkDidChange(blinking: Bool) {}
    func onBlink() {
        if gamePlayManager.isFacialActionValid(action: .blink) {
            bird?.moveBird()
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
        if gamePlayManager.isFacialActionValid(action: .puffyFace) {
            bird?.moveBird()
        }
    }
    
    // MARK: Kissy Lips
    func onMouthPuckerDidChange(mouthPuckering: Bool) {}
    func onMouthPucker() {
        if gamePlayManager.isFacialActionValid(action: .kissyFace) {
            bird?.moveBird()
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
}

extension MainGameViewController: GamePlayManagerDelegate {
    func displayFullScreenAd() {
        showRewardAd()
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
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
        print("adWillDismissFullScreenContent")
    }
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adDidPresentFullScreenContent")
    }
}
