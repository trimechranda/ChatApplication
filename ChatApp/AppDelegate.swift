//
//  AppDelegate.swift
//  ChatApp
//
//  Created by TRIMECH on 22/02/2018.
//  Copyright © 2018 TRIMECH. All rights reserved.
//

import UIKit
import CoreData
import Firebase


@available(iOS 10.0, *)
@available(iOS 10.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate { 

    let kUserDefault = UserDefaults.standard

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
      
   if let id = Auth.auth().currentUser?.uid {
     let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatsVC") as! ChatsVC
            self.window?.rootViewController = rootController
    self.window?.rootViewController = setTabbar()
    self.window?.makeKeyAndVisible()
        }
      
        return true
    }
    func setTabbar() -> UITabBarController
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarcntrl = UITabBarController()
        let Chats = storyboard.instantiateViewController(withIdentifier: "ChatsVC")
        let Contacts = storyboard.instantiateViewController(withIdentifier: "ContactsVC")
        let Notifications = storyboard.instantiateViewController(withIdentifier: "NotificationsVC")
        let Configurations = storyboard.instantiateViewController(withIdentifier: "ConfigurationsVC")

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
        return tabbarcntrl
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ChatApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    @available(iOS 10.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

