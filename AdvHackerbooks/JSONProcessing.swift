//
//  JSONProcessing.swift
//  HackerBooks
//
//  Created by jro on 04/07/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/*
 {
 "authors": "Caleb Doxsey",
 "image_url": "http://hackershelf.com/media/cache/09/ad/09ad5199bbacbc8180465378365e8b4e.jpg",
 "pdf_url": "http://www.golang-book.com/assets/pdf/gobook.pdf",
 "tags": "programming, go, golang",
 "title": "An Introduction to Programming in Go"
 },
 */

//MARK: - Aliases
typealias   JSONObject      =   AnyObject
typealias   JSONDictionary  =   [String:   JSONObject]
typealias   JSONArray       =   [JSONDictionary]

let urlHackerBooks = "https://t.co/K9ziV0z3SJ"
let fileBooks = "HackerBooks.txt"
let favouriteBooks = "FavouriteBooks.txt"

func decode(book json: JSONDictionary, context: NSManagedObjectContext) throws  -> Book {
    
    //Validamos el dict
    guard let author = json["authors"] as? String else{
        throw BookErrors.wrongJSONFormat
    }
    
    _ = author.components(separatedBy: ",")
//    var aut = Set<String>()
//    for each in components{
//        aut.insert(each.trimmingCharacters(in: NSCharacterSet.whitespaces))
//    }
    
    guard let imageString = json["image_url"] as? String else{
      throw BookErrors.wrongJSONFormat
    }
    
    let imageData = try loadDataFromRemoteFile(fileURL: imageString)
    
    guard let pdfString = json["pdf_url"] as? String else{
            throw  BookErrors.wrongJSONFormat
    }
    
    let pdfData = try loadDataFromRemoteFile(fileURL: pdfString)
    
    guard let tags = json["tags"] as? String else{
        throw BookErrors.wrongJSONFormat
    }
    
    let tagArray = tags.components(separatedBy: ",")
    
    var tagSet = Set<String>()
    for each in tagArray{
        tagSet.insert(each.trimmingCharacters(in: NSCharacterSet.whitespaces))
    }
//    let tag = Tag(context: tagSet)
    
    
    guard let title = json["title"] as? String else{
            throw BookErrors.wrongJSONFormat
    }
    
//    return Book(authors: aut, image: imageString, pdf: pdfString, tags: tag, title: title, isFavourite: false)
    
    return Book(withTitle: title, inAuthors: author, inTags: tagSet, inPdf: pdfData, inPhoto: imageData, inFavourite: false, inAnnotation: nil, context: context)
}


//func encode(book: Book) throws  -> AnyObject {
//    
//    //creamos el json
//    let json : AnyObject = [
//            "authors": Array(book.authors).joinWithSeparator(","),
//            "image_url":book.image,
//            "pdf_url":book.pdf,
//            "tags":Array(book.tags.tags).joinWithSeparator(","),
//            "title": book.title
//        
//    ]
//    
//    return json
//}

func readJSON(context: NSManagedObjectContext) throws -> [Book]{
    
    var json : JSONArray = JSONArray()
    let defaults = UserDefaults.standard
    let fileCache = obtainLocalCacheUrlDocumentsFile(file: fileBooks)
    let file = obtainLocalUrlDocumentsFile(file: fileBooks)
    
    do{
    
        // Si existe la variable es que ya hemos cargado el fichero anteriormente
        let nombre = defaults.string(forKey: "JSON_Data")
        
        if nombre != nil {
            // Comprobamos si tenemos los datos en Cache sino en local y sino tiramos de remoto
            if let cache = loadFromLocalFile(fileName: fileCache.absoluteString!){
               json = cache
            }else if let aux = loadFromLocalFile(fileName: file.absoluteString!){
               json = aux
            }else{
                // Por seguridad cargamos desde remoto de nuevo
                json = try loadFromRemoteFile(fileURL: urlHackerBooks)
            }
            
        } else{
            // Comprobamos el la URL para cargarlos
            json = try loadFromRemoteFile(fileURL: urlHackerBooks)

        }
        
        var chars = [Book]()
        for dict in json{
            do{
                let char = try decode(book: dict, context: context)
                chars.append(char)
            }catch{
                print("error al procesar \(dict)")
            }
        }
        
        return chars

    }catch{
        throw BookErrors.wrongJSONFormat
    }
  
    
}




