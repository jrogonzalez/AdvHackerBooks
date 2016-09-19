//
//  BookTag+CoreDataClass.swift
//  AdvHackerbooks
//
//  Created by jro on 18/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData


public class BookTag: NSManagedObject {

    static let entityName = "BookTag"
    
    convenience init(withBook book: Book, tag: String, context: NSManagedObjectContext){

//            //Search for the instance
//            if searchBooktag(forBook: book, tag: tag, context: context) != nil {
//                
//            }else{
                //Create the entity
                // obtain the entity
                let entity = NSEntityDescription.entity(forEntityName: BookTag.entityName, in: context)!
                
                self.init(entity: entity, insertInto: context)
                
                self.book = book
                self.tag = Tag(withBookTag: self, tagText: tag, context: context)
//            }
        
        
        

    }
    
    
    func searchBooktag(forBook book: Book, tag: String, context: NSManagedObjectContext) -> BookTag?{
        //fetched reqest
        let req = NSFetchRequest<BookTag>(entityName: "BookTag")
        req.fetchLimit = 1
        
        let predicate = NSPredicate(format: "book == %@ AND tag == %@", tag, book)
        req.predicate = predicate
        
        do {
            let str = try context.fetch(req)
            if str.count > 0 {
                return str[0]
            }
            else{
                return BookTag(withBook: book, tag: tag, context: context)
            }
            
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return nil
        
    }

}
