//
//  BooksTableViewController.swift
//  AdvHackerbooks
//
//  Created by jro on 12/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class BooksTableViewController: CoreDataTableViewController , BooksTableViewControllerDelegate{
    
    
    var delegate : BooksTableViewControllerDelegate? = nil
    
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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Search the Book
        //        let book = self.fetchedResultcontroller.objectAtIndexPath(indexPath)
        let book = self.fetchedResultsController?.object(at: indexPath) as! Book
        
        //Create a Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookViewCell", for: indexPath) as! BookViewCell
//        let cellId = "NotebookCell"
//        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
//        if cell == nil{
//             cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
//        }
        
        // Sincronize cell and book
        cell.authorsView.text = book.title
        let imgData = Data.init(referencing: (book.photo?.photoData)!)
        let imagen = UIImage(data: imgData)
        cell.bookPhotoView.image = imagen
        
        if (book.isFavourite){
            cell.favPhotoView.image = UIImage(imageLiteralResourceName: "filledStar.png")
        }else{
            cell.favPhotoView.image = UIImage(imageLiteralResourceName: "EmptyStar.jpg")
        }
        
//        let tags = Array(book.tag!.dictionaryWithValues(forKeys: ["data"]))
        let tags = Array(book.tag!)
        // Creamos el array de salida e introducimos el primer elemento el favorito
        var salida : String = ""
        
        //Iteramos y vamos introduciendo los tags salvo el favorito que ya lo introdujimos en la posicion 0
        for each in tags {
            let tagName = (each as AnyObject).value(forKey: "tagName")
            salida.append("\(tagName!), ")
        }
        
        
        cell.tagsView.text = salida
        
//        print("\n \n TITULO LIBRO: \(book.title) EN SECTION: \(indexPath.section) Y ROW: \(indexPath.row) \n \n ")
        
        // Return Cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Search for the Book selected
        let book = self.fetchedResultsController?.object(at: indexPath) as! Book
        
        //Push to the new controller
        delegate?.booksTableViewController(vc: self, didSelectBook: book)
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
