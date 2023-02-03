//
//  VocabulayEntity+CoreDataProperties.swift
//  Core
//
//  Created by bongzniak on 2023/02/03.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//
//

import Foundation
import CoreData

extension VocabulayEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VocabulayEntity> {
        return NSFetchRequest<VocabulayEntity>(entityName: "VocabulayEntity")
    }

    @NSManaged public var title: String
    @NSManaged public var subtitle: String
}

extension VocabulayEntity : Identifiable {

}
