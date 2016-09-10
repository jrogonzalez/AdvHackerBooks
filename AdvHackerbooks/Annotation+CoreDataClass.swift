//
//  Annotation+CoreDataClass.swift
//  AdvHackerbooks
//
//  Created by jro on 09/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData


public class Annotation: NSManagedObject {

    static let entityName = "Annotation"
    
    init(withBook book: Book, annotationText: String, context: NSManagedObjectContext){
        
        // Obtain the entity description
        let ent = NSEntityDescription.entity(forEntityName: Annotation.entityName, in: context)!
        
        // Call super
        super.init(entity: ent, insertInto: context)
        
        self.book = book
        text = annotationText
        
    }
}
