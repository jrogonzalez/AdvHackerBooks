
import Foundation
import UIKit


    
//MARK: - Loading
func loadFromLocalFile(fileName name: String, bundle: Bundle = Bundle.main) -> JSONArray?{
    
    
    if let url = NSURL(string: name),
        let data = NSData(contentsOf: url as URL),
        let maybeArray = try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? JSONArray,
        let array = maybeArray{
        
        return array
        
    }else{
        return nil
    }
}


func loadFromRemoteFile(fileURL name: String, bundle: Bundle = Bundle.main) throws -> JSONArray{
    
    if let url = NSURL(string: name),
        let data = NSData(contentsOf: url as URL),
        let maybeArray = try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? JSONArray,
        let array = maybeArray{
        
        //Guardamos en cache y en local
        try  data.write(to: obtainLocalCacheUrlDocumentsFile(file: fileBooks) as URL, options: NSData.WritingOptions.atomicWrite)
        try  data.write(to: obtainLocalUrlDocumentsFile(file: fileBooks) as URL, options: NSData.WritingOptions.atomicWrite)
        
        let defaults = UserDefaults.standard
        defaults.set(urlHackerBooks, forKey: "JSON_Data")
        
        
        return array
        
    }else{
        throw BookErrors.jsonParsingError
    }
}

func loadDataFromRemoteFile(fileURL name: String, bundle: Bundle = Bundle.main) throws -> NSData?{
    
    
        
        if let url = NSURL(string: name),
            let data = NSData(contentsOf: url as URL){
            
            //Guardamos en cache y en local
            try  data.write(to: obtainLocalCacheUrlDocumentsFile(file: fileBooks) as URL, options: NSData.WritingOptions.atomicWrite)
            try  data.write(to: obtainLocalUrlDocumentsFile(file: fileBooks) as URL, options: NSData.WritingOptions.atomicWrite)
            
            let defaults = UserDefaults.standard
            defaults.set(urlHackerBooks, forKey: "JSON_Data")
            
            
            return data
            
        }else{
            return nil
        }

    
    
}

//func loadDataFromRemoteFile(fileURL name: String, bundle: Bundle = Bundle.main){
//    
//    DispatchQueue.global(qos: .default).async {
//        
//        do {
//            if let url = NSURL(string: name),
//                let data = NSData(contentsOf: url as URL){
//                
//                //Guardamos en cache y en local
//                try  data.write(to: obtainLocalCacheUrlDocumentsFile(file: fileBooks) as URL, options: NSData.WritingOptions.atomicWrite)
//                try  data.write(to: obtainLocalUrlDocumentsFile(file: fileBooks) as URL, options: NSData.WritingOptions.atomicWrite)
//                
//                let defaults = UserDefaults.standard
//                defaults.set(urlHackerBooks, forKey: "JSON_Data")
//                
//                DispatchQueue.main.async {
//                    return data
//                }
////                return data
//                
//            }
////            else{
////                return nil
////            }
//
//        }
//        catch let error as NSError {
//            print(error.localizedDescription)
//            
//        }
//        
//        
//    }
//    
//}


func obtainLocalUrlDocumentsFile(file: String) -> NSURL{
    
    //Obtenemos una ruta local de la carpeta documentos y componemos una URL con el fochero que nos dan de entrada
    let fm = FileManager.default
    let url = fm.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
    let fich = url.appendingPathComponent(file)
    
//    print(fich)
    return fich as NSURL
    
}

func obtainLocalCacheUrlDocumentsFile(file: String) -> NSURL{
    
    //Obtenemos una ruta local de la carpeta Cache y componemos una URL con el fochero que nos dan de entrada
    let fm = FileManager.default
    let url = fm.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
    let fich = url.appendingPathComponent(file)
    
    //    print(fich)
    return fich as NSURL

    
}

func fileForResourceName(name: String?) -> String{
    
    let components = name?.components(separatedBy: "/")    
    let fileName = components?.last
    return fileName!
    
}

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



