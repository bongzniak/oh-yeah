//
//  CoreDataContainer.swift
//  Core
//
//  Created by bongzniak on 2023/02/02.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import Foundation
import CoreData

import RxSwift

// MARK: - Core Data stack

protocol CoreDataManagerType {
    func fetchVocabularies() -> [Vocabulary]
}

public final class CoreDataManager {
    
    public static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        
        let bundleID = "com.bongzniak.Core"
        let model = "dataModel"
        
        let bundle = Bundle(identifier: bundleID)
        let modelURL = bundle!.url(forResource: model, withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        
        let container =  NSPersistentCloudKitContainer(
            name: model,
            managedObjectModel: managedObjectModel
        )
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    private func saveContext() {
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
}

extension CoreDataManager: CoreDataManagerType {
    public func fetchVocabularies() -> [Vocabulary] {
        let request: NSFetchRequest<VocabulayEntity> = VocabulayEntity.fetchRequest()
        var fetchedResult: [VocabulayEntity] = []
        
        do {
            fetchedResult = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching vocabularies \(error)")
        }
        
        return fetchedResult.map {
            Vocabulary(spelling: $0.title ?? "", description: $0.subtitle ?? "asdads")
        }
    }
    
    public func saveVocabulary() -> VocabulayEntity {
        let test = VocabulayEntity(context: persistentContainer.viewContext)
        test.title = "appple"
        test.subtitle = "사과"
        
        saveContext()
        
        return test
    }
}
