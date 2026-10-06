//
//  CoreDataModelFactory.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import CoreData
import Foundation

enum CoreDataModelFactory {

    static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let cachedGame = makeCachedGameEntity()

        model.entities = [
            cachedGame
        ]

        return model
    }

    private static func makeCachedGameEntity() -> NSEntityDescription {
        let entity = NSEntityDescription()

        entity.name = "CachedGame"
        entity.managedObjectClassName = NSStringFromClass(CachedGame.self)

        entity.properties = [
            attribute(
                name: "id",
                type: .UUIDAttributeType,
                optional: false
            ),
            attribute(
                name: "communityID",
                type: .UUIDAttributeType,
                optional: false
            ),
            attribute(
                name: "gameName",
                type: .stringAttributeType,
                optional: false
            ),
            attribute(
                name: "venueName",
                type: .stringAttributeType,
                optional: false
            ),
            attribute(
                name: "kickOffAt",
                type: .dateAttributeType,
                optional: false
            ),
            attribute(
                name: "finishesAt",
                type: .dateAttributeType,
                optional: false
            ),
            attribute(
                name: "playerCapacity",
                type: .integer64AttributeType,
                optional: false
            ),
            attribute(
                name: "registrationOpensAt",
                type: .dateAttributeType,
                optional: false
            ),
            attribute(
                name: "registrationClosesAt",
                type: .dateAttributeType,
                optional: false
            ),
            attribute(
                name: "cancellationDeadlineHours",
                type: .integer64AttributeType,
                optional: false
            ),
            attribute(
                name: "status",
                type: .stringAttributeType,
                optional: false
            ),
            attribute(
                name: "createdAt",
                type: .dateAttributeType,
                optional: false
            ),
            attribute(
                name: "createdByMemberID",
                type: .UUIDAttributeType,
                optional: false
            ),
            attribute(
                name: "lastSyncedAt",
                type: .dateAttributeType,
                optional: false
            )
        ]

        // Prevent duplicate cached copies of the same game.
        entity.uniquenessConstraints = [
            ["id"]
        ]

        return entity
    }

    private static func attribute(
        name: String,
        type: NSAttributeType,
        optional: Bool
    ) -> NSAttributeDescription {

        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = type
        attribute.isOptional = optional

        return attribute
    }
}