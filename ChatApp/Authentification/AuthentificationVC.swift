//
//  AuthentificationVC.swift
//  ChatApp
//
//  Created by TRIMECH on 15/03/2018.
//  Copyright © 2018 TRIMECH. All rights reserved.
//

import UIKit

class AuthentificationVC: UIViewController {

    @IBOutlet weak var CreateUserButton: UIButton!
    @IBOutlet weak var ConnectButton: UIButton!
    @IBOutlet weak var loginEmailField : UITextField!
    @IBOutlet weak var loginPasswordField : UITextField!
    @IBOutlet weak var loginphoneField : UITextField!


    var verificationid :String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AuthentificationVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(AuthentificationVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AuthentificationVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func CreateUser(){
        let loggedInVC:InscriptionVC = self.storyboard!.instantiateViewController(withIdentifier: "InscriptionVC") as! InscriptionVC
        
        self.present(loggedInVC, animated: false, completion: nil)
        
    }
    @IBAction func ConnectAction(){
         if (!self.loginEmailField.text!.isEmpty)
        {
             if (!loginEmailField.text!.isEmpty && isValidEmail(email: loginEmailField.text!) == true && doPasswordContainsNumber(password: self.loginPasswordField.text!) == true ) {
        Authentification.loginUser(withEmail: self.loginEmailField.text!, password: self.loginPasswordField.text!) { [weak weakSelf = self](status) in
            DispatchQueue.main.async {

                if status == true {
                    print(" success")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "AcceuilVC") as! AcceuilVC
                    self.present(vc, animated: true, completion: nil)
                    
                    
                } else {
                    print(" not success")
                    let alert = UIAlertController(title: "Alert", message: "Verifier votre mail ou mot de passe", preferredStyle: UIAlertControllerStyle.alert)
                    self.present(alert, animated: true, completion: nil)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                            
                            
                        }}))
                }
                weakSelf = nil
            }
        }
            }
             else{
                let alert = UIAlertController(title: "Alert", message: "Verifier votre mail ou mot de passe", preferredStyle: UIAlertControllerStyle.alert)
                self.present(alert, animated: true, completion: nil)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                        
                        
                    }}))
                
            }
    }
        if (!self.loginphoneField.text!.isEmpty)
{
            
            Inscription.registerUserwithPhone( phoneNumber: self.loginphoneField.text!, completion: { [weak weakSelf = self] (verificationID) in
                DispatchQueue.main.async {
                    self.verificationid = verificationID
                    print(verificationID)
                   
                }
                let loggedInVC:ValidateCodePhoneVC = self.storyboard!.instantiateViewController(withIdentifier: "ValidateCodePhoneVC") as! ValidateCodePhoneVC
                loggedInVC.verificationid = verificationID
                
                // loggedInVC.profilePic = self.profilePic
                
                self.present(loggedInVC, animated: false, completion: nil)
            })
        }
 }
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
   
    // test format of mail
    func isValidEmail(email:String) -> Bool {
        
        print("validate emilId: \(email)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
        
    }
    func doPasswordContainsNumber( password: String) -> Bool{
        
        let numberRegEx  = ".*[0-9]+.*"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: password)
        
        return containsNumber
    }
    @IBAction func ResetPasswordAction(){
        
        Authentification.ResetPassword(withEmail: self.loginEmailField.text!) { [weak weakSelf = self](status) in
            DispatchQueue.main.async {
                
                if status == true {
                    let alert = UIAlertController(title: nil, message: "Consulter email", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    let when = DispatchTime.now() + 4
                    DispatchQueue.main.asyncAfter(deadline: when){
                        alert.dismiss(animated: true, completion: nil)
                    }
        
 }
                else{
                    print("error")
            }
            }
        }}
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("HELLO")
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 25
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 25
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


