//
//  Tag+CoreDataClass.swift
//  AdvHackerbooks
//
//  Created by jro on 09/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData


public class Tag: NSManagedObject {

    static let entityName = "Tag"
    
    init(withBook book: Book, tagText: String, context: NSManagedObjectContext){
        //Obtain the entity
        let ent = NSEntityDescription.entity(forEntityName: Tag.entityName, in: context)!
        
        //Call the super
        super.init(entity: ent, insertInto: context)
        
        self.book = book
        tagName = tagText
        
    }
}
