//
//  ViewController.swift
//  FlickFindr
//
//  Created by gem on 7/17/17.
//  Copyright © 2017 beau. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var keyboardOnScreen = false
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var flickrImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
//    var latitudeValue: Double? {
//        return Double(latitudeField.text!) ?? nil
//    }
//    var longitudeValue: Double? {
//        return Double(longitudeField.text!) ?? nil
//    }
    @IBAction func latLonSearched(_ sender:
        UIButton) {
    }
    @IBOutlet weak var searchField: UITextField!
    @IBAction func termSearched(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates(fields: searchField, latitudeField, longitudeField)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(userTappedView(_:)))
        view.addGestureRecognizer(tapRecognizer)
        subscribeTo([
            .UIKeyboardWillHide: #selector(keyboardWillHide),
            .UIKeyboardWillShow: #selector(keyboardWillShow),
            .UIKeyboardDidShow: #selector(keyboardDidShow),
            .UIKeyboardDidHide: #selector(keyboardDidHide)
            ])
    }

    @objc func userTappedView(_ sender: UITapGestureRecognizer) {
        print(#function)
        resignIfFirstResponder(latitudeField)
        resignIfFirstResponder(longitudeField)
        resignIfFirstResponder(searchField)
    }

    // MARK: Notifications
    func subscribeTo(_ notification: [NSNotification.Name: Selector]) {
        for (notificationName,functionToRun) in notification {
            NotificationCenter.default.addObserver(self, selector: functionToRun, name: notificationName, object: nil)
        }
        
    }
    func unsubscribeFrom(_ notification: Notification?) {
        if let notification = notification {
            NotificationCenter.default.removeObserver(notification)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }

}
// MARK: Textfield delegation
extension ViewController: UITextFieldDelegate {
    func setDelegates(fields: UITextField...) {
        print(#function)
        for field in fields {
            field.delegate = self
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#function)
        textField.resignFirstResponder()
        return true
    }
    func resignIfFirstResponder(_ textField: UITextField) {
        print(#function)
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    func checkFor(value: Double, inRange range: (Double,Double)) -> Bool {
        return !(value < range.0 || value > range.1)
    }
    func isTextValid(_ textField: UITextField, forRange range: (Double, Double)) -> Bool {
        guard !textField.text!.isEmpty else { return false }
        if let value = Double(textField.text!) {
            return checkFor(value: value, inRange: (range.0, range.1))
        } else {
            return false
        }
    }
    
    
    // MARK: Show/Hide Keyboard
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        print(#function)
        if !keyboardOnScreen {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        print(#function)
        if keyboardOnScreen {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    @objc func keyboardDidHide(_ notification: Notification) {
        print(#function)
        keyboardOnScreen = false
    }
    @objc func keyboardDidShow(_ notification: Notification) {
        print(#function)
        keyboardOnScreen = true
    }
    
}
