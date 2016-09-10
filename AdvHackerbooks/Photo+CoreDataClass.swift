//
//  Photo+CoreDataClass.swift
//  AdvHackerbooks
//
//  Created by jro on 09/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData


public class Photo: NSManagedObject {

    static let entityName = "Photo"
    
    init(withBook book: Book, photoData : NSData, context: NSManagedObjectContext){
        //Obtain the entity
        let ent = NSEntityDescription.entity(forEntityName: Photo.entityName, in: context)!
        
        //call super
        super.init(entity: ent, insertInto: context)
        
        self.addToBook(book)
        self.photoData = photoData
        
    }
}
