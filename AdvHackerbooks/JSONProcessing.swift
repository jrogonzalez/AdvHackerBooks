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
let localFile = Bundle.main.path(forResource: "books_readable", ofType: "json")


let url = Bundle.main.url(forResource: "books_readable", withExtension: "json")
let dataLocal = NSData(contentsOf: url!)!


func decode(book json: JSONDictionary, context: NSManagedObjectContext) throws  {
    
    //Validamos el dict
    guard let author = json["authors"] as? String else{
        throw BookErrors.wrongJSONFormat
    }
    
    let components = author.components(separatedBy: ",")
    var authorSet = Set<String>()
    for each in components{
        authorSet.insert(each.trimmingCharacters(in: NSCharacterSet.whitespaces))
    }
    
    guard let imageURL = json["image_url"] as? String else{
      throw BookErrors.wrongJSONFormat
    }
    
//    let imageData = try loadDataFromRemoteFile(fileURL: imageString)
    
    guard let pdfString = json["pdf_url"] as? String else{
            throw  BookErrors.wrongJSONFormat
    }
    
    //let pdfData = try loadDataFromRemoteFile(fileURL: pdfString)
    
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
    
    _ = Book(withTitle: title,
                inAuthors: authorSet,
                inTags: tagSet,
                inPdf: pdfString,
                inPhoto: imageURL,
                inFavourite: false,
                inNote: nil,
                context: context)
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

func readJSON(context: NSManagedObjectContext, local: Bool) throws {
    
    var json : JSONArray = JSONArray()
    
    do{
        if local {
            // Comprobamos si tenemos los datos en Cache sino en local y sino tiramos de remoto
            if let cache = try loadDataFromLocalFile(withURL: url!){
               json = cache
            }else{
                // we ensure if there are some problem with the local file we can get the data from the URL
                json = try loadFromRemoteFile(fileURL: urlHackerBooks)
            }
        } else{
            // Comprobamos el la URL para cargarlos
            json = try loadFromRemoteFile(fileURL: urlHackerBooks)

        }

        for dict in json{
            do{
                try decode(book: dict, context: context)
            }catch{
                print("error al procesar \(dict)")
            }
        }

    }catch{
        throw BookErrors.wrongJSONFormat
    }
  
    
}

//func parseLocal(){
//    
//    do {
//        let object = try JSONSerialization.jsonObject(with: dataLocal as Data, options: .allowFragments)
//        if let dictionary = object as? [String: AnyObject] {
//            readJSONObject(object: dictionary)
//        }
//    } catch {
//        // Handle Error
//    }
//}
//
//func readJSONObject(object: [String: AnyObject]) {
//    guard let title = object["dataTitle"] as? String,
//        let version = object["swiftVersion"] as? Float,
//        let users = object["users"] as? [[String: AnyObject]] else { return }
//    _ = "Swift \(version) " + title
//    
//    for user in users {
//        guard let name = user["name"] as? String,
//            let age = user["age"] as? Int else { break }
//        switch age {
//        case 22:
//            _ = name + " is \(age) years old."
//        case 25:
//            _ = name + " is \(age) years old."
//        case 29:
//            _ = name + " is \(age) years old."
//        default:
//            break
//        }
//    }
//}

//func loadImage() throws -> UIImage?{
//    
//    //Probamos a buscarla en local
//    let localURLCache = obtainLocalCacheUrlDocumentsFile(fileForResourceName(self.image))
//    let localURL = obtainLocalUrlDocumentsFile(fileForResourceName(self.image))
//    
//    //Buscamos en la cache
//    if let imgDataCache = NSData(contentsOfURL: localURLCache),
//        imageCache = UIImage(data: imgDataCache) {
//        
//        return imageCache
//        
//    }else if let imgData = NSData(contentsOfURL: localURL),
//        image = UIImage(data: imgData) {
//        
//        return image
//        
//    }else{
//        
//        //Si no esta en local probamos en remoto
//        if let imgURL = NSURL(string: self.image),
//            imgData = NSData(contentsOfURL: imgURL),
//            image = UIImage(data: imgData) {
//            
//            do{
//                try imgData.writeToURL(localURLCache, options: NSDataWritingOptions.AtomicWrite)
//                try imgData.writeToURL(localURL, options: NSDataWritingOptions.AtomicWrite)
//            }catch{
//                throw BookErrors.imageNotFound
//            }
//            return image
//        }
//    }
//    
//    return nil
//}
//
//
//func loadPdf() throws -> NSURLRequest?{
//    
//    //Probamos a buscarla en local
//    let localURLCache = obtainLocalCacheUrlDocumentsFile(fileForResourceName(self.pdf))
//    let localURL = obtainLocalUrlDocumentsFile(fileForResourceName(self.pdf))
//    
//    
//    if NSData(contentsOfURL: localURLCache) != nil{
//        let pdfCache = NSURLRequest(URL: localURLCache)
//        
//        return pdfCache
//    }else if NSData(contentsOfURL: localURL) != nil{
//        let pdf = NSURLRequest(URL: localURL)
//        
//        return pdf
//    }else{
//        
//        //Si no esta en local probamos en remoto
//        let pdfURL = NSURL(string: self.pdf)
//        let pdf = NSURLRequest(URL: pdfURL!)
//        
//        
//        do{
//            if let pdfData = NSData(contentsOfURL: pdfURL!) {
//                try pdfData.writeToURL(localURLCache, options: NSDataWritingOptions.AtomicWrite)
//                try pdfData.writeToURL(localURL, options: NSDataWritingOptions.AtomicWrite)
//            }
//            
//        }catch{
//            throw BookErrors.imageNotFound
//        }
//        
//        return pdf
//        
//        
//    }
//    
//}
//
//func markAsFavourite(){
//    self.isFavourite = true
//}





