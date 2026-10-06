//
//  PersistenceController.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        let model = CoreDataModelFactory.makeModel()

        container = NSPersistentContainer(
            name: "ClubPlay",
            managedObjectModel: model
        )

        if inMemory {
            container.persistentStoreDescriptions.first?.url =
                URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error {
                fatalError(
                    "Core Data failed to load: \(error.localizedDescription)"
                )
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true

        container.viewContext.mergePolicy =
            NSMergeByPropertyObjectTrumpMergePolicy
    }
}