//
//  GameManager.swift
//  FlappyHead
//
//  Created by Chris Campanelli on 2021-08-23.
//

import Foundation

protocol GamePlayManagerProtocol {
    var delegate: GamePlayManagerDelegate? { get set }
    func currentFacialActionName() -> String
    func isFacialActionValid(action: FaceTrackingAction) -> Bool
    func roundEnded(score: Int)
    
}

protocol GamePlayManagerDelegate {
    func currentActionChanged(newActionName: String)
    func displayFullScreenAd()
}

enum FaceTrackingAction: String {
    case leftWink = "Left Wink"
    case rightWink = "Right Wink"
    case blink = "Blink"
    case smile = "Smile"
    case puffyFace = "Puffy Face"
    case kissyFace = "Kissy Face"
}

class GameManager: GamePlayManagerProtocol {
    
    static let shared = GameManager()
    
    var delegate: GamePlayManagerDelegate?
    private var numberOfActions = 3
    private var currentIndex: Int = 0
    private var validActionList: [FaceTrackingAction] = [.leftWink,
                                                         .rightWink,
                                                         .blink,
                                                         .smile,
                                                         .puffyFace]
    
 
    func isFacialActionValid(action: FaceTrackingAction) -> Bool {
        if action == validActionList[currentIndex] {
            numberOfActions = numberOfActions - 1
            if numberOfActions <= 0 {
                numberOfActions = 3
                currentIndex = generateRandomNumber()
            }

            delegate?.currentActionChanged(newActionName: validActionList[currentIndex].rawValue)
            return true
        }
        return false
    }
    
    func currentFacialActionName() -> String {
        return validActionList[currentIndex].rawValue + " x" + String(numberOfActions)
    }
    
    func roundEnded(score: Int) {
        resetGameVars()
        delegate?.displayFullScreenAd()
    }
    
    private func resetGameVars() {
        numberOfActions = 3
        currentIndex = 0
    }
    
    private func generateRandomNumber() -> Int {
        return Int.random(in: 0..<validActionList.count)
    }
}
