//
//  ViewController.swift
//  FlickFindr
//
//  Created by gem on 7/17/17.
//  Copyright © 2017 beau. All rights reserved.
//

import UIKit

class FlickrVC: UIViewController {
    var keyboardOnScreen = false
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var flickrImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var latLonSearchButton: UIButton!
    @IBOutlet weak var phraseSearchButton: UIButton!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var phraseTextField: UITextField!
    var longitudeValue: Double {
        get {
            return Double(longitudeTextField.text!) ?? 0.0
        }
    }
    var latitudeValue: Double {
        get {
            return Double(latitudeTextField.text!) ?? 0.0
        }
    }

    @IBAction func latLonSearched(_ sender: UIButton) {
        userTappedView(self)
        setUIEnabled(false)

        
        if isTextFieldValid(latitudeTextField, forRange: Flickr.SearchLatRange) && isTextFieldValid(longitudeTextField, forRange: Flickr.SearchLonRange) {
            titleLabel.text = "Searching..."
            let methodParameters =
                [
                    FlickrParameterKeys.Method: FlickrParameterValues.SearchMethod,
                    FlickrParameterKeys.APIKey: FlickrParameterValues.APIKey,
                    FlickrParameterKeys.GalleryID: FlickrParameterValues.GalleryID,
                    FlickrParameterKeys.SafeSearch: FlickrParameterValues.UseSafeSearch,
                    FlickrParameterKeys.Format: FlickrParameterValues.ResponseFormat,
                    FlickrParameterKeys.NoJSONCallback: FlickrParameterValues.DisableJSONCallback,
                    FlickrParameterKeys.Extras: FlickrParameterValues.MediumURL,
                    FlickrParameterKeys.BoundingBox: bboxString()
            ]
            
            displayImageFromFlickrBySearch(methodParameters as [String : AnyObject])

        }
        else {
            setUIEnabled(true)
            titleLabel.text = "Lat should be [-90, 90].\nLon should be [-180, 180]."
        }
    }
    @IBOutlet weak var searchField: UITextField!
    @IBAction func termSearched(_ sender: UIButton) {
        userTappedView(self)
        setUIEnabled(false)
        
        if !phraseTextField.text!.isEmpty {
            titleLabel.text = "Searching..."
            let methodParameters = [
                FlickrParameterKeys.Method: FlickrParameterValues.SearchMethod,
                FlickrParameterKeys.APIKey: FlickrParameterValues.APIKey,
                FlickrParameterKeys.Text: phraseTextField.text!,
                FlickrParameterKeys.SafeSearch: FlickrParameterValues.UseSafeSearch,
                FlickrParameterKeys.Extras: FlickrParameterValues.MediumURL,
                FlickrParameterKeys.Format: FlickrParameterValues.ResponseFormat,
                FlickrParameterKeys.NoJSONCallback: FlickrParameterValues.DisableJSONCallback
            ]
            displayImageFromFlickrBySearch(methodParameters as [String : AnyObject])
        } else {
            setUIEnabled(true)
            titleLabel.text = "Phrase Empty."
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates(fields: searchField, latitudeTextField, longitudeTextField)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(userTappedView(_:)))
        view.addGestureRecognizer(tapRecognizer)
        subscribeTo([
            .UIKeyboardWillHide: #selector(keyboardWillHide),
            .UIKeyboardWillShow: #selector(keyboardWillShow),
            .UIKeyboardDidShow: #selector(keyboardDidShow),
            .UIKeyboardDidHide: #selector(keyboardDidHide)
            ])
    }

    @objc func userTappedView(_ sender: Any) {
        resignIfFirstResponder(latitudeTextField)
        resignIfFirstResponder(longitudeTextField)
        resignIfFirstResponder(searchField)
    }
    func setUIEnabled(_ enabled: Bool) {
        titleLabel.isEnabled = enabled
        phraseTextField.isEnabled = enabled
        latitudeTextField.isEnabled = enabled
        longitudeTextField.isEnabled = enabled
        phraseSearchButton.isEnabled = enabled
        latLonSearchButton.isEnabled = enabled
        
        // adjust search button alphas
        if enabled {
            phraseSearchButton.alpha = 1.0
            latLonSearchButton.alpha = 1.0
        } else {
            phraseSearchButton.alpha = 0.5
            latLonSearchButton.alpha = 0.5
        }
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
