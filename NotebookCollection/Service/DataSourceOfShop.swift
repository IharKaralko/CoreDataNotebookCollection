//
//  DataSourseOfShop.swift
//  NotebookCollection
//
//  Created by Ihar Karalko on 28.11.2021.
//  Copyright © 2021 Ihar_Karalko. All rights reserved.
//

import Foundation
import CoreData

class DataSourceOfShop {
    private  var context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataManager.instance.persistentContainer.viewContext) {
        self.context = context
    }
}

extension DataSourceOfShop {
    func getShops() -> [Shop] {
        var shops = [Shop]()
        let fetchRequest = createFetchRequest()
        if let result = try? context.fetch(fetchRequest) {
            shops = result
        }
        return shops
    }

    func createShop(name: String) -> Shop {
        var shop = Shop(context: context)
        shop.name = name
        var notebooks = [Notebook]()
        let fetchRequest: NSFetchRequest<Notebook> = Notebook.fetchRequest()
        if let result = try? context.fetch(fetchRequest) {
            notebooks = result
        }
        shop.addToNotebooks(notebooks[0])
        shop.addToNotebooks(notebooks[1])
        CoreDataManager.instance.saveContext()
        return shop
    }


    func removeNotebook(shop: Shop) {
        context.delete(shop)
        CoreDataManager.instance.saveContext()
    }


    private func createFetchRequest() -> NSFetchRequest<Shop> {
        let fetchRequest: NSFetchRequest<Shop> = Shop.fetchRequest()
       // let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
       // fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
}

