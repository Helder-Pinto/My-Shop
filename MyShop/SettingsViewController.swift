//
//  SettingsViewController.swift
//  MyShop
//
//  Created by Apple on 28/04/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let currencyArray = ["€", "$", "£", "¥", "₽", "HKD", "CHF", "Kč", "kr", "﷼", "₪", "₩", "Ls", "₨", "﷼"]
    
    let currencyStringArray = ["EUR, €", "USD, $", "GBP, £", "CNY, ¥", "RUB, ₽", "HKD", "CHF", "CZK, Kč", "DKK, kr", "IRR, ﷼", "ILS, ₪", "KRW, ₩", "Lat, Ls", "Rupee, ₨", "QAR, ﷼"]
    
    var currencyPicker: UIPickerView!
    var currencyString = ""
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var signOutOut: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signOutOut.layer.cornerRadius = 8
        signOutOut.layer.borderWidth = 1
      //  signOutOut.layer.borderColor = .blue 
        
        currencyPicker = UIPickerView()
        currencyPicker.delegate = self
        currencyTextField.inputView = currencyPicker
        
        currencyTextField.delegate = self

    }
    

    
    
    //MARK: IBActions
    @IBAction func dissmisPicker(_ sender: Any) {
        
        self.view.endEditing(true)
        
    }
    @IBAction func signOutPressed(_ sender: Any) {
        
        
    }
    
    //MARK: Picker View Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == currencyPicker {
            
            return currencyStringArray.count
        } else {
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == currencyPicker {
            
            return currencyStringArray[row]
        } else {
            return ""
        }
    }
    
    //MARK Picker View Delegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == currencyPicker {
            
            currencyTextField.text = currencyArray[row]
        }
        
        saveSettings()
        updateUI()
    }
    
    //MARK: SaveSettings
    
    func saveSettings() {
        
        userDefaults.set(currencyTextField.text!, forKey: kCURRENCY)
        userDefaults.synchronize()
    
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == currencyTextField {
            
            if currencyString == "" {
                
                currencyString = currencyArray[0]
            }
            currencyTextField.text = currencyString
        }
    }
    
    //MARK: UpdateUI
    
    func updateUI() {
        currencyTextField.text = userDefaults.object(forKey: kCURRENCY) as? String
        currencyString = currencyTextField.text!
    }
}


