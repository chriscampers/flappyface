//
//  UIView+Utils.swift
//  FlappyHead
//
//  Created by Chris Campanelli on 2022-01-02.
//

import Foundation
import UIKit

extension UIViewController {
    func addOverlayView() -> UIView {
        let overlayView = UIView(frame: self.view.frame)
        overlayView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
        self.view.addSubview(overlayView)
        return overlayView
    }
}
