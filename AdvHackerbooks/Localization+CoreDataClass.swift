//
//  Localization+CoreDataClass.swift
//  AdvHackerbooks
//
//  Created by jro on 09/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation
import AddressBookUI

@objc
public class Localization: NSManagedObject {
    
    static let entityName = "Localization"

    convenience init(withNote note: Note, location: CLLocation , context: NSManagedObjectContext){
        //obtain the entity
        let entity = NSEntityDescription.entity(forEntityName: Localization.entityName, in: context)!
        
        //call the super
        self.init(entity: entity, insertInto: context)
        
        self.addToNotes(note)
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        
        
        let geo = CLGeocoder.init()
        geo.reverseGeocodeLocation(location) { (Placemarkets, error) in
            if (error != nil) {
                print("Error while obtaining address")
            }else{
                self.address = ABCreateStringWithAddressDictionary((Placemarkets?.last?.addressDictionary)!, true)
            }
        }
        
    }
}

//Mark: - KVO
extension Localization{
    
    @nonobjc static let observableKeyNames = ["latitude", "longitude", "address", "notes.text"]
    
    //Nos vamos a observar a nosotros mismos para cuando cambie alguna propiedad podar actualizar la vista
    func setupKVO(){
        
        for key in Localization.observableKeyNames{
            self.addObserver(self,
                             forKeyPath: key,
                             options: [NSKeyValueObservingOptions.new , NSKeyValueObservingOptions.old] ,
                             context: nil) // este ultimo parametro es un puntero
        }
        
        
    }
    
    func tearDownKVO(){
        //Me doy de baja en todas las notificaciones
        for key in Localization.observableKeyNames{
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
extension Localization{
    
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

