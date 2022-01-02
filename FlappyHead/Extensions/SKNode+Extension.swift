//
//  SKNodeExtension.swift
//  FaceTriggerExample
//
//  Created by Chris Campanelli on 2021-08-22.
//  Copyright © 2021 Blinkloop. All rights reserved.
//

import Foundation
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(_ file : String) -> SKNode? {
        let path = Bundle.main.path(forResource: file, ofType: "sks")
        
        let sceneData: Data?
        do {
            sceneData = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        } catch _ {
            sceneData = nil
        }
        let archiver = NSKeyedUnarchiver(forReadingWith: sceneData!)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
        archiver.finishDecoding()
        return scene
    }
}
