
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

    
