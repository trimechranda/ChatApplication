//
//  Contact.swift
//  ChatApp
//
//  Created by TRIMECH on 30/03/2018.
//  Copyright © 2018 TRIMECH. All rights reserved.
//

import UIKit
import Firebase

class Contact: NSObject {
    
   
    class func Showfriends(completion: @escaping ([String]) -> Swift.Void) {
        if let currentUserID = Auth.auth().currentUser?.uid {
         Database.database().reference().child("friends").child(currentUserID).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value)
            let data = snapshot.value as? NSDictionary
           // let name = data!["key"]!
            let keys = data?.allKeys as! [String]
            let key = snapshot.key
           completion(keys)
            })
           
            

            
        }
    }
    class func GetInfoUser(forUserID: String, completion: @escaping (User) -> Swift.Void) {
        
        Database.database().reference().child("users").child(forUserID).child("credentials").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value)
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
    class func AddFriend(IDFriend : String, completion: @escaping (Bool) -> Swift.Void) {
        
        if let currentUserID = Auth.auth().currentUser?.uid {
       let values = ["isFriend": false]
            Database.database().reference().child("friends").child(currentUserID).child(IDFriend).setValue(values)
        }
        
        completion(true)
    }
}
