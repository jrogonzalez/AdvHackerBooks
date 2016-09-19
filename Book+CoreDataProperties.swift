//
//  Book+CoreDataProperties.swift
//  AdvHackerbooks
//
//  Created by jro on 18/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData 

extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book");
    }

    @NSManaged public var isFavourite: Bool
    @NSManaged public var title: String?
    @NSManaged public var isFinished: Bool
    @NSManaged public var lastPageReaded: Int16
    @NSManaged public var lastDateReaded: NSDate?
    @NSManaged public var note: NSSet?
    @NSManaged public var pdf: Pdf?
    @NSManaged public var photo: Photo?
    @NSManaged public var author: NSSet?
    @NSManaged public var bookTags: NSSet?

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

// MARK: Generated accessors for author
extension Book {

    @objc(addAuthorObject:)
    @NSManaged public func addToAuthor(_ value: Author)

    @objc(removeAuthorObject:)
    @NSManaged public func removeFromAuthor(_ value: Author)

    @objc(addAuthor:)
    @NSManaged public func addToAuthor(_ values: NSSet)

    @objc(removeAuthor:)
    @NSManaged public func removeFromAuthor(_ values: NSSet)

}

// MARK: Generated accessors for bookTags
extension Book {

    @objc(addBookTagsObject:)
    @NSManaged public func addToBookTags(_ value: BookTag)

    @objc(removeBookTagsObject:)
    @NSManaged public func removeFromBookTags(_ value: BookTag)

    @objc(addBookTags:)
    @NSManaged public func addToBookTags(_ values: NSSet)

    @objc(removeBookTags:)
    @NSManaged public func removeFromBookTags(_ values: NSSet)

}
