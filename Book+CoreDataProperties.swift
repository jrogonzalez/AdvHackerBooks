//
//  Book+CoreDataProperties.swift
//  AdvHackerbooks
//
//  Created by jro on 14/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData

extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book");
    }

    @NSManaged public var authors: String?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var title: String?
    @NSManaged public var pdf: Pdf?
    @NSManaged public var photo: Photo?
    @NSManaged public var tag: NSSet?
    @NSManaged public var note: NSSet?

}

// MARK: Generated accessors for tag
extension Book {

    @objc(addTagObject:)
    @NSManaged public func addToTag(_ value: Tag)

    @objc(removeTagObject:)
    @NSManaged public func removeFromTag(_ value: Tag)

    @objc(addTag:)
    @NSManaged public func addToTag(_ values: NSSet)

    @objc(removeTag:)
    @NSManaged public func removeFromTag(_ values: NSSet)

}

// MARK: Generated accessors for note
extension Book {

    @objc(addNoteObject:)
    @NSManaged public func addToNote(_ value: Note)

    @objc(removeNoteObject:)
    @NSManaged public func removeFromNote(_ value: Note)

    @objc(addNote:)
    @NSManaged public func addToNote(_ values: NSSet)

    @objc(removeNote:)
    @NSManaged public func removeFromNote(_ values: NSSet)

}
