//
//  DataSourceOfNoteContent.swift
//  NotebookCollection
//
//  Created by Ihar_Karalko on 12/16/19.
//  Copyright © 2019 Ihar_Karalko. All rights reserved.
//

import Foundation
import CoreData

class DataSourceOfNoteContent {
    private  var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.instance.persistentContainer.viewContext) {
        self.context = context
    }
}

extension DataSourceOfNoteContent {
    func getNoteContent(note: Note) -> NoteContent{
        let fetchRequest: NSFetchRequest<NoteContent> = NoteContent.fetchRequest()
        let predicate = NSPredicate(format: "note == %@", note)
        fetchRequest.predicate = predicate
        if let result = try? context.fetch(fetchRequest), let content = result.first {
            let noteContent = content
            return  noteContent
        } else {
            let noteContent = createNoteContent(note: note)
            return noteContent
        }
    }
    
    func createNoteContent(note: Note) -> NoteContent {
        let noteContent = NoteContent(context: context)
        noteContent.textID = UUID().uuidString
        noteContent.attributedText = NSAttributedString(string: " ")
        noteContent.note = note
        CoreDataManager.instance.saveContext()
        return noteContent
    }
    
    func removeNote(note: Note) {
        context.delete(note)
        CoreDataManager.instance.saveContext()
    }
    
    func updateText(note: Note, text: NSAttributedString) {
        note.noteContent?.attributedText = text
        CoreDataManager.instance.saveContext()
    }
}
