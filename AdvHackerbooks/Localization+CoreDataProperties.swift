//
//  Localization+CoreDataProperties.swift
//  AdvHackerbooks
//
//  Created by jro on 22/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData

extension Localization {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Localization> {
        return NSFetchRequest<Localization>(entityName: "Localization");
    }
    
    @NSManaged public var title: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var locationName: String?
    @NSManaged public var discipline: String?
    @NSManaged public var notes: NSSet?
    
}

// MARK: Generated accessors for notes
extension Localization {
    
    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Note)
    
    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Note)
    
    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)
    
    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)
    
}
