//
//  CoreDataManager.swift
//  NotebookCollection
//
//  Created by Ihar_Karalko on 12/10/19.
//  Copyright © 2019 Ihar_Karalko. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    // Singleton
    static let instance = CoreDataManager()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NotebookCollection")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            storeDescription.shouldMigrateStoreAutomatically = true
            storeDescription.shouldInferMappingModelAutomatically = false
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
