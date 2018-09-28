//
//  CoreDataManager.swift
//  iTunes Songs
//
//  Created by Sagar Dagdu on 9/12/18.
//  Copyright © 2018 Sagar Dagdu. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    var persistentContainer: NSPersistentContainer
    
    init(withPersistentContainer persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    // MARK: - Core Data Saving support
    
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
    
    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func mainContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
