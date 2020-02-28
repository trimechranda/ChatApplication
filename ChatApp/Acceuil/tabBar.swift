//
//  tabBar.swift
//  ChatApp
//
//  Created by TRIMECH on 07/04/2018.
//  Copyright © 2018 TRIMECH. All rights reserved.
//

import UIKit

class tabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

    setTabbar()
        
    }
    func setTabbar()
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarcntrl = UITabBarController()
        let Chats = storyboard.instantiateViewController(withIdentifier: "ChatsVC") // 1st tab bar viewcontroller
        let Contacts = storyboard.instantiateViewController(withIdentifier: "ContactsVC") // 2nd tab bar viewcontroller
        let Notifications = storyboard.instantiateViewController(withIdentifier: "NotificationsVC") // 3rd tab bar viewcontroller
        let Configurations = storyboard.instantiateViewController(withIdentifier: "ConfigurationsVC") // 4rd tab bar viewcontroller
        
        // all viewcontroller embedded navigationbar
        let nvChats = UINavigationController(rootViewController: Chats)
        let nvContacts = UINavigationController(rootViewController: Contacts)
        let nvNotifications = UINavigationController(rootViewController: Notifications)
        let nvConfigurations = UINavigationController(rootViewController: Configurations)
        
        
        // all viewcontroller navigationbar hidden
        nvChats.setNavigationBarHidden(true, animated: false)
        nvContacts.setNavigationBarHidden(true, animated: false)
        nvNotifications.setNavigationBarHidden(true, animated: false)
        nvConfigurations.setNavigationBarHidden(true, animated: false)
        
        
        tabbarcntrl.viewControllers = [nvChats,nvContacts,nvNotifications,nvConfigurations]
        
        let tabbar = tabbarcntrl.tabBar
        tabbar.barTintColor = UIColor(red: 244, green: 244, blue: 244, alpha: 1)
        tabbar.backgroundColor = UIColor(red: 244, green: 244, blue: 244, alpha: 1)
        tabbar.tintColor = UIColor(red: 244, green: 244, blue: 244, alpha: 1)
        
        //UITabBar.appearance().tintColor = UIColor.white
        
        
        
        let tabChats = tabbar.items![0]
        tabChats.title = "Chats" // tabbar titlee
        tabChats.image=(#imageLiteral(resourceName: "chats")).withRenderingMode(.alwaysOriginal) // deselect image
        tabChats.selectedImage = #imageLiteral(resourceName: "selectedChats").withRenderingMode(.alwaysOriginal) // select image
        tabChats.titlePositionAdjustment.vertical = tabChats.titlePositionAdjustment.vertical-4 // title position change
        
        let tabContacts = tabbar.items![1]
        tabContacts.title = "Contacts"
        tabContacts.image=(#imageLiteral(resourceName: "contacts")).withRenderingMode(.alwaysOriginal)
        tabContacts.selectedImage=#imageLiteral(resourceName: "selectedContacts").withRenderingMode(.alwaysOriginal)
        tabContacts.titlePositionAdjustment.vertical = tabContacts.titlePositionAdjustment.vertical-4
        
        let tabNotifications = tabbar.items![2]
        tabNotifications.title = "Notifications"
        tabNotifications.image=(#imageLiteral(resourceName: "notifications")).withRenderingMode(.alwaysOriginal)
        tabNotifications.selectedImage=#imageLiteral(resourceName: "selectedNotifications").withRenderingMode(.alwaysOriginal)
        tabNotifications.titlePositionAdjustment.vertical = tabNotifications.titlePositionAdjustment.vertical-4
        
        let tabConf = tabbar.items![3]
        tabConf.title = "Configurations"
        tabConf.image=(#imageLiteral(resourceName: "me-Icon")).withRenderingMode(.alwaysOriginal)
        tabConf.selectedImage=#imageLiteral(resourceName: "selectedMe-Icon").withRenderingMode(.alwaysOriginal)
        tabConf.titlePositionAdjustment.vertical = tabConf.titlePositionAdjustment.vertical-4
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
