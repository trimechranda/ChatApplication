//
//  ValidateCodePhoneVC.swift
//  ChatApp
//
//  Created by TRIMECH on 14/03/2018.
//  Copyright © 2018 TRIMECH. All rights reserved.
//

import UIKit

class ValidateCodePhoneVC: UIViewController {
    @IBOutlet weak var CodePhoneView: UIView!
    @IBOutlet weak var CodePhoneTextField: UITextField!
    @IBOutlet weak var CodePhoneButton: UIButton!
    var Name:String = ""
    var PhoneNumber :String = ""
    var password :String = ""
    var sexe:String = ""
    var birthDate :String = ""
    var verificationid :String = ""
    var profilePic:String = ""
    func customization()  {
        let myColor : UIColor = UIColor( red: 255, green: 255, blue:255, alpha: 1.0 )
        CodePhoneView.layer.borderWidth = 1
        CodePhoneView.layer.masksToBounds = false
        CodePhoneView.layer.borderColor = myColor.cgColor
        CodePhoneView.layer.cornerRadius = 35
        CodePhoneView.clipsToBounds = true
        
        
    }
    @IBAction func backBtnSelected(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "InscriptionVC") as! InscriptionVC
        self.present(nextViewController, animated:true, completion:nil)    }
    // enter code phone

    @IBAction func Ok(){
        if(!(birthDate.isEmpty)){

            Inscription.VerificationUserwithPhone( verificationCode: (self.CodePhoneTextField.text)!,verificationID: self.verificationid,withName: Name, PhoneNumber: PhoneNumber, password: password,sexe: sexe, birthDate: birthDate,profilePic: self.profilePic, completion: { [weak weakSelf = self] (status) in
            DispatchQueue.main.async {
                if status == true {

                    let loggedInVC:AcceuilVC = self.storyboard!.instantiateViewController(withIdentifier: "AcceuilVC") as! AcceuilVC
                    
                    self.present(loggedInVC, animated: true, completion: nil)                }
                else{
                    let alert = UIAlertController(title: "Alert", message: "Le code n'est pas correct", preferredStyle: UIAlertControllerStyle.alert)
                    self.present(alert, animated: true, completion: nil)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                            
                        }}))                }
                weakSelf = nil
            }
        })
        }
        else{
            Inscription.AuthentificationUserwithPhone( verificationCode: (self.CodePhoneTextField.text)!,verificationID: self.verificationid, completion: { [weak weakSelf = self] (status) in
                DispatchQueue.main.async {
                    if status == true {
                        
                        let loggedInVC:AcceuilVC = self.storyboard!.instantiateViewController(withIdentifier: "AcceuilVC") as! AcceuilVC
                        
                        self.present(loggedInVC, animated: true, completion: nil)                }
                    else{
                        let alert = UIAlertController(title: "Alert", message: "Le code n'est pas correct", preferredStyle: UIAlertControllerStyle.alert)
                        self.present(alert, animated: true, completion: nil)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                                
                            }}))                }
                    weakSelf = nil
                }
            })
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()

    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
   

}
