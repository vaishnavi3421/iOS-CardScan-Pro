//
//  CoreDataStack.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import Foundation
import CoreData

protocol CoreDataStackProtocol: AnyObject {
    var mainContext: NSManagedObjectContext { get }
    var backgroundContext: NSManagedObjectContext { get }
    func saveContext(_ context: NSManagedObjectContext)
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
}

final class CoreDataStack: CoreDataStackProtocol {
    
    static let shared = CoreDataStack()
    
    private let modelName: String
    
    init(modelName: String = AppConstants.CoreData.modelName) {
        self.modelName = modelName
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                // Log and gracefully fail instead of a crash in a real enterprise setup.
                print("Core Data Stack failed to load store: \(error), \(error.userInfo)")
            }
        }
        
        // Merge policies to automatically resolve in-memory conflicts
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    func saveContext(_ context: NSManagedObjectContext) {
        context.performAndWait {
            if context.hasChanges {
                do {
                    try context.save()
                    
                    // Save parent context if it exists
                    if let parent = context.parent {
                        self.saveContext(parent)
                    }
                } catch {
                    let nserror = error as NSError
                    print("Unresolved error saving context \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask { context in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            block(context)
        }
    }
}
