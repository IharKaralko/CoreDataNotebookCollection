//
//  DataSourceOfNotebook.swift
//  NotebookCollection
//
//  Created by Ihar_Karalko on 12/10/19.
//  Copyright © 2019 Ihar_Karalko. All rights reserved.
//

import Foundation
import CoreData

class DataSourceOfNotebook {
    private  var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.instance.persistentContainer.viewContext){
        self.context = context
    }
}

extension DataSourceOfNotebook {
    func getNotebooks() -> [Notebook]{
        var notebooks = [Notebook]()
        let fetchRequest = createFetchRequest()
        if let result = try? context.fetch(fetchRequest) {
            notebooks = result
        }
        
        return notebooks
    }
    
    func createNotebook(name: String) -> Notebook {
        let notebook = Notebook(context: context)
        notebook.name = name
        notebook.creationDate = Date()
        CoreDataManager.instance.saveContext()
        return notebook
    }
    
    func createNotebookForFRC(name: String) {
        let notebook = Notebook(context: context)
        notebook.name = name
        notebook.creationDate = Date()
        CoreDataManager.instance.saveContext()
    }
    
    func removeNotebook(notebook: Notebook) {
        context.delete(notebook)
        CoreDataManager.instance.saveContext()
    }
    
    func setupFetchedResultsController() -> NSFetchedResultsController<Notebook> {
         let fetchRequest = createFetchRequest()
       let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: "notebooks")
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        return fetchedResultsController
    }
    
    
private func createFetchRequest() -> NSFetchRequest<Notebook> {
        let fetchRequest: NSFetchRequest<Notebook> = Notebook.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate",
                                              ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
}
