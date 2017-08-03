// MARK: Textfield delegation
import UIKit
extension FlickrVC: UITextFieldDelegate {
    func setDelegates(fields: UITextField...) {
        for field in fields {
            field.delegate = self
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    func checkFor(value: Double, inRange range: (Double,Double)) -> Bool {
        return !(value < range.0 || value > range.1)
    }
    func isTextFieldValid(_ textField: UITextField, forRange range: (Double, Double)) -> Bool {
        guard !textField.text!.isEmpty else { return false }
        if let value = Double(textField.text!) {
            return checkFor(value: value, inRange: (range.0, range.1))
        } else {
            return false
        }
    }
}


