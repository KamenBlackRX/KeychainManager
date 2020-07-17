//
//  CSTextField.swift
//  CSTextField
//
//  Created by Jefferson Barbosa Puchalski on 16/07/20.
//  Copyright © 2020 UOL. All rights reserved.
//

import UIKit
import Combine

class CSTextField: UITextField {
    
    @IBInspectable var isSecure: Bool {
        didSet{
            self.isSecureTextEntry(self.isSecure)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func isSecureTextEntry(_ isSecure: Bool,
                                  eyeClosed: UIImage = UIImage(named: "btn_eye_closed") ?? UIImage(),
                                  eyeOpenImage: UIImage = UIImage(named: "btn_eye_open") ?? UIImage(),
                                  closeImage: UIImage = UIImage(named: "ico_textField_back") ?? UIImage()) {
        if isSecure {
            addButtonAction(eyeOpenImage) { (_) in
                _ = self.resignFirstResponder()
                self.isSecureTextEntry = !self.isSecureTextEntry
                let temp = self.text
                _ = self.becomeFirstResponder()
                
                let imageMask = self.isSecureTextEntry ? eyeOpenImage : eyeCloseImage
                self.accessoryButton.setImage(imageMask, for: .normal)
                self.text = nil
                self.text = temp
            }
        } else {
            addButtonAction(closeImage) { (_) in
                self.text?.removeAll()
                self.status = .selected
                _ = self.becomeFirstResponder()
            }
        }
    }
    
    public func setButtonAction(_ sender: CustomButton) {
        let closeImage = UIImageView.getImage(named: "ico_textField_back", viewController: CSTextField.self)
        addButtonAction(closeImage) { (_) in
            self.text?.removeAll()
            self.status = .selected
            _ = self.becomeFirstResponder()
            sender.setDisableButton()
        }
    }
    
    override public func addSubviews() {
        super.addSubviews()
        self.addSubview(imageView)
        addConstraintForAccessoryView()
    }
    
    override public func didChangeStatus(_ status: DefaultTextField.Status) {
        super.didChangeStatus(status)
        imageView.setState(status)
    }
}
