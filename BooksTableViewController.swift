//
//  BooksTableViewController.swift
//  AdvHackerbooks
//
//  Created by jro on 12/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class BooksTableViewController: CoreDataTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let nibName = UINib.init(nibName: "BookViewCell", bundle: nil)
        
        self.tableView.register(nibName, forCellReuseIdentifier: "BookViewCell")
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
        
        print("\n \n TITULO LIBRO: \(book.title) EN SECTION: \(indexPath.section) Y ROW: \(indexPath.row) \n \n ")
        
        // Return Cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
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
