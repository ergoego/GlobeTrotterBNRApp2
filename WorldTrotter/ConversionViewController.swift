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
        updateCelsiusLabel()
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
                self.view.backgroundColor = UIColor.black
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
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeparator = string.range(of: ".")
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
