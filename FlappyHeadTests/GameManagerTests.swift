//
//  GameManagerTests.swift
//  FlappyHeadTests
//
//  Created by Chris Campanelli on 2022-01-16.
//

import XCTest
@testable import FlappyFace

class GameManagerTests: XCTestCase {

    var mockGameManager: MockGameManager!
    var mockGameManagerDelegate: MockGameManagerDelegate!
    
    override func setUp() {
        mockGameManager = MockGameManager()
        mockGameManagerDelegate = MockGameManagerDelegate()
        
        mockGameManager.delegate = mockGameManagerDelegate
    }

    override func tearDownWithError() throws {

    }

    func testIsFacialActionValid() throws {
        mockGameManager.gameState.currentAction = .blink
        XCTAssertTrue(mockGameManager.isFacialActionValid(action: .blink))
        XCTAssertFalse(mockGameManager.isFacialActionValid(action: .kissyFace))
    }

    func testDurrentFacialActionName() throws {
        mockGameManager.gameState.currentAction = .blink
        mockGameManager.gameState.numberOfCurretActionsRemaining = 3
        XCTAssertTrue(mockGameManager.currentFacialActionName() == "Blink x3")
    }
    
    func testResumeGameState() {
        mockGameManager.gameState.status = .pause
        mockGameManager.resumeGame()
        XCTAssertTrue(mockGameManager.gameState.status == .inProgress)
    }
    
    func testGamePause() {
        mockGameManager.pauseGame(causedByUserCrash: false)
        XCTAssertTrue(mockGameManagerDelegate.gameHasEndedWasCalled)
    }
    
    func testRestartGame() {
        mockGameManager.restartGame()
        XCTAssertTrue(mockGameManager.gameState.status == .inProgress)
    }
    
    func testMoveGameCharacter() {
        // try moving character in pause state
        mockGameManager.gameState.status = .pause
        mockGameManager.gameState.currentAction = .blink
        mockGameManager.gameState.numberOfCurretActionsRemaining = 3
        mockGameManager.moveGameCharacter()
        XCTAssertTrue(mockGameManager.gameState.numberOfCurretActionsRemaining == 3)
        
        // try moving character when game is in progress
        mockGameManager.gameState.status = .inProgress
        mockGameManager.moveGameCharacter()
        XCTAssertTrue(mockGameManager.gameState.numberOfCurretActionsRemaining == 2)
    }

}
