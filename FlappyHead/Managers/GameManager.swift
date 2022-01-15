//
//  GameManager.swift
//  FlappyHead
//
//  Created by Chris Campanelli on 2021-08-23.
//

import Foundation

enum GameStatus {
    case inProgress
    case over
    case pause
}

protocol GamePlayManagerProtocol {
    var delegate: GameManagerDelegate? { get set }
    var gameScene: GameSceneProtocol? { get set }
    var gameState: GameState { get set }
    
    ///  endGame
    ///
    ///  can occure by natural gameplay like a crash, without a user getting prompted for an extra life
    ///  or it can occure by a user action eg. canceling an opportunity for an extra life from the pause state etc.
    func endGame()
    
    func restartGame()
    func resumeGame()
    func pauseGame(causedByUserCrash: Bool)
    func currentFacialActionName() -> String
    func canShowPrompt() -> Bool
    func moveGameCharacter()
}

protocol GameManagerMechanicsProtocol {
    func isFacialActionValid(action: FaceTrackingAction) -> Bool
}

protocol GameManagerDelegate {
    func currentActionChanged(newActionName: String)
    func displayFullScreenAd()
    func displayExtraLifePromp()
    func gameHasEnded()
}

enum FaceTrackingAction: String {
    case leftWink = "Left Wink"
    case rightWink = "Right Wink"
    case blink = "Blink"
    case smile = "Smile"
    case puffyFace = "Puffy Face"
    case kissyFace = "Kissy Face"
}

struct GameState {
    var status: GameStatus = .over
    
    // number of pipes users has gone through
    var score: Int = 0
    
    // number of lifes the user has left
    var lifes: Int = 0
    
    // the facial action the users
    var currentAction: FaceTrackingAction = .blink
    
    // self explanitory
    var numberOfCurretActionsRemaining = 0
    
    var isGameInProgress: Bool {
        return status == .inProgress
    }
}

class GameManager: GamePlayManagerProtocol, GameManagerMechanicsProtocol {
    static let shared = GameManager()
    
    var gameScene: GameSceneProtocol?
    var delegate: GameManagerDelegate?
    var gameState: GameState = .init(status: .inProgress)
    private var validActionList: [FaceTrackingAction] = [.leftWink,
                                                         .rightWink,
                                                         .blink,
                                                         .smile,
                                                         .puffyFace]
    
 
    func isFacialActionValid(action: FaceTrackingAction) -> Bool {
        return action == gameState.currentAction
    }
    
    func currentFacialActionName() -> String {
        return gameState.currentAction.rawValue + " x" + String(gameState.numberOfCurretActionsRemaining)
    }
    
    func endGame() {
        // todo: as
        delegate?.gameHasEnded()
        gameScene?.registerEndOfGame()
        gameState.status = .over
        resetGameStateVars()
    }
    
    func restartGame() {
        gameState.status = .inProgress 
    }
    
    func pauseGame(causedByUserCrash: Bool = true) {
        gameState.status = .pause
        if causedByUserCrash && canShowPrompt() {
            delegate?.displayExtraLifePromp()
        } else {
            // Game must be over, since there is nothing else to do
            endGame()
            delegate?.gameHasEnded()
        }

    }
    
    func resumeGame() {
        gameState.status = .inProgress
    }
    
    func canShowPrompt() -> Bool{
        return Bool.random()
    }
    
    func moveGameCharacter() {
        if gameState.status == .pause {
            return
        }
        
        gameScene?.moveUserCharacter()
        updateGameStateFromMovement()
    }
    
    private func updateGameStateFromMovement() {
        gameState.numberOfCurretActionsRemaining = gameState.numberOfCurretActionsRemaining - 1

        if gameState.numberOfCurretActionsRemaining <= 0 {
            gameState.numberOfCurretActionsRemaining = 3
            gameState.currentAction = generateRandomAction()
        }

        delegate?.currentActionChanged(newActionName: gameState.currentAction.rawValue)
    }
    
    private func resetGameStateVars() {
        gameState.numberOfCurretActionsRemaining = 3
        gameState.currentAction = generateRandomAction()
        gameState.score = 0
        
        delegate?.currentActionChanged(newActionName: gameState.currentAction.rawValue)
    }
    
    private func generateRandomAction() -> FaceTrackingAction {
        return validActionList[Int.random(in: 0..<validActionList.count)]
    }
}
