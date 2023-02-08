//
//  VocabulayEntity+CoreDataProperties.swift
//  Core
//
//  Created by bongzniak on 2023/02/08.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//
//

import Foundation
import CoreData


extension VocabulayEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VocabulayEntity> {
        return NSFetchRequest<VocabulayEntity>(entityName: "VocabulayEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var spelling: String
    @NSManaged public var desc: String
    @NSManaged public var sentence: String
    @NSManaged public var timestamp: Date
    
    @NSManaged public var group: GroupEntity?
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        logger.debug("UUID >> ", UUID().uuidString)
        id = UUID().uuidString
        spelling = ""
        desc = ""
        sentence = ""
        timestamp = Date()
    }

}

extension VocabulayEntity : Identifiable {

}
