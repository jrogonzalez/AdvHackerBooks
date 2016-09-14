//
//  Book+CoreDataClass.swift
//  AdvHackerbooks
//
//  Created by jro on 09/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData

@objc
public class Book: NSManagedObject {
    
    static let entityName = "Book"
    
    init(withTitle: String, inAuthors: String, inTags: Set<String>,  inPdf: String?, inPhoto: NSData, inFavourite: Bool, inNote: String?, context: NSManagedObjectContext){
        //Obtain the entity
        let ent = NSEntityDescription.entity(forEntityName: Book.entityName, in: context)!
        
        //Call the super
        super.init(entity: ent, insertInto: context)
        
        self.title = withTitle
        self.authors = inAuthors
        
        // Inserts all tags
        for key in inTags{
            let tag = Tag(withBook: self, tagText: key, context: context)
            self.addToTag(tag)
        }
        
        if inPdf != nil {
            let pdf = Pdf(withBook: self, pdf: inPdf, context: context)
            self.pdf = pdf
            
            
        }
        
        let photo = Photo(withBook: self, photoData: inPhoto, context: context)
        self.photo = photo
        
        self.isFavourite = inFavourite
        
        if let note = inNote {
            let noteInstance = Note(withBook: self, text: note, context: context)
            self.note = noteInstance
            
        }
        
        
    }

}


//Mark: - KVO
extension Book{
    
    @nonobjc static let observableKeyNames = ["note.text", "isFavourite"]
    
    //Nos vamos a observar a nosotros mismos para cuando cambie alguna propiedad podar actualizar la vista
    func setupKVO(){
        
        for key in Book.observableKeyNames{
            self.addObserver(self,
                             forKeyPath: key,
                             options: [NSKeyValueObservingOptions.new , NSKeyValueObservingOptions.old] ,
                             context: nil) // este ultimo parametro es un puntero
        }
        
        
    }
    
    func tearDownKVO(){
        //Me doy de baja en todas las notificaciones
        for key in Book.observableKeyNames{
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
extension Book{
    
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


