//
//  ContactsVC.swift
//  ChatApp
//
//  Created by TRIMECH on 20/03/2018.
//  Copyright © 2018 TRIMECH. All rights reserved.
//

import UIKit
import Firebase

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var FriendImage: UIImageView!
    @IBOutlet weak var FriendNameLabel: UILabel!
 
}
class ContactsVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var profilePicLogout: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var TabBar: UITabBarItem!
    @IBOutlet weak var tableview: UITableView!

    var name :String = ""
    var namefriend :String = ""

    var imagestring :String = ""
    var picProfilString :String = ""
    var picProfilString1 :UIImage? = nil
    var Freinds  = [String]()
    var numCompteUser : Int = 0
    var numCompteFriend : Int = 0
    var idRoom : String = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
   getUserInformations()
        Contact.Showfriends( completion: {[weak weakSelf = self] (keys) in
            DispatchQueue.main.async {
                self.Freinds = keys
                weakSelf = nil
                self.tableview.reloadData()

            }})
    }
  func getUserInformations()  {
        if let id = Auth.auth().currentUser?.uid {
            
            User.GetInfoUser(forUserID: id, completion: {[weak weakSelf = self] (user) in
                DispatchQueue.main.async {
                    weakSelf?.name = user.name
                    weakSelf?.picProfilString = user.profilpicString
                    weakSelf?.numCompteUser = user.numCompte
                    self.picProfilString1 =  ImageFunctions.convertBase64ToImage(base64String: self.picProfilString)
                  //self.profilePicLogout.image = self.picProfilString1
                   // self.Name.text = self.name
                    print(self.name)
                    weakSelf = nil
                }
            })}}
       
 func numberOfSections(in tableView: UITableView) -> Int {
                return 1
            }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if(Freinds.isEmpty){
                return 1
    }
    else{
        return Freinds.count
        }
            }
            
   func tableView(_ tableView: UITableView!, cellForRowAt indexPath: IndexPath!) -> UITableViewCell!
            {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "CantactCell", for: indexPath) as! ContactTableViewCell
                if(Freinds.isEmpty){
                cell.FriendNameLabel.text = "Name"
                    cell.FriendImage.image = #imageLiteral(resourceName: "Username.png")
                    
                }
                else{
                    User.GetInfoUser(forUserID: Freinds[indexPath.row], completion: {[weak weakSelf = self] (user) in
                        DispatchQueue.main.async {
                            weakSelf?.namefriend = user.name
                            weakSelf?.imagestring = user.profilpicString
                            weakSelf?.numCompteFriend = user.numCompte

                            cell.FriendNameLabel.text = self.namefriend
                         cell.FriendImage.image = ImageFunctions.convertBase64ToImage(base64String: self.imagestring)

                        }})
            }
                return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let dataDict = Freinds[indexPath.row]
        if let id = Auth.auth().currentUser?.uid {
            User.GetInfoUser(forUserID: Freinds[indexPath.row], completion: {[weak weakSelf = self] (user) in
                DispatchQueue.main.async {
                    
                    weakSelf?.numCompteFriend = user.numCompte
                    weakSelf?.name = user.name

                    
                  
                }})
            if(numCompteUser<numCompteFriend){
                idRoom = String( numCompteUser) + String( numCompteFriend)
                
            }
            else {
                idRoom = String( numCompteFriend) + String(numCompteUser)
                
            }
            let fromID  = id
            let toID = Freinds[indexPath.row]
            
            let loggedInVC:ChatVC = self.storyboard!.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            loggedInVC.IDRoom = idRoom
            if fromID != id{
                loggedInVC.ID = fromID
                
            }
            if toID != id {
                loggedInVC.ID = toID
                
            }
            loggedInVC.Name  = self.name

            self.present(loggedInVC, animated: false, completion: nil)
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
