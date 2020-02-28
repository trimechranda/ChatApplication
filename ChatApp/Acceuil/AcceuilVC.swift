//
//  AcceuilVC.swift
//  ChatApp
//
//  Created by TRIMECH on 15/03/2018.
//  Copyright © 2018 TRIMECH. All rights reserved.
//

import UIKit
import Firebase
class AcceuilVC: UITabBarController {
    var name :String = ""
    @IBOutlet weak var profilePicView: UIImageView!
    
    @IBOutlet weak var TabBar: UITabBar!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var profilePicLogout: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var LogoutButton: UIButton!
   
        
    @IBAction func exitAction() {
        logoutView.isHidden=true

    }
    func setTabbar()
    {
        
        TabBar.barTintColor = UIColor(red: 244, green: 244, blue: 244, alpha: 1)
        TabBar.backgroundColor = UIColor(red: 244, green: 244, blue: 244, alpha: 1)
        TabBar.tintColor = UIColor(red: 244, green: 244, blue: 244, alpha: 1)
        TabBar.items![0].image = #imageLiteral(resourceName: "chats")
        TabBar.items![0].selectedImage = #imageLiteral(resourceName: "selectedContacts")
        TabBar.items![0].title = "Chats"
        TabBar.items![2].title = "Notifications"
        TabBar.items![1].image = #imageLiteral(resourceName: "contacts")
        TabBar.items![1].selectedImage = #imageLiteral(resourceName: "selectedContacts")
        TabBar.items![1].title = "Contacts"
        TabBar.items![2].image = #imageLiteral(resourceName: "notifications")
        TabBar.items![2].selectedImage = #imageLiteral(resourceName: "selectedNotifications")
        TabBar.items![2].title = "Notifications"
        TabBar.items![3].image = #imageLiteral(resourceName: "me-Icon")
        TabBar.items![3].selectedImage = #imageLiteral(resourceName: "selectedMe-Icon")
        TabBar.items![3].title = "Moi"
        


    }
    @IBAction func Logout() {
        
        User.logOutUser()
        let loggedInVC:AuthentificationVC = self.storyboard!.instantiateViewController(withIdentifier: "AuthentificationVC") as! AuthentificationVC
        
        self.present(loggedInVC, animated: true, completion: nil)
    }
    
    func getUserInformations()  {
        if let id = Auth.auth().currentUser?.uid {
            
            User.GetInfoUser(forUserID: id, completion: {[weak weakSelf = self] (user) in
                DispatchQueue.main.async {
                    weakSelf?.name = user.name
                    weakSelf?.profilePicView.image = user.profilePic
                    
                    print(self.name)
                    weakSelf = nil
                }
            })
        }
    }
    
    // MARK: - Button
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        
        if (gesture.view as? UIImageView) != nil {
            print("Image Tapped")
            logoutView.isHidden=false
            if let id = Auth.auth().currentUser?.uid {
                
                User.GetInfoUser(forUserID: id, completion: {[weak weakSelf = self] (user) in
                    DispatchQueue.main.async {
                        weakSelf?.Name.text = user.name
                        weakSelf?.profilePicLogout.image = user.profilePic
                        
                        print(self.name)
                        weakSelf = nil
                    }
                })
            }

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     //  self.customization()
       // logoutView.isHidden=true
   // self.getUserInformations()
        // create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AcceuilVC.imageTapped(gesture:)))
        setTabbar()
        // add it to the image view;
       // profilePicView.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
      //  profilePicView.isUserInteractionEnabled = true
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
