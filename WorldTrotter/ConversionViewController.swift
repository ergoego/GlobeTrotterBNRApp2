//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Erik Olson on 9/23/17.
//  Copyright © 2017 Erik Olson. All rights reserved.
//

import UIKit
import Foundation

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .none
        df.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm", options: 0, locale: Locale.current)
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.textColor = UIColor.gray
        textField.placeholder = "ºF"
        setPlaceholderColorFLabel()
        
        celsiusLabel.textColor = UIColor.gray
        updateCelsiusLabel()
    }
    
    func setPlaceholderColorFLabel() {
        if let placeholder = textField.placeholder {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.orange])
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        let date = Date()
        let currentTime = dateFormatter.string(from: date)
        var time: [Substring] = currentTime.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
        if let hour = Int(time[0]) {
            if hour >= 7 && hour <= 18 {
                self.view.backgroundColor = UIColor.lightGray
            } else {
                self.view.backgroundColor = UIColor.darkGray
            }
        }
    }
    
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField){
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
            celsiusLabel.text!.append("ºC")
        } else {
            celsiusLabel.text = "__ºC"
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let existingTextHasDegreeSymbol = textField.text?.range(of: "º")
        if let text = textField.text {
            if text == "" {
                textField.placeholder = "ºF"
                setPlaceholderColorFLabel()
                print("text at end of editing \(text)")
            }
            else if existingTextHasDegreeSymbol != nil {
                print("text at end of editing \(text)")
            }
            else {
                textField.text!.append("ºF")
            }
        }
}
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentLocale = Locale.current
        let decimalSeparator = currentLocale.decimalSeparator ?? "." // The ?? here denotes that the optional decimalSeparator is unwrapped, and if it is found to be nil, then what comes after the ?? is returned as a default value. 
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        var replacementTextHasAlpha: Bool = false
        for character in string.unicodeScalars {
            if CharacterSet.letters.contains(character) {
                replacementTextHasAlpha = true
            } else {
                replacementTextHasAlpha = false
            }
        }
        
        print("This is the current text: \(textField.text ?? "null")")
        print("This is the replacement text: \(string)")
        print("replacementTextHasAlpha = \(replacementTextHasAlpha)")
        
        if existingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil || replacementTextHasAlpha == true {
            print("text entry not allowed.")
            return false
        } else {
            print("text entry allowed.")
            return true
        }
    }
}
