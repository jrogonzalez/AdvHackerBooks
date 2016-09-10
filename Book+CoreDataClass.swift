//
//  Book+CoreDataClass.swift
//  AdvHackerbooks
//
//  Created by jro on 09/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData


public class Book: NSManagedObject {
    
    static let entityName = "Book"
    
    init(withTitle: String, inAuthors: String, inTags: Set<String>,  inPdf: NSData, inPhoto: NSData, inFavourite: Bool, inAnnotation: String?, context: NSManagedObjectContext){
        //Obtain the entity
        let ent = NSEntityDescription.entity(forEntityName: Book.entityName, in: context)!
        
        //Call the super
        super.init(entity: ent, insertInto: context)
        
        self.title = withTitle
//        self.authors = authors
        
        // Inserts all tags
        for key in inTags{
            let tag = Tag(withBook: self, tagText: key, context: context)
            self.addToTag(tag)
        }
        
        
        let pdf = Pdf(withBook: self, pdf: inPdf, context: context)
        self.pdf = pdf
        
        let photo = Photo(withBook: self, photoData: inPhoto, context: context)
        self.photo = photo
        
        self.isFavourite = inFavourite
        
        if let annotation = inAnnotation {
            let annotationInstance = Annotation(withBook: self, annotationText: annotation, context: context)
            self.annotation = annotationInstance
            
        }
        
        
    }

}
