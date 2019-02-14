//
//  Pet+CoreDataProperties.swift
//  w6d3-demo
//
//  Created by Roland on 2019-02-13.
//  Copyright © 2019 Game of Apps. All rights reserved.
//
//

import Foundation
import CoreData


extension Pet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pet> {
        return NSFetchRequest<Pet>(entityName: "Pet")
    }

    @NSManaged public var name: String?
    @NSManaged public var owner: Person?
    
    
    

}
