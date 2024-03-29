//
//  BookViewController.swift
//  AdvHackerbooks
//
//  Created by jro on 13/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit
import CoreData

class BookViewController: UIViewController {
    


    @IBOutlet weak var coverView: UIImageView!
    @IBAction func loadPdfButton(_ sender: AnyObject) {
        //Create the pdfController
        let pdfVC = PdfViewController(withModel: self.model)
        
        //Pus to the navigation
        self.navigationController?.pushViewController(pdfVC, animated: true)
        
    }
    @IBOutlet weak var emptyStarView: UIImageView!
    @IBOutlet weak var filledStarView: UIImageView!
    @IBOutlet weak var tagsView: UILabel!
    @IBOutlet weak var authorsView: UILabel!
    @IBOutlet weak var titleView: UILabel!
    
    var model : Book
    var delegate: BookViewControllerDelegate? = nil
    var favourite: Bool = false
    
    init(withBook book: Book){
        self.model = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        //Create a gestureRecognation
        let tapGestureEmptyStar = UITapGestureRecognizer(target: self, action: #selector(BookViewController.emptyStarTapped(gesture:)))
        let tapGestureFilledStar = UITapGestureRecognizer(target: self, action: #selector(BookViewController.filledStarTapped(gesture:)))
        
        emptyStarView.addGestureRecognizer(tapGestureEmptyStar)
        emptyStarView.isUserInteractionEnabled = true
        
        filledStarView.addGestureRecognizer(tapGestureFilledStar)
        filledStarView.isUserInteractionEnabled = true
        
        self.title = "Book"
        
        if  UIDevice.current.userInterfaceIdiom == .pad {
            self.navigationItem.hidesBackButton = true
        }
        
//        self.view.backgroundColor? = UIColor(colorLiteralRed: 0.77, green: 0.77, blue: 0.77, alpha: 1.0)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emptyStarView.image = UIImage(imageLiteralResourceName: "EmptyStar2.png")
        filledStarView.image = UIImage(imageLiteralResourceName: "filled2.png")
        
        synchronizeWithModelView()
        


    }
    
    func emptyStarTapped(gesture: UIGestureRecognizer){
        
        //Add to favourite
        if (gesture.view as? UIImageView) != nil{
            emptyStarView.isHidden = true
            filledStarView.isHidden = false
            model.isFavourite = true
            // Insert into the model
            _ = BookTag(withBook: model, tag: "Favourite", context: model.managedObjectContext!)
            
            // Call the delegate to refresh the view
            self.delegate?.bookViewcontroller(vc: self, addToFavourite: model)
            
        }
        
    }
    
    func filledStarTapped(gesture: UIGestureRecognizer){
        
        if (gesture.view as? UIImageView) != nil{
            emptyStarView.isHidden = false
            filledStarView.isHidden = true
            model.isFavourite = false
            
            //Detele from model
            
            let req = NSFetchRequest<BookTag>(entityName: "BookTag")
            req.fetchLimit = 1
            
            let searchFav = NSPredicate(format: "tag.tagName == %@ AND book.title == %@", "Favourite", (model.title)!)
            req.predicate = searchFav
            
            do {
                let str = try model.managedObjectContext?.fetch(req)
                if (str?.count)! > 0 {
                    model.managedObjectContext?.delete((str?[0])!)
                }
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
            //call the delegate
            self.delegate?.bookViewcontroller(vc: self, removeFromFavourite: model)
        }
        
    }
    
    func synchronizeWithModelView(){
        
        self.titleView.text = model.title
        self.titleView.isUserInteractionEnabled = false
        
        guard let auxAuthors = model.author else{
            return
        }
        
        var authorsName = ""
        let authors = Array(auxAuthors)
        for key in 0..<authors.count{
            let authorName = (authors[key] as AnyObject).value(forKey: "name")

            if let name = authorName {
                if (key == authors.count-1){
                     authorsName.append("\(name)")
                }else{
                    authorsName.append("\(name), ")
                }
            }
        }
        
        
        self.authorsView.text = authorsName
        self.authorsView.isUserInteractionEnabled = false
        
        let tags = Array(model.bookTags!)
        var salida : String = ""
        
        for each in 0..<tags.count{
            let tagName = ((tags[each] as AnyObject).value(forKey: "tag") as! Tag).tagName
            if tagName != "Favourite"{
                if (each == tags.count-1){
                    salida.append("\(tagName!)")
                }else{
                    salida.append("\(tagName!), ")
                }
            }
            
            
        }
        
        
        self.tagsView.text = salida
        self.tagsView.isUserInteractionEnabled = false
        self.coverView.image = model.photo?.image
        self.coverView.isUserInteractionEnabled = false
        
        self.favourite = model.isFavourite
        
        if (model.isFavourite){
            emptyStarView.isHidden = true
            filledStarView.isHidden = false
        }else{
            emptyStarView.isHidden = false
            filledStarView.isHidden = true
        }
        
        saveLastBookSelected()
        
        
    }
    
    func saveLastBookSelected(){
        //Save the lasta book selected
        //        let def = NSUbiquitousKeyValueStore.default()
        let def = UserDefaults.standard
        
        //save it as a String
        def.set(self.model.objectID.uriRepresentation().absoluteString, forKey: "lastBook")
        def.synchronize()
        
//        print("\n OBject ID: \(self.model.objectID.uriRepresentation().absoluteString) \n" )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol BookViewControllerDelegate{
    
    func bookViewcontroller(vc: BookViewController, addToFavourite: Book)
    func bookViewcontroller(vc: BookViewController, removeFromFavourite: Book)
}

//Implementamos los metodos del delegado
extension BookViewController: BooksTableViewControllerDelegate{
    
    
    func booksTableViewController(vc: BooksTableViewController, didSelectBook book: Book){
        
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // Actualizamos el modelo
            model = book
            
            
            // Sincronizamos las vistas con el nuevo modelo
            synchronizeWithModelView()
            
            break
        case .pad:
            // It's an iPad
            // Actualizamos el modelo
            model = book
            
            // Sincronizamos las vistas con el nuevo modelo
            synchronizeWithModelView()
            break
        default:
            // Uh, oh! What could it be?
            break
        }
        
    }
    
}

