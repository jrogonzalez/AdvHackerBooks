//
//  BookTag+CoreDataProperties.swift
//  AdvHackerbooks
//
//  Created by jro on 18/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData 

extension BookTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookTag> {
        return NSFetchRequest<BookTag>(entityName: "BookTag");
    }

    @NSManaged public var book: Book?
    @NSManaged public var tag: Tag?

}
