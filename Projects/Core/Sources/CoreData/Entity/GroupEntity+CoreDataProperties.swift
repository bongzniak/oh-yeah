//
//  GroupEntity+CoreDataProperties.swift
//  Core
//
//  Created by bongzniak on 2023/02/08.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//
//

import Foundation
import CoreData


extension GroupEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupEntity> {
        return NSFetchRequest<GroupEntity>(entityName: "GroupEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var timestamp: Date
    
    @NSManaged public var vocabularies: NSSet?
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        id = UUID().uuidString
        name = ""
        timestamp = Date()
    }
}

// MARK: Generated accessors for vocabularies
extension GroupEntity {

    @objc(addVocabulariesObject:)
    @NSManaged public func addToVocabularies(_ value: VocabulayEntity)

    @objc(removeVocabulariesObject:)
    @NSManaged public func removeFromVocabularies(_ value: VocabulayEntity)

    @objc(addVocabularies:)
    @NSManaged public func addToVocabularies(_ values: NSSet)

    @objc(removeVocabularies:)
    @NSManaged public func removeFromVocabularies(_ values: NSSet)

}

extension GroupEntity : Identifiable {

}
