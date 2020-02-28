//
//  Conversation.swift
//  ChatApp
//
//  Created by TRIMECH on 21/03/2018.
//  Copyright © 2018 TRIMECH. All rights reserved.
//

import UIKit
import Firebase
class Conversation {
    
    class func showConversations(completion: @escaping (NSDictionary,String) -> Swift.Void) {
        
        if let id = Auth.auth().currentUser?.uid {
        Database.database().reference().child("conversations").child(id).observe(.childAdded, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let Key = snapshot.key as? String ?? ""
           
            completion(value!,Key)
        })
        
        
    }
    }


}
