//
//  MockGameManager.swift
//  FlappyHeadTests
//
//  Created by Chris Campanelli on 2022-01-16.
//

import Foundation
@testable import FlappyFace

class MockGameManager: GameManager {
    
}

class MockGameManagerDelegate: GameManagerDelegate {
    var currentActionChangedWasCalled = false
    func currentActionChanged(newActionName: String) {
        currentActionChangedWasCalled = true
    }
    
    var displayFullScreenAdWasCalled = false
    func displayFullScreenAd() {
        displayFullScreenAdWasCalled = true
    }
    
    var displayExtraLifePromptWasCalled = false
    func displayExtraLifePromp() {
        displayExtraLifePromptWasCalled = true
    }
    
    var gameHasEndedWasCalled = false
    func gameHasEnded() {
        gameHasEndedWasCalled = true
    }
    
    
}
