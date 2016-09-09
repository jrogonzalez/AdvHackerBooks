//
//  Pdf+CoreDataClass.swift
//  AdvHackerbooks
//
//  Created by jro on 09/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import CoreData


public class Pdf: NSManagedObject {
    
    static let entityName = "Pdf"
    
    init(withBook book :Book, pdf: NSData, context: NSManagedObjectContext){
        
        //Obtain the etitiDescription
        let ent = NSEntityDescription.entity(forEntityName: Pdf.entityName, in: context)!
        
        //call super
        super.init(entity: ent, insertInto: context)
        
        //fill the properties
        self.book = book
        pdfData = pdf
        
    }

}
