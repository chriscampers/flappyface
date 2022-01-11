//
//  MainGameViewController+Extensions.swift
//  FlappyHead
//
//  Created by Chris Campanelli on 2022-01-04.
//

import Foundation
import GoogleMobileAds
import ISHPermissionKit
import ReplayKit

extension MainGameViewController: FaceTriggerDelegate {
    // MARK: Smile
    func onSmileDidChange(smiling: Bool) {}
    func onSmile() {
        let vc = SettingsViewController.init(style: .plain)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }

        presenter.facialJestureActionOccured(action: .smile)
    }
    
    // MARK: Left blink
    func onBlinkLeftDidChange(blinkingLeft: Bool) {}
    func onBlinkLeft() {
        presenter.facialJestureActionOccured(action: .leftWink)
    }
    
    // MARK: Right blink
    func onBlinkRightDidChange(blinkingRight: Bool) {}
    func onBlinkRight() {
        presenter.facialJestureActionOccured(action: .rightWink)
    }
    
    // MARK: Full Blink
    func onBlinkDidChange(blinking: Bool) {}
    func onBlink() {
        presenter.facialJestureActionOccured(action: .blink)
    }
    
    // MARK: Eyebrows
    func onBrowDownDidChange(browDown: Bool) {}
    func onBrowDown() {}
    
    func onBrowUpDidChange(browUp: Bool) {}
    func onBrowUp() {}
    
    // MARK: Cheek Puffing
    func onCheekPuffDidChange(cheekPuffing: Bool) {}
    func onCheekPuff() {
        presenter.facialJestureActionOccured(action: .puffyFace)
    }
    
    // MARK: Kissy Lips
    func onMouthPuckerDidChange(mouthPuckering: Bool) {}
    func onMouthPucker() {
        presenter.facialJestureActionOccured(action: .kissyFace)
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

/// Extension to record screen video
extension MainGameViewController: RPPreviewViewControllerDelegate {
    @objc func startRecording() {
            let recorder = RPScreenRecorder.shared()
            recorder.startRecording{ (error) in
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                } else {
                    // TODO: what todo here?
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
