//
//  Inscription.swift
//  ChatApp
//
//  Created by TRIMECH on 12/03/2018.
//  Copyright © 2018 TRIMECH. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class Inscription: NSObject {
    
    let name: String
    let email: String
    let sexe: String
    let birthDate: String
    let id: String
    var profilePic: String
   
    

    ///  Register user with email
    ///
    /// - Parameters:
    ///   - withName: the name of user (String)
    ///   - email: the email of user (String : with format xxx@xx.xx) (String)
    ///   - password: the password contains lettrs and numbers (String)
    ///   - sexe: man or women (String)
    ///   - birthDate: the birth date (String)
    ///   - profilePic: uimage
    ///   - completion: bool
    class func registerUserwithEmail(withName: String,
                                     email: String,
                                     password: String,
                                     sexe: String,
                                     birthDate: String,
                                     profilePic: String,
                                     completion: @escaping (Bool) -> Swift.Void) {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://www.example.com")
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        actionCodeSettings.setAndroidPackageName("com.example.android",
                                                 installIfNotAvailable: false, minimumVersion: "12")
        var numCompte: Int = 0
        Auth.auth().createUser(withEmail: email,
                               password: password,
                               completion: { (user, error) in
            if error == nil {
                

                user?.sendEmailVerification{ (error) in
                    if let error = error{
                        
                        print("your mail invalid")
                    }
                }
                
                Database.database().reference().child("users").observe(.value, with: { (snapshot: DataSnapshot!) in
                    print("Got snapshot");
                    print(snapshot.childrenCount)
                    
                    numCompte = Int(snapshot.childrenCount)
              
              
                let values = ["numCompte":numCompte,"name": withName, "email": email,"sexe": sexe,"birthDate": birthDate,"profilePicLink": profilePic] as [String : Any];                        Database.database().reference().child("users").child((user?.uid)!).child("credentials").updateChildValues(values, withCompletionBlock: { (errr, _) in
                            if errr == nil {
                                let userInfo = ["email" : email, "id":user!.uid]
                                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                                completion(true)
                            }
                        
                })
                })}
            else {
                completion(false)
            }
        })
    }
    
    /// Send a verification code to the user's phone
    ///
    /// - Parameters:
    ///   - phoneNumber: the phone number of user
    ///   - completion: String : return verification ID
    class func registerUserwithPhone( phoneNumber: String,completion: @escaping (String) -> Swift.Void){
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            DispatchQueue.main.async {
            if let error = error {
                return
            }
            else{
               let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
                UserDefaults.standard.synchronize()

            }
            completion (verificationID!)

        }
        }
        }
    

/// Register user with phone number
///
/// - Parameters:
///   - verificationCode: the id (for sms)
///   - verificationID: verification id (from func registerUserwithPhone)
///   - withName: Name of user
///   - PhoneNumber: phone number of user
///   - password: password
///   - sexe: men or women
///   - birthDate: string
///   - profilePic: uimage
///   - completion: return bool
class func VerificationUserwithPhone( verificationCode: String,verificationID: String,withName: String, PhoneNumber: String, password: String,sexe: String, birthDate: String, profilePic: String,completion: @escaping (Bool) -> Swift.Void) {
   
    let credential = PhoneAuthProvider.provider().credential( withVerificationID: verificationID, verificationCode: verificationCode)
    Auth.auth().signIn(with: credential) { (user, error) in
        if let error = error {
            print ("user is not signn")
            completion(false)

            return
        }
        
        
       print ("user is signn")
        if(!withName.isEmpty){
            Database.database().reference().child("users").observe(.value, with: { (snapshot: DataSnapshot!) in
                print("Got snapshot");
                print(snapshot.childrenCount)
                var numCompte: Int = 0

                numCompte = Int(snapshot.childrenCount)
                let values = ["numCompte": numCompte,"name": withName, "PhoneNumber": PhoneNumber,"sexe": sexe,"birthDate": birthDate,"profilePicLink": profilePic] as [String : Any];                        Database.database().reference().child("users").child((user?.uid)!).child("credentials").updateChildValues(values, withCompletionBlock: { (errr, _) in
                    if errr == nil {
                        let userInfo = ["email" : PhoneNumber, "password" : password]
                        UserDefaults.standard.set(userInfo, forKey: "userInformation")
                    }
                })})}
        else{
            print ("userrrrrr is signn")

        }
        completion(true)

            }
        }
    
    /// Authentification user with phone
    ///
    /// - Parameters:
    ///   - verificationCode: code sms
    ///   - verificationID: generated from firebase
    ///   - completion: return bool
    class func AuthentificationUserwithPhone( verificationCode: String,verificationID: String,completion: @escaping (Bool) -> Swift.Void) {
        
        let credential = PhoneAuthProvider.provider().credential( withVerificationID: verificationID, verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print ("user is not signn")
                completion(false)
                
            }
            
            
            print ("user is signn")
          
            completion(true)
            
        }
    }
    
    
 
    //MARK: Inits
    init(name: String, email: String, id: String,sexe: String,birthDate: String, profilePic: String) {
        self.name = name
        self.email = email
        self.id = id
        self.sexe = sexe
        self.birthDate = birthDate
        self.profilePic = profilePic
    }
}
