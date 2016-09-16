import Foundation


extension Bundle{
    
    func URLForResourceCaca(name: String?) -> NSURL?{
        
        let components = name?.components(separatedBy: ".")
        let fileTitle = components?.first
        let fileExtension = components?.last
        
        return url(forResource: fileTitle, withExtension: fileExtension) as NSURL?
        
    }
    
    
}

