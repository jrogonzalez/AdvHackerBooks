//
//  Pdf+CoreDataClass.swift
//  AdvHackerbooks
//
//  Created by jro on 09/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData

@objc
public class Pdf: NSManagedObject {
    
    static let entityName = "Pdf"
    
    //Creamos una propiedad computada, setter y getter personalizados
    var pdf : Data?{
        get{
            guard let inPdf = pdfData else {
                return nil
            }
            let auxPdf = Data(referencing: inPdf)
            
            return auxPdf
        }
        set{
            guard let auxPdf = newValue else {
                pdfData = nil
                return
            }
            pdfData = NSData(data: auxPdf)
        }
    }
    
    
    convenience init(withBook book :Book, pdf: String?, context: NSManagedObjectContext){
        
        //Obtain the etitiDescription
        let ent = NSEntityDescription.entity(forEntityName: Pdf.entityName, in: context)!
        
        //call super
        self.init(entity: ent, insertInto: context)
        
        //fill the properties
        self.book = book
        pdfURL = pdf
        
    }
    
    convenience init(withBook book :Book, pdfData: NSData, context: NSManagedObjectContext){
        
        //Obtain the etitiDescription
        let ent = NSEntityDescription.entity(forEntityName: Pdf.entityName, in: context)!
        
        //call super
        self.init(entity: ent, insertInto: context)
        
        //fill the properties
        self.book = book
        self.pdfData = pdfData
        
    }

}


//Mark: - KVO
extension Pdf{
    
    //Hay qu marcarlo como nonobjc
    @nonobjc static let observableKeyNames = ["pdfData"]
    
//    static func observableKeyNames() -> [String] { return ["pdfData"]}
    
    //Nos vamos a observar a nosotros mismos para cuando cambie alguna propiedad podar actualizar la vista
    func setupKVO(){
        
        for key in Pdf.observableKeyNames{
            self.addObserver(self,
                             forKeyPath: key,
                             options: [NSKeyValueObservingOptions.new , NSKeyValueObservingOptions.old] ,
                             context: nil) // este ultimo parametro es un puntero
        }
        
        
    }
    
    func tearDownKVO(){
        //Me doy de baja en todas las notificaciones
        for key in Pdf.observableKeyNames{
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
extension Pdf{
    
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
