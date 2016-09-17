//
//  Photo+CoreDataClass.swift
//  AdvHackerbooks
//
//  Created by jro on 09/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc
public class Photo: NSManagedObject {

    static let entityName = "Photo"
    
    //Creamos una propiedad computada, setter y getter personalizados
    var image : UIImage?{
        get{
            guard let img = photoData else {
                return nil
            }
            return UIImage(data: img as Data)
        }
        set{
            guard let img = newValue else {
                photoData = nil
                return
            }
            photoData = UIImageJPEGRepresentation(img, 0.9) as NSData?
        }
    }

    
    
    convenience init(withBook book: Book, photoData : UIImage?, context: NSManagedObjectContext){
        //Obtain the entity
        let ent = NSEntityDescription.entity(forEntityName: Photo.entityName, in: context)!
        
        //call super
        self.init(entity: ent, insertInto: context)
        
        self.addToBook(book)
        
        
        if let img = photoData {
            self.image = img
        }else{
            // create a noImage
            self.image = UIImage(imageLiteralResourceName: "NoImageAvailable.png")
            
        }
        
        self.photoURL = Bundle.main.URLForResourceCaca(name: "NoImageAvailable.png")?.absoluteString
        
    }
    
    convenience init(withBook book: Book, photoString : String?, context: NSManagedObjectContext){
        //Obtain the entity
        let ent = NSEntityDescription.entity(forEntityName: Photo.entityName, in: context)!
        
        //call super
        self.init(entity: ent, insertInto: context)
        
        self.addToBook(book)
        
        
        
        if let img = photoString {
            self.photoURL = img
        }else{
            // create a noImage
            self.image = UIImage(imageLiteralResourceName: "NoImageAvailable.png")
            self.photoURL = Bundle.main.URLForResourceCaca(name: "NoImageAvailable.png")?.absoluteString
        }
        
    }
    
    convenience init(withNote note: Note, photoData : UIImage?, context: NSManagedObjectContext){
        //Obtain the entity
        let ent = NSEntityDescription.entity(forEntityName: Photo.entityName, in: context)!
        
        //call super
        self.init(entity: ent, insertInto: context)
        
        self.addToNote(note)
        
        
        if let img = photoData {
            self.image = img
        }else{
            // create a noImage
            self.image = UIImage(imageLiteralResourceName: "NoImageAvailable.png")
            
        }
        
        self.photoURL = Bundle.main.URLForResourceCaca(name: "NoImageAvailable.png")?.absoluteString
        
    }

}


//// MARK: Generated accessors for book
//extension Photo {
//    
//    @objc(addBookObject:)
//    @NSManaged public func addToBook(_ value: Book)
//    
//    @objc(removeBookObject:)
//    @NSManaged public func removeFromBook(_ value: Book)
//    
//    @objc(addBook:)
//    @NSManaged public func addToBook(_ values: NSSet)
//    
//    @objc(removeBook:)
//    @NSManaged public func removeFromBook(_ values: NSSet)
//    
//}

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
