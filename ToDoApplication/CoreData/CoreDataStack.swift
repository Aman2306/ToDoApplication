//
//  CoreDataStack.swift
//  ToDoApplication
//
//  Created by Aman Meena on 09/03/19.
//  Copyright © 2019 Aman Meena. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    var container: NSPersistentContainer {
        let container  = NSPersistentContainer(name: "to_dos")
        container.loadPersistentStores { (description, error) in
            guard error == nil else {
                print("Error: \(String(describing: error))")
                return
            }
        }
        return container
    }
     
    var manageContext: NSManagedObjectContext {
        return container.viewContext
    }
}
