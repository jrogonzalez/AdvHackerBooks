//
//  BooksTableViewController.swift
//  AdvHackerbooks
//
//  Created by jro on 12/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit
import CoreData

class BooksTableViewController: CoreDataTableViewController , BooksTableViewControllerDelegate{
    
    
    var delegate : BooksTableViewControllerDelegate? = nil
    var orderAlpha : Bool = true
    
    static let bookDidChangeNotification = Notification.Name("BookDidChangeNotification")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let nibName = UINib.init(nibName: "BookViewCell", bundle: nil)
        
        self.tableView.register(nibName, forCellReuseIdentifier: "BookViewCell")
        
        self.delegate = self
        
        self.title = "Adv. Hackerbooks"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        if let fc = fetchedResultsController{
            //            print("\n SECTION: \(section), name: \(fc.sections![section].name) \n")
            if fc.sections![section].name == "" {
                return "Books"
            }else{
                return fc.sections![section].name
            }
            //            return "CACA";
        }else{
            return nil
        }
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Search the Book
        var book : Book? = nil
        if orderAlpha {
            if let searchBook = self.fetchedResultsController?.object(at: indexPath) as? Book {
                book = searchBook
            }
        }else{
            if let searchBook = self.fetchedResultsController?.object(at: indexPath) as? BookTag {
                book = searchBook.book!
            }
        }
        
        
        //Create a Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookViewCell", for: indexPath) as! BookViewCell
//        let cellId = "NotebookCell"
//        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
//        if cell == nil{
//             cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
//        }
        
            // Sincronize cell and book
            cell.titleView.text = book?.title
            
            //Async
            DispatchQueue.global(qos: .default).async {
                //Test if have the local data image
                
                var imagen : UIImage? = nil
                
                //load the provisional image in the Main queue
                DispatchQueue.main.async {
                    //Show a image whie the real cover is downloading
                    cell.bookPhotoView.image = UIImage(imageLiteralResourceName: "default_cover.png")
                    
                    if (book?.isFavourite)!{
                        cell.favPhotoView.image = UIImage(imageLiteralResourceName: "filledStar.png")
                    }else{
                        cell.favPhotoView.image = UIImage(imageLiteralResourceName: "EmptyStar.jpg")
                    }
                }
                
                
                
                if let auxImg = book?.photo?.image {
//                    print(" \n \n  LOAD COVER FROM LOCAL \n \n ")
                    imagen = auxImg
                }else{
                    //if we dont have it, we take it from remote
                    let dataImage = NSData(contentsOf: NSURL(string: (book?.photo?.photoURL!)!) as! URL)
                    if let img = dataImage {
                        let imgData = Data.init(referencing: img)
                        imagen = UIImage(data: imgData)
                        
                        //sync with model
                        book?.photo?.image = imagen
                        //                    print(" \n \n  LOAD COVER FROM LOCAL \n \n ")
                    }
                    
                }
                
                
                
                
                //load the image in the Main queue
                DispatchQueue.main.async {
                    if imagen != nil {
                        cell.bookPhotoView.image = imagen    
                    }
                    
                }
                
            }
            
            
            
            //        let tags = Array(book.tag!.dictionaryWithValues(forKeys: ["data"]))
            
            if let caca = book?.bookTags {
                let tags = Array(caca)
                
                // Creamos el array de salida e introducimos el primer elemento el favorito
                var salida : String  = ""
                
                //Iteramos y vamos introduciendo los tags salvo el favorito que ya lo introdujimos en la posicion 0
                for each in 0..<tags.count{
//                    print("END INDEX: \(tags.endIndex) ")
                    let tagName = ((tags[each] as AnyObject).value(forKey: "tag") as! Tag).tagName
                    if (each == tags.count-1){
                        salida.append("\(tagName!)")
                    }else{
                        salida.append("\(tagName!), ")
                    }
                    
                }
                
                
                cell.tagsView.text = salida
                
            }
        
        
//        print("\n \n TITULO LIBRO: \(book.title) EN SECTION: \(indexPath.section) Y ROW: \(indexPath.row) \n \n ")
        
        // Return Cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //Search the Book
        var book : Book? = nil
        if orderAlpha {
            if let searchBook = self.fetchedResultsController?.object(at: indexPath) as? Book {
                book = searchBook
            }
        }else{
            if let searchBook = self.fetchedResultsController?.object(at: indexPath) as? BookTag {
                book = searchBook.book!
            }
        }
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            print("Soy un IPHONE")
            
            
            
            //Search for the Book selected
//            let bookTag = self.fetchedResultsController?.object(at: indexPath) as! BookTag
            
            //Push to the new controller
            delegate?.booksTableViewController(vc: self, didSelectBook: book!)
            
            break
        // It's an iPhone
        case .pad:
            print("Soy un IPAD")
            
            
            //Search for the Book selected
//            let bookTag = self.fetchedResultsController?.object(at: indexPath) as! BookTag
            
            //Push to the new controller
            delegate?.booksTableViewController(vc: self, didSelectBook: book!)
            
            
//            // Enviamos la misma info via notificaciones
//            let nc = NotificationCenter.default
//            let notif = Notification(name: BooksTableViewController.bookDidChangeNotification, object: self, userInfo: [bookKey:bookTag.book!])
//            nc.postNotification(notif)
            
            break
            
        // It's an iPad
        case .unspecified:
            print("Soy un OTRA COSA")
            break
        default:
            print("Soy un DEFAULT")
            // Uh, oh! What could it be?
        }

        
        
        
        

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Mark: -
    internal func booksTableViewController(vc: BooksTableViewController, didSelectBook book: Book) {
        //Create a BookViewController
        let bookVC = BookViewController(withBook: book)
        
        // Push to the navigation Controller
        self.navigationController?.pushViewController(bookVC, animated: true)
        
    }
    
    func lastSelectedBook(context : NSManagedObjectContext) -> Book?{
        let def = UserDefaults.standard
        
        //        let def = NSUbiquitousKeyValueStore()
        if let lastBookId = def.value(forKey: "lastBook") {
            let url = URL(string: lastBookId as! String)!
            let objectID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url)
            
            do {
                let object = try context.existingObject(with: objectID!)
                print(object)
                return object as? Book
            }
            catch let error as NSError {
                print(error.localizedDescription)
                return nil
            }
        }else{
            return nil
        }   
    }
    
    func changeSelectedOrder(Alphabetical: Bool, context: NSManagedObjectContext){
        
        if Alphabetical {
            //Create the fetchedRequest
            let req = NSFetchRequest<Book>(entityName: Book.entityName)
            req.returnsDistinctResults = true  //not repeated occurences
            
            let sd = NSSortDescriptor(key: "title", ascending: true)
            req.sortDescriptors = [sd]
            
            //Create the fetchedRequestController
            let reqCtrl = NSFetchedResultsController(fetchRequest: req,
                                                     managedObjectContext: (self.fetchedResultsController?.managedObjectContext)!,
                                                     sectionNameKeyPath: nil,
                                                     cacheName: nil)
            
            self.fetchedResultsController? = reqCtrl as! NSFetchedResultsController<NSFetchRequestResult>

        }else{
            
            //Create the fetchedRequest
            let req = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
            req.returnsDistinctResults = true  //not repeated occurences
            
            let sd = NSSortDescriptor(key: "tag.tagName", ascending: true)
            req.sortDescriptors = [sd]
            
            //Create the fetchedRequestController
            let reqCtrl = NSFetchedResultsController(fetchRequest: req,
                                                     managedObjectContext: (self.fetchedResultsController?.managedObjectContext)!,
                                                     sectionNameKeyPath: "tag.tagName",
                                                     cacheName: nil)
            
            self.fetchedResultsController? = reqCtrl as! NSFetchedResultsController<NSFetchRequestResult>
        }
        
        
    }
    
    func searchBooks(text: String, context: NSManagedObjectContext){
        
        let keySortDescriptor : String?
        let sectionNames : String?
        
        //Create the fetchedRequest
        let req = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        req.fetchBatchSize = 50
        
        keySortDescriptor = "book.title"
        sectionNames = nil
        req.returnsDistinctResults = true  //not repeated occurences

        
        let sd = NSSortDescriptor(key: keySortDescriptor, ascending: true)
        req.sortDescriptors = [sd]
        
//        let searchPredicate = NSPredicate(format: "book.title == %@ OR book.author.name == %@ OR tag.tagName  == %@", text, text ,text)
        let searchTitle = NSPredicate(format: "book.title contains[cd] %@", text)
        let searchAuthor = NSPredicate(format: "ANY book.author.name contains[cd] %@", text)
        let searchTags = NSPredicate(format: "tag.tagName contains[cd] %@", text)
//        req.predicate = searchPredicate
        
//        let pre = NSCompoundPredicate.init(orPredicateWithSubpredicates: [searchTitle, searchAuthor, searchTags])
        let pre = NSCompoundPredicate.init(orPredicateWithSubpredicates: [searchTitle, searchAuthor, searchTags])
        req.predicate = pre
        
        //Create the fetchedRequestController
        let reqCtrl = NSFetchedResultsController(fetchRequest: req,
                                                 managedObjectContext: (self.fetchedResultsController?.managedObjectContext)!,
                                                 sectionNameKeyPath: sectionNames,
                                                 cacheName: nil)
        
        self.fetchedResultsController? = reqCtrl as! NSFetchedResultsController<NSFetchRequestResult>
    }



}


// Definimos los metodos del delegado
protocol BooksTableViewControllerDelegate{
    
    func booksTableViewController(vc: BooksTableViewController, didSelectBook book: Book)
    
}

// Implementamos los metodos del delegado
extension BooksTableViewController: BookViewControllerDelegate{
    
    
    
    func bookViewcontroller(vc: BookViewController, addToFavourite: Book){
        // Actualizamos el modelo
//        model.addFavorite(book)
        
        //sincronizamos
        self.tableView.reloadData()
    }
    func bookViewcontroller(vc: BookViewController, removeFromFavourite: Book){
        // Actualizamos el modelo
//        model.removeFavorite(book)
        
        //sincronizamos
        self.tableView.reloadData()
    }
}
