//
//  TwoFactorAuthenticationViewController.swift
//  PR3
//
//  Copyright © 2018 UOC. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController, UITextFieldDelegate {
    // TexFields
    @IBOutlet weak var firstField: UITextField!
    @IBOutlet weak var secondField: UITextField!
    @IBOutlet weak var thirdField: UITextField!
    @IBOutlet weak var fourthField: UITextField!
    
    // Labels
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var firstFLabel: UILabel!
    @IBOutlet weak var secondFLabel: UILabel!
    @IBOutlet weak var thirdFLabel: UILabel!
    @IBOutlet weak var fourthFLabel: UILabel!
    
    // Constraints
    @IBOutlet var textLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButtonTrailingConstant: NSLayoutConstraint!
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // We first check that the user is only entering numeric characters
        let numericSet = CharacterSet.decimalDigits
        let stringSet = CharacterSet(charactersIn: string)
        let onlyNumeric = numericSet.isSuperset(of: stringSet)
        
        if !onlyNumeric {
            return false
        }
        
        // We then check that the length of resulting text will be smaller or equal to 1
        let currentString = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentString) else {
            return false
        }
        
        let resultingString = currentString.replacingCharacters(in: stringRange, with: string)
        
        let resultingLength = resultingString.count
        
        if resultingLength <= 1 {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        doAuthentication()
    }
    
    // BEGIN-UOC-2
    
    // It automatically change field who is in focus when user introduce a symbol in a field. If it's the last field, it call
    // the authentication method.
    @IBAction func editingChanged(_ sender: UITextField) {
        switch sender {
        case firstField:
            secondField.becomeFirstResponder()
        case secondField:
            thirdField.becomeFirstResponder()
        case thirdField:
            fourthField.becomeFirstResponder()
        default:
            fourthField.resignFirstResponder()
            doAuthentication()
        }
    }
    // END-UOC-2
    
    func doAuthentication() {
        var validCode: Bool
        if let firstCode = firstField.text, let secondCode = secondField.text, let thirdCode = thirdField.text, let fourthCode = fourthField.text {
            let fullCode = firstCode + secondCode + thirdCode + fourthCode
            validCode = Services.validate(code: fullCode)
        } else {
            validCode = false
        }
        
        if validCode {
            // BEGIN-UOC-3
            // Here we define transitions that will be fired on view change
            
            let width = view.frame.width
            
            self.textLabelTopConstraint.constant = -self.textLabelTopConstraint.constant
            backButtonLeadingConstraint.constant = width
            nextButtonTrailingConstant.constant = -width
            
            UIView.animate(
                withDuration: 1,
                delay: 0,
                options: [],
                animations: {
                    
                    //Fields that will fade out
                    self.firstField.alpha = 0
                    self.secondField.alpha = 0
                    self.thirdField.alpha = 0
                    self.fourthField.alpha = 0
                    
                    self.firstFLabel.alpha = 0
                    self.secondFLabel.alpha = 0
                    self.thirdFLabel.alpha = 0
                    self.fourthFLabel.alpha = 0
                    
                    self.view.layoutIfNeeded()
                },
                completion: { _ in
                    
                    // When transitions are done, we perform segue
                    self.textLabel.alpha = 0
                    self.performSegue (withIdentifier: "SegueToMainNavigation", sender: self)
            })
            
            // END-UOC-3
            
        } else {
            let errorMessage = "Sorry, the entered code is not valid"
            let errorTitle = "We could not autenticate you"
            Utils.show (Message: errorMessage, WithTitle: errorTitle, InViewController: self)
        }
    }
}
