//
//  FlickrVC+Keyboard.swift
//  FlickFindr
//
//  Created by gem on 7/18/17.
//  Copyright © 2017 beau. All rights reserved.
//

import Foundation
import UIKit
extension FlickrVC {
    // MARK: Show/Hide Keyboard
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    @objc func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    @objc func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
}
