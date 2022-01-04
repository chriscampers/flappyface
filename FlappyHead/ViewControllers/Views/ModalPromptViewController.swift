//
//  ModalPromptViewController.swift
//  FlappyHead
//
//  Created by Chris Campanelli on 2022-01-02.
//

import Foundation
import UIKit

protocol ModalPromptDelegate {
    func reasonForDimissing(reason: ModalPromptViewController.ReasonForClosing)
}
class ModalPromptViewController: UIViewController {
    enum ReasonForClosing {
        case cancel
        case watched
        case other
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var okayBtn: UIButton!
    
    var photo: String?
    var delegate: ModalPromptDelegate?
    
    init(photo: String) {
        self.photo = photo
        super.init(nibName: "ModalPromptViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBAction func okayBtnAction(_ sender: Any) {
        delegate?.reasonForDimissing(reason: .watched)
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        delegate?.reasonForDimissing(reason: .cancel)
    }
    //    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}
