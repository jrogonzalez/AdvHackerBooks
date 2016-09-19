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
        let pdfVC = PdfViewController(withModel: self.model.book!)
        
        //Pus to the navigation
        self.navigationController?.pushViewController(pdfVC, animated: true)
        
    }
    @IBOutlet weak var emptyStarView: UIImageView!
    @IBOutlet weak var filledStarView: UIImageView!
    @IBOutlet weak var tagsView: UILabel!
    @IBOutlet weak var authorsView: UILabel!
    @IBOutlet weak var titleView: UILabel!
    
    var model : BookTag
    let delegate: BookViewControllerDelegate? = nil
    var favourite: Bool = false
    
    init(withBookTag bookTag: BookTag){
        self.model = bookTag
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emptyStarView.image = UIImage(imageLiteralResourceName: "EmptyStar.jpg")
        filledStarView.image = UIImage(imageLiteralResourceName: "filledStar.png")
        
        synchronizeWithModelView()
        
////        let def = NSUbiquitousKeyValueStore.default()
//        let def = UserDefaults.standard
//        def.set(self.model, forKey: "lastBook")
////        def.set(self.model, forKey: "lastBook")
////        def.synchronize()
//
//        
////        let def = NSUbiquitousKeyValueStore()
//        let lastBook = def.object(forKey: "lastBook") as! Book
//        print(lastBook)
//        print("caca")

    }
    
    func emptyStarTapped(gesture: UIGestureRecognizer){
        
        //Add to favourite
        if (gesture.view as? UIImageView) != nil{
            emptyStarView.isHidden = true
            filledStarView.isHidden = false
            model.book!.isFavourite = true
            // Insert into the model
            _ = BookTag(withBook: model.book, tag: "Favourite", context: model.managedObjectContext!)
            
            // Call the delegate to refresh the view
            self.delegate?.bookViewcontroller(vc: self, addToFavourite: model.book!)
            
        }
        
    }
    
    func filledStarTapped(gesture: UIGestureRecognizer){
        
        if (gesture.view as? UIImageView) != nil{
            emptyStarView.isHidden = false
            filledStarView.isHidden = true
            model.book!.isFavourite = false
            
            //Detele from model
            
            let req = NSFetchRequest<BookTag>(entityName: "BookTag")
            req.fetchLimit = 1
            
            let searchFav = NSPredicate(format: "tag.tagName == %@ AND book.title == %@", "Favourite", (model.book?.title)!)
            req.predicate = searchFav
            
//            let frc = NSFetchedResultsController(fetchRequest: req, managedObjectContext: model.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            
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
            self.delegate?.bookViewcontroller(vc: self, removeFromFavourite: model.book!)
        }
        
    }
    
    func synchronizeWithModelView(){
        
        self.titleView.text = model.book!.title
        self.titleView.isUserInteractionEnabled = false
        
        guard let auxAuthors = model.book!.author else{
            return
        }
        
        var authorsName = ""
        for key in Array(auxAuthors){
            let authorName = (key as AnyObject).value(forKey: "name")
            authorsName.append("\(authorName), ")
        }
        
        
        self.authorsView.text = authorsName
        self.authorsView.isUserInteractionEnabled = false
        
        let tags = Array(model.book!.bookTags!)
        var salida : String = ""
        
        for each in 0..<tags.count{
//            print("END INDEX: \(tags.endIndex) ")
            let tagName = ((tags[each] as AnyObject).value(forKey: "tag") as! Tag).tagName
            if (each == tags.count-1){
                salida.append("\(tagName!)")
            }else{
                salida.append("\(tagName!), ")
            }
            
        }
        
        
        self.tagsView.text = salida
        self.tagsView.isUserInteractionEnabled = false
        
//        let img = Data.init(referencing: (model.photo?.photoData)!)
//        self.coverView.image = UIImage(data: img)
        self.coverView.image = model.book!.photo?.image
        self.coverView.isUserInteractionEnabled = false
        
        self.favourite = model.book!.isFavourite
        
        if (model.book!.isFavourite){
            emptyStarView.isHidden = true
            filledStarView.isHidden = false
        }else{
            emptyStarView.isHidden = false
            filledStarView.isHidden = true
        }
        
        
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

