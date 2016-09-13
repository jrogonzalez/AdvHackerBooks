//
//  Photo+CoreDataClass.swift
//  AdvHackerbooks
//
//  Created by jro on 09/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData

@objc
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


// MARK: Generated accessors for book
extension Photo {
    
    @objc(addBookObject:)
    @NSManaged public func addToBook(_ value: Book)
    
    @objc(removeBookObject:)
    @NSManaged public func removeFromBook(_ value: Book)
    
    @objc(addBook:)
    @NSManaged public func addToBook(_ values: NSSet)
    
    @objc(removeBook:)
    @NSManaged public func removeFromBook(_ values: NSSet)
    
}

//Mark: - KVO
extension Photo{
    
    @nonobjc static let observableKeyNames = ["photoData"]
    
    //Nos vamos a observar a nosotros mismos para cuando cambie alguna propiedad podar actualizar la vista
    func setupKVO(){
        
        for key in Photo.observableKeyNames{
            self.addObserver(self,
                             forKeyPath: key,
                             options: [NSKeyValueObservingOptions.new , NSKeyValueObservingOptions.old] ,
                             context: nil) // este ultimo parametro es un puntero
        }
        
        
    }
    
    func tearDownKVO(){
        //Me doy de baja en todas las notificaciones
        for key in Photo.observableKeyNames{
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
extension Photo{
    
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
