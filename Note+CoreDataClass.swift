//
//  Note+CoreDataClass.swift
//  AdvHackerbooks
//
//  Created by jro on 14/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData


public class Note: NSManagedObject {
    static let entityName = "Note"
    
    convenience init(withBook book: Book, text: String , context: NSManagedObjectContext){
        //create the entity
        let entity = NSEntityDescription.entity(forEntityName: Note.entityName, in: context)!
        
        //call the super
        self.init(entity: entity, insertInto: context)
        
        // fill the properties
        self.book = book
        self.text = text
        
        book.addToNote(self)
        
    }

}

//Mark: - KVO
extension Note{
    
    @nonobjc static let observableKeyNames = ["text"]
    
    //Nos vamos a observar a nosotros mismos para cuando cambie alguna propiedad podar actualizar la vista
    func setupKVO(){
        
        for key in Note.observableKeyNames{
            self.addObserver(self,
                             forKeyPath: key,
                             options: [NSKeyValueObservingOptions.new , NSKeyValueObservingOptions.old] ,
                             context: nil) // este ultimo parametro es un puntero
        }
        
        
    }
    
    func tearDownKVO(){
        //Me doy de baja en todas las notificaciones
        for key in Note.observableKeyNames{
            self.removeObserver(self, forKeyPath: key)
        }
    }
    
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        
    }
}

//Mark: - lifeCycle
extension Note{
    
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


