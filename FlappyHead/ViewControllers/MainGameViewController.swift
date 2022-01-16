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
import ISHPermissionKit

let CanRecordNotificationName = "canRecordNotificationName"

class MainGameViewController: UIViewController {
    @IBOutlet var previewContainer: UIView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet var logTextView: UIView!
    var overlayView: UIView!
    var promptViewController: ModalPromptViewController!

    let gameSettingsManager = GameSettingManager.shared
    var gamePlayManager: GamePlayManagerProtocol = GameManager.shared
    var gameManagerMechanics: GameManagerMechanicsProtocol = GameManager.shared
    var presenter: MainGameViewPresenterProtocol!
    var faceTrigger: FaceTrigger?
    
    var bannerView: GADBannerView!
    var rewardedAd: GADRewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // Register to receive notification in your class
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cameraCanRecordNotification),
                                               name: NSNotification.Name(rawValue: CanRecordNotificationName),
                                               object: nil)

        // setup game scene and store it so that it can be passed to the presenter
        let gameScene = loadOrReloadLevel()
        
        presenter = MainGameViewPresenter(viewController: self,
                                          gameManagerMechanics: GameManager.shared,
                                          gamePlayManager: GameManager.shared,
                                          gameSettingsManager: GameSettingManager.shared,
                                          instagramSharingManager: InstagramSharingManager.shared,
                                          gameScene: gameScene)
        
        // setup facetrigger notifications
        setupNotifications()
        
        // what the hell, setup the action label
        actionLabel.text = " " + gamePlayManager.currentFacialActionName() + " "

        navigationItem.rightBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(navBarPressed))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "video"), style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = .clear
    }
    
    @objc private func cameraCanRecordNotification() {
        // TODO: Move logic to presenter
        navigationItem.leftBarButtonItem?.tintColor = gameSettingsManager.canRecordScreen ? .white : .clear
        if gameSettingsManager.canRecordScreen {
            startRecording(completion: nil)
        } else {
            stopRecording(reasonForStop: .thowAwayRecording)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Setup and startup facetrigger once the view has loaded
        faceTrigger = FaceTrigger(hostView: previewContainer, remoteConfigManager: RemoteConfigManager.shared, delegate: self)
        faceTrigger?.start()
        
        PermissionsManager.shared.promptForCameraPermissionsIfNeeded()
    }
    
    func showRewardAd() {
        // present the reward ad only if its been retrived from the server
        rewardedAd?.present(fromRootViewController: self, userDidEarnRewardHandler: {
            // TODO: [FLAP-9] give user extra life
        })
    }
    
    func addPromptView() {
        // setup overlay
        overlayView = addOverlayView()
        
        // setup prompt and add it to the main view
        promptViewController = ModalPromptViewController(photo: "test")
        view.addSubview(promptViewController.view)
        
        // setup prompt constraints
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
    
    private func setupAdBanner() {
        // create banner
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        // add banner to parent
        addBannerViewToView(bannerView)
    }
    
    private func addBannerViewToView(_ bannerView: GADBannerView) {
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
    
    @objc private func navBarPressed() {
        let vc = SettingsViewController.init(style: .insetGrouped)
        navigationController?.pushViewController(vc, animated: true)
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
    
    private func loadOrReloadLevel() -> GameScene {
        let gameScene = GameScene.unarchiveFromFile("GameScene") as! GameScene
        // Configure the view.
        let skView = self.logTextView as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        gameScene.scaleMode = .aspectFill
        
        skView.presentScene(gameScene)
        
        return gameScene
    }
}
