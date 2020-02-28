//
//  Authentification.swift
//  ChatApp
//
//  Created by TRIMECH on 15/03/2018.
//  Copyright © 2018 TRIMECH. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import Firebase
class Authentification: NSObject {
    //Authetifaication user with mail
    class func loginUser(withEmail: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
        
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in

            if let error = error {
                print("verifier votre mail ou mot de passe")
                completion(false)
            }
            else if let user = user {
                print("login success")
                let userID : String = (Auth.auth().currentUser?.uid)!

                let userInfo = ["userID": userID]
                UserDefaults.standard.set(userID, forKey: "userID")

                completion(true)
            }})
    }
    //Reset password
    class func ResetPassword(withEmail: String,  completion: @escaping (Bool) -> Swift.Void) {
        
       Auth.auth().sendPasswordReset(withEmail: withEmail) { error in
            
            if let error = error {
                completion(false)
            }
            else{
        
                completion(true)
            }
    }
}
}
