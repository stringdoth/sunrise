//
//  ViewController.swift
//  Sunrise
//
//  Created by Bharath  Raj kumar on 15/11/18.
//  Copyright © 2018 Incend Digital Private Limited. All rights reserved.
//

import UIKit
import Firebase

class AASignInVC: AppConstants {
    //Remote Outlets
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    //Local Variables
    var emailAddress = ""
    var password = ""
    var userID = ""
    let bottomLayerEmail = CALayer()
    let bottomLayerPassword = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       self.setAlignment()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func setAlignment()
    {
        DispatchQueue.main.async {
            let viewWidth = self.view.frame.size.width
            let viewHeight = self.view.frame.size.height
            
            //labels
            self.emailLabel.isHidden = true
            self.passwordLabel.isHidden = true
            
            //frame for emailField
            self.emailField.frame = CGRect(x: 30, y: (viewHeight / 2 ) - 100, width: viewWidth - 60, height: 46)
            self.emailField.backgroundColor = UIColor.clear
            self.emailField.textColor = UIColor.black
            self.emailField.attributedPlaceholder = NSAttributedString(string: self.emailField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.5, alpha: 0.5)])
            self.emailField.layer.cornerRadius = 5
            self.emailField.layer.masksToBounds = true
            self.emailField.layer.borderWidth = 0.7
            // No need to add border colour bcos the global int is set ot black
            self.emailField.layer.borderColor = UIColor.black.cgColor
            
            //frame for PasswordField
            self.passwordField.frame = CGRect(x: 30, y: (viewHeight / 2 ) - 30, width: viewWidth - 60, height: 46)
            self.passwordField.backgroundColor = UIColor.clear
            self.passwordField.textColor = UIColor.black
            self.passwordField.attributedPlaceholder = NSAttributedString(string: self.passwordField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.5, alpha: 0.5)])
            self.passwordField.layer.cornerRadius = 5
            self.passwordField.layer.masksToBounds = true
            self.passwordField.layer.borderWidth = 0.7
            self.passwordField.layer.borderColor = UIColor.black.cgColor
            
            //frame for Login Button
            self.loginButton.frame = CGRect(x: 16, y: viewHeight - 130, width: viewWidth - 32, height: 46)
            self.loginButton.layer.cornerRadius = 5
            self.loginButton.layer.masksToBounds = true
            self.loginButton.backgroundColor = UIColor.black
            self.loginButton.titleLabel?.font = UIFont(name: "StringOpenSans-SemiBold", size: 15)
            
            //frame for SignUp button
            self.signUpButton.frame = CGRect(x: 16, y: viewHeight - 80, width: viewWidth - 32, height: 46)
            self.signUpButton.titleLabel?.font = UIFont(name: "OpenSans-Light", size: 11)
            self.signUpButton.titleLabel?.font =  self.signUpButton.titleLabel?.font.withSize(11)
            self.signUpButton.tintColor = UIColor.black
            
            //Add show Button
            self.showPasswordButton.frame = CGRect(x: (self.passwordField.frame.size.width - 25), y: 5, width: 50, height: 25)
            self.passwordField.rightView = self.showPasswordButton
            self.passwordField.rightViewMode = .always
            self.showPasswordButton.isHidden = true
            
            //setting Delegates
            self.emailField.delegate = self
            self.passwordField.delegate = self
            
            //set indentation for fields
            let EmailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 46))
            let PasswordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 46))
            self.emailField.leftView = EmailPaddingView
            self.emailField.leftViewMode = .always
            self.passwordField.leftView = PasswordPaddingView
            self.passwordField.leftViewMode = .always
            
            
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        if self.checkValidations()
        {
            self.emailAddress = self.emailField.text!
            self.password = self.passwordField.text!
        }
    }
    
    //Hide/Show Password
    @IBAction func showPasswordButtonAction(_ sender: Any) {
        
        if self.passwordField.isSecureTextEntry == false
        {
            self.passwordField.isSecureTextEntry = true
        }
        else if self.passwordField.isSecureTextEntry == true
        {
            self.passwordField.isSecureTextEntry = false
        }
    }
    @IBAction func signUpbuttonAction(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MainVC : UIViewController = Storyboard.instantiateViewController(withIdentifier: "AASignUpViewController")
        self.present(MainVC, animated: true, completion: nil)

    }
    
    //Alert functions
    func invalidEmailAlert()
    {
        let emailFieldAlert = UIAlertController(title: "Oops", message: "Invalid Email", preferredStyle: .alert)
        emailFieldAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        emailFieldAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(emailFieldAlert, animated: true, completion: nil)
    }
    
    func invalidPasswordAlert()
    {
        let passwordAlert = UIAlertController(title: "Oops", message: "Invalid password", preferredStyle: .alert)
        passwordAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        passwordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(passwordAlert, animated: true, completion: nil)
    }
    
    func checkValidations() -> Bool
    {
        if self.emailField.text != ""
        {
            if validateEmail(enteredEmail: self.emailAddress) == false
            {
                self.invalidEmailAlert()
                return false
            }
            else
            {
                return true
            }
        }
        else if self.passwordField.text != ""
        {
            if self.password.count < 6
            {
                self.invalidPasswordAlert()
                return false
            }
            else
            {
                return true
            }
        }
        else
        {
            if self.emailField.text?.count == 0
            {
                self.invalidEmailAlert()
            }
            else if self.passwordField.text?.count == 0
            {
                self.invalidPasswordAlert()
            }
            return false
        }
        
    }
    
    //Check for valid Email
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
}

extension AASignInVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailField
        {
            self.emailField.resignFirstResponder()
            self.passwordField.becomeFirstResponder()
        }
        if textField == self.passwordField
        {
            self.passwordField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.emailField
        {
            self.emailAddress = self.emailField.text!
            if validateEmail(enteredEmail: self.emailAddress)
            {
                self.emailField.layer.borderColor = UIColor.green.cgColor
            }
        }
        if textField == self.passwordField
        {
            self.password = self.passwordField.text!
            if self.passwordField.text?.count == 0
            {
                self.showPasswordButton.isHidden = true
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.passwordField
        {
            self.showPasswordButton.isHidden = false
        }
    }
    
    
}

