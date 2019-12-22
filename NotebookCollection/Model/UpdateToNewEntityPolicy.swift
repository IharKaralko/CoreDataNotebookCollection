//
//  UpdateToNewEntityPolicy.swift
//  NotebookCollection
//
//  Created by Ihar_Karalko on 12/16/19.
//  Copyright © 2019 Ihar_Karalko. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class UpdateToNewEntityPolicy: NSEntityMigrationPolicy {
    
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        // Call super
        try super.createDestinationInstances(forSource: sInstance, in: mapping, manager: manager)
        
        // Get the (updated) destination Note instance we're modifying
        guard let dInstance = manager.destinationInstances(forEntityMappingName: mapping.name, sourceInstances: [sInstance]).first else { return }
        
        let noteContent = NSEntityDescription.insertNewObject(forEntityName: "NoteContent", into: dInstance.managedObjectContext!)
        
     if let text = sInstance.value(forKey: "text") as? String {
       
        noteContent.setValue(UUID().uuidString, forKey: "textID")
         noteContent.setValue(NSAttributedString(string: text), forKey: "attributedText")
        }
        
        dInstance.setValue(noteContent, forKey: "noteContent")
        
        // Use the (original) source Note instance, and instantiate a new
        // NSAttributedString using the original string
//        if let text = sInstance.value(forKey: "text") as? String {
//            destination.setValue(NSAttributedString(string: text), forKey: "attributedText")
//        }
    }
}
