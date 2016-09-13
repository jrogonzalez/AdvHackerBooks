//
//  Photo+CoreDataProperties.swift
//  AdvHackerbooks
//
//  Created by jro on 09/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData
 

extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var photoData: NSData?
    @NSManaged public var book: NSSet?

}
