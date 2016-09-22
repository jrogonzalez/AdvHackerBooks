//
//  Note+CoreDataProperties.swift
//  AdvHackerbooks
//
//  Created by jro on 22/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note");
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var modificationDate: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var book: Book?
    @NSManaged public var photo: Photo?
    @NSManaged public var location: Localization?

}
