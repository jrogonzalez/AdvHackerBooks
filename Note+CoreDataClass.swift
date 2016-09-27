//
//  Note+CoreDataClass.swift
//  AdvHackerbooks
//
//  Created by jro on 14/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

public class Note: NSManagedObject {
    static let entityName = "Note"
    var locationManager : CLLocationManager?
    
    var hasLocation: Bool {
        get{
           return self.location != nil
        }
    }
    
    
    convenience init(withBook book: Book, text: String , context: NSManagedObjectContext){
        //create the entity
        let entity = NSEntityDescription.entity(forEntityName: Note.entityName, in: context)!
        
        //call the super
        self.init(entity: entity, insertInto: context)
        
        // fill the properties
        self.book = book
        self.text = text
        creationDate = Date.init() as NSDate?
        modificationDate = Date.init() as NSDate?
        
        book.addToNote(self)
        
    }

}

//Mark: - KVO
extension Note{
    
    @nonobjc static let observableKeyNames = ["text", "location.longitude", "location.latitude", "location.address", "book", "photo.photoData"]
    
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
        
        modificationDate = Date.init() as NSDate?
    }
}

//Mark: - lifeCycle
extension Note: CLLocationManagerDelegate{
    
    // se llama una sola vez
    public override func awakeFromInsert() {
        //hay que activar un par de propiedades dentro del info.plist (NSLocationAlwaysUsageDescription y NSLocationWhenInUseUsageDescription) con los valores que deseemos que aparezcan en la aplicacion al pedirte permiso para acceder a a geolocalizacion
        //http://stackoverflow.com/questions/24050633/implement-cllocationmanagerdelegate-methods-in-swift/24056771#24056771
        
        super.awakeFromInsert()
        
        setupKVO()
        
        let status = CLLocationManager.authorizationStatus()
        
        if ((status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.notDetermined) && CLLocationManager.locationServicesEnabled()){
            //We are authorized
            self.locationManager = CLLocationManager.init()
            self.locationManager?.delegate = self
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager?.requestAlwaysAuthorization()
            self.locationManager?.startUpdatingLocation()
            
            // only take the recent data
            let deadlineTime = DispatchTime.now() + .seconds(30)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                print("DispatchAfter : \(Date())")
//                self.zapLocationManager()
            }
        }
    }
    
    func zapLocationManager(){
        // Stop
        self.locationManager?.stopUpdatingLocation()
        self.locationManager?.delegate = nil
        self.locationManager = nil
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

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error en la GEOLOCALIZACION")
    }
    
    
    //MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Stop
        self.zapLocationManager()
        
        if !self.hasLocation {
            // take the last location
            let loc = locations.last
            
            
            _ = Localization(withNote: self, location: loc!, context: self.managedObjectContext!)
            
        }else{
            print("We should never reach here")
        }
        
        
    }
}


