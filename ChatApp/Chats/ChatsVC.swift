//
//  ChatsVC.swift
//  ChatApp
//
//  Created by TRIMECH on 20/03/2018.
//  Copyright © 2018 TRIMECH. All rights reserved.
//

import UIKit
import Firebase
class CoversationsTableViewCell: UITableViewCell {
    @IBOutlet weak var FriendImage: UIImageView!
    @IBOutlet weak var FriendNameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!


}
class ChatsVC: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var tableview: UITableView!
  
    @IBOutlet weak var TabBar: UITabBarItem!
    @IBOutlet weak var searchBar: UISearchBar!
    var toID = "n3S5ntaz4SZRtlZLuW7KHuTzfcE2"
    var values : NSDictionary = NSDictionary()
    var myArray : NSMutableArray? = []
    var myKey : NSMutableArray? = []
    @IBOutlet weak var profilePicLogout: UIImageView!
    var name : String = ""
  var imagestring :String = ""
    var FriendImages = UIImageView()
    var selectedUser: User?
    var nameMoi :String = ""
    var picProfilString :String = ""
    var nameArray : [String] = []
    var filtered:[String] = []
    var searchActive : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
       getUserInformations()
        searchBar.delegate = self
       
     /* let password = "azdrezcldkdk123dkdbnchpeqwxdplke"  // returns random 32 char string
        let encrypted = AES256CBC.encryptString("selemmm", password: password)
      let message = Message.init(type: .text, content: encrypted, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false)
        Message.send(message: message, toID: "RX9FZW3RUTNuXGH3OjCYyC0sg9I2"){
           (status) in
            DispatchQueue.main.async {
         
            } } */
      /* Contact.AddFriend(IDFriend:"dxLczPn0XXMXsGt2SloNWLnVYi42", completion:{[weak weakSelf = self] (Bool) in
            DispatchQueue.main.async {
            
            }})*/
        getConversations()
    }
   
   
   
    func getUserInformations()  {
       // test.helloWorld()
        let myColor : UIColor = UIColor( red: 198, green: 198, blue:198, alpha: 1.0 )
        profilePicLogout.layer.borderWidth = 1
        profilePicLogout.layer.masksToBounds = false
        profilePicLogout.layer.borderColor = myColor.cgColor
        profilePicLogout.layer.cornerRadius = profilePicLogout.frame.height/2
        profilePicLogout.clipsToBounds = true
        if let id = Auth.auth().currentUser?.uid {
        User.GetInfoUser(forUserID: id, completion: {[weak weakSelf = self] (user) in
                DispatchQueue.main.async {
        weakSelf?.picProfilString = user.profilpicString
       self.profilePicLogout.image = ImageFunctions.convertBase64ToImage(base64String: self.picProfilString)
                    weakSelf = nil
                }})}
    }
    func getConversations(){
        
        Conversation.showConversations() {
            
            (value,Key) in
            
                self.values = value
                let Key = Key 
                //  self.names = names
                self.myArray?.add(self.values)
                self.myKey?.add(Key)
                self.tableview.reloadData()
          }

      }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        else{
        return self.myArray!.count
        }
    }
    
    func tableView(_ tableView: UITableView!, cellForRowAt indexPath: IndexPath!) -> UITableViewCell!
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConvCell", for: indexPath) as! CoversationsTableViewCell
        let dataDict = self.myArray![indexPath.row] as! [String: Any]
         if let id = Auth.auth().currentUser?.uid {
            let fromID  = dataDict["fromID"] as? String
            let toID = dataDict["toID"] as? String
            let type = dataDict["type"] as? String
            let isRead = dataDict["isRead"] as? Bool

            if type == "text"{
         if fromID != id{
            User.GetInfoUser(forUserID: fromID!, completion: {[weak weakSelf = self] (user) in
                DispatchQueue.main.async {
                    weakSelf?.name = user.name
                    weakSelf?.imagestring = user.profilpicString
                    let messageStrg = dataDict["content"] as! String
                    let password = "azdrezcldkdk123dkdbnchpeqwxdplke"  // returns random 32 char string
                    let decrypted = AES256CBC.decryptString(messageStrg, password: password)
                    weakSelf?.imagestring = user.profilpicString
                    self.nameArray.append(self.name)
                    if(self.searchActive){
                        cell.FriendNameLabel.text = self.filtered[indexPath.row]
                    } else {
                        cell.FriendNameLabel.text = self.name
                    }
                    if( isRead == false){
                    cell.lastMessageLabel.text = decrypted
                        cell.lastMessageLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
                        cell.lastMessageLabel.textColor = UIColor.black

                    }
                    else if( isRead == true){
                        cell.lastMessageLabel.text = messageStrg

                    }
                    
                 cell.FriendImage.image = ImageFunctions.convertBase64ToImage(base64String: self.imagestring)

                }  }) }
        if toID != id {
            User.GetInfoUser(forUserID: toID!, completion: {[weak weakSelf = self] (user) in
                DispatchQueue.main.async {
                   
                    weakSelf?.name = user.name
                    weakSelf?.imagestring = user.profilpicString
                    let messageStrg = dataDict["content"] as! String
                    let password = "azdrezcldkdk123dkdbnchpeqwxdplke"  // returns random 32 char string
                    let decrypted = AES256CBC.decryptString(messageStrg, password: password)
                    self.nameArray.append(user.name)
                    if(self.searchActive){
                        cell.FriendNameLabel.text = self.filtered[indexPath.row]
                    } else {
                        cell.FriendNameLabel.text = self.name
                    }
                  cell.lastMessageLabel.text = decrypted
                cell.FriendImage.image = ImageFunctions.convertBase64ToImage(base64String: self.imagestring)
} })}}
            else if( type == "photo")  {
                if fromID != id{
                    User.GetInfoUser(forUserID: fromID!, completion: {[weak weakSelf = self] (user) in
                        DispatchQueue.main.async {
                            weakSelf?.imagestring = user.profilpicString
                            weakSelf?.name = user.name
                            self.nameArray.append(self.name)
                            if(self.searchActive){
                                cell.FriendNameLabel.text = self.filtered[indexPath.row]
                            } else {
                                cell.FriendNameLabel.text = self.name
                            }
                            cell.FriendImage.image = ImageFunctions.convertBase64ToImage(base64String: self.imagestring)
                        }  }) }
                if toID != id {
                    User.GetInfoUser(forUserID: toID!, completion: {[weak weakSelf = self] (user) in
                        DispatchQueue.main.async {
                            
                            weakSelf?.imagestring = user.profilpicString
                            weakSelf?.name = user.name
                            cell.FriendNameLabel.text = self.name

                            cell.FriendImage.image = ImageFunctions.convertBase64ToImage(base64String: self.imagestring)
                        } })}
                cell.FriendNameLabel.text = self.name
                self.nameArray.append(self.name)

                cell.lastMessageLabel.text = "une photo"}
            else if( type == "video"){
                cell.FriendNameLabel.text = self.name
                self.nameArray.append(self.name)

            //   cell.FriendImage.image = ImageFunctions.convertBase64ToImage(base64String: self.imagestring)
                cell.lastMessageLabel.text = "un vidéo"}
            }
            
        cell.FriendNameLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 17.0)
        cell.lastMessageLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 14.0)
        cell.TimeLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 13.0)
        let myColor : UIColor = UIColor( red: 198, green: 198, blue:198, alpha: 1.0 )
       cell.FriendImage.layer.borderWidth = 1
        cell.FriendImage.layer.masksToBounds = false
       cell.FriendImage.layer.borderColor = myColor.cgColor
       cell.FriendImage.layer.cornerRadius = cell.FriendImage.frame.height/2
        cell.FriendImage.clipsToBounds = true
 return cell  
       
        
       
         }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      


       let dataDict = self.myArray![indexPath.row] as! [String: Any]
        if let id = Auth.auth().currentUser?.uid {
            let fromID  = dataDict["fromID"] as? String
            let toID = dataDict["toID"] as? String

            let loggedInVC:ChatVC = self.storyboard!.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            loggedInVC.IDRoom = self.myKey![indexPath.row] as! String
            if fromID != id{
                loggedInVC.ID = fromID!

                }
            if toID != id {
                loggedInVC.ID = toID!

            }
            loggedInVC.Name  = self.name
            
            
            self.present(loggedInVC, animated: false, completion: nil)
       
    }
    
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = nameArray.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        tableview.reloadData()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            print("Deleted")
            
           // self.catNames.remove(at: indexPath.row)
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
