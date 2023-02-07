//
//  GroupEntity+CoreDataProperties.swift
//  Core
//
//  Created by bongzniak on 2023/02/07.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//
//

import Foundation
import CoreData


extension GroupEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupEntity> {
        return NSFetchRequest<GroupEntity>(entityName: "GroupEntity")
    }

    @NSManaged public var groupID: String?
    @NSManaged public var name: String?
}

extension GroupEntity : Identifiable {

}
