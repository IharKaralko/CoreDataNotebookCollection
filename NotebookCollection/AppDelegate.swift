//
//  AppDelegate.swift
//  NotebookCollection
//
//  Created by Ihar_Karalko on 12/8/19.
//  Copyright © 2019 Ihar_Karalko. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = window?.rootViewController as! UINavigationController
        let notebooksListViewController = navigationController.topViewController as! NotebookListWithFRCViewController
        notebooksListViewController.dataSourceOfNotebook = DataSourceOfNotebook()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataManager.instance.saveContext()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.instance.saveContext()
    }
}
