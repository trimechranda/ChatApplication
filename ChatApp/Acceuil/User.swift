//
//  User.swift
//  ChatApp
//
//  Created by TRIMECH on 16/03/2018.
//  Copyright © 2018 TRIMECH. All rights reserved.
//

import Foundation
import Firebase

class User: NSObject {
    
    let name: String
    let id: String
    let birthDate: String
    let sexe :String
    let profilpicString :String
    let numCompte :Int
    var profilePic: UIImage?
   
   
    class func GetInfoUser(forUserID: String, completion: @escaping (User) -> Swift.Void) {
        
     Database.database().reference().child("users").child(forUserID).child("credentials").observeSingleEvent(of: .value, with: { (snapshot) in
            let data = snapshot.value as? NSDictionary
            let name = data!["name"]!
            let birthDate = data!["birthDate"]!
            let sexe = data!["sexe"]!
            let profilpicString = data!["profilePicLink"]!
            print(data!["numCompte"]!)
        let numCompte : NSNumber = data!["numCompte"]! as! NSNumber
        let user = User.init(numCompte: numCompte.intValue,name: name as! String, id: forUserID,birthDate: birthDate as! String,sexe:sexe as! String,profilpicString: profilpicString as! String)
                completion(user)
           
        })
    }
    class func logOutUser() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
           }
        catch let signOutError as NSError {
             print ("Error signing out: %@", signOutError)
                    }}
    
    
    class func updateUser(withName: String, email: String, sexe: String, birthDate: String, profilePic: String,numCompte: Int, completion: @escaping (Bool) -> Swift.Void) {
        if let id = Auth.auth().currentUser?.uid {

            let values = ["name": withName, "email": email,"sexe": sexe,"birthDate": birthDate,"profilePicLink": profilePic,"numCompte": numCompte] as [String : Any];                        Database.database().reference().child("users").child(id).child("credentials").updateChildValues(values, withCompletionBlock: { (errr, _) in
                  if errr == nil {
                   completion(true)
                    }})}
            else {
                completion(false)
            }
    }
    init(numCompte :Int,name: String, id: String, birthDate: String,sexe:String,profilpicString: String) {
        self.numCompte = numCompte
        self.name = name
        self.id = id
        self.birthDate = birthDate
        self.sexe = sexe
        self.profilpicString = profilpicString
    }
    
    
}
