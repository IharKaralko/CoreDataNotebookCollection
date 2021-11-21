//
//  DataSourceOfNote.swift
//  NotebookCollection
//
//  Created by Ihar_Karalko on 12/10/19.
//  Copyright © 2019 Ihar_Karalko. All rights reserved.
//

import Foundation
import CoreData

class DataSourceOfNote {
    
    private  var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.instance.persistentContainer.viewContext) {
        self.context = context
    }
}

extension DataSourceOfNote {
    func getNotes(notebook: Notebook) -> [Note] {
        var notes = [Note]()
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let predicate = NSPredicate(format: "notebook == %@", notebook)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate",
                                              ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let result = try? context.fetch(fetchRequest) {
            notes = result
        }
        
        return notes
    }
    
    func createNote(name: String, notebook: Notebook) -> Note {
        let note = Note(context: context)
        note.title = name
        note.creationDate = Date()
        note.notebook = notebook
        CoreDataManager.instance.saveContext()
        return note
    }
    
    func removeNote(note: Note) {
        context.delete(note)
        CoreDataManager.instance.saveContext()
    }
    
    func updateNote(note: Note, text:String) {
        note.text = text
        CoreDataManager.instance.saveContext()
    }
}
