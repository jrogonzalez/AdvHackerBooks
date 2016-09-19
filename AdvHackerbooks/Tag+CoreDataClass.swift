//
//  Tag+CoreDataClass.swift
//  AdvHackerbooks
//
//  Created by jro on 09/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData

@objc
public class Tag: NSManagedObject {

    static let entityName = "Tag"
    
    convenience init(withBookTag bookTag: BookTag, tagText: String, context: NSManagedObjectContext){
            //Obtain the entity
            let ent = NSEntityDescription.entity(forEntityName: Tag.entityName, in: context)!
            
            //Call the super
            self.init(entity: ent, insertInto: context)
            
            self.addToBookTags(bookTag)
            tagName = tagText
        
    }
    
    
    func searchTag(forBookTag bookTag: BookTag, TagName tagName: String, context: NSManagedObjectContext) -> Tag?{
        //fetched reqest
        let req = NSFetchRequest<Tag>(entityName: "Tag")
        req.fetchLimit = 1
        
        let predicate = NSPredicate(format: "tagName == %@", tagName)
        req.predicate = predicate
        
        //        let frc = NSFetchedResultsController(fetchRequest: req, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            let str = try context.fetch(req)
            if str.count > 0 {
                return str[0]
            }else{
                //Create the Element
               return Tag(withBookTag: bookTag, tagText: tagName, context: context)
            }
            
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return nil
        
    }

}

//Mark: - KVO
extension Tag{
    
    @nonobjc static let observableKeyNames = ["tagName"]
    
    //Nos vamos a observar a nosotros mismos para cuando cambie alguna propiedad podar actualizar la vista
    func setupKVO(){
        
        for key in Tag.observableKeyNames{
            self.addObserver(self,
                             forKeyPath: key,
                             options: [NSKeyValueObservingOptions.new , NSKeyValueObservingOptions.old] ,
                             context: nil) // este ultimo parametro es un puntero
        }
        
        
    }
    
    func tearDownKVO(){
        //Me doy de baja en todas las notificaciones
        for key in Tag.observableKeyNames{
            self.removeObserver(self, forKeyPath: key)
        }
    }
    
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        //modificationDate = NSDate()
    }
}

//Mark: - lifeCycle
extension Tag{
    
    // se llama una sola vez
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setupKVO()
    }
    
    // Se llama un cerro de veces
    public override func awakeFromFetch() {
        super.awakeFromFetch()
        
        setupKVO()
    }
    
    public override func willTurnIntoFault() {
        super.willTurnIntoFault()
        
        tearDownKVO()
    }
}

