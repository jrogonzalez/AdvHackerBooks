//
//  BookViewController.swift
//  AdvHackerbooks
//
//  Created by jro on 13/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    


    @IBOutlet weak var coverView: UIImageView!
    @IBAction func loadPdfButton(_ sender: AnyObject) {
    }
    @IBOutlet weak var emptyStarView: UIImageView!
    @IBOutlet weak var filledStarView: UIImageView!
    @IBOutlet weak var tagsView: UILabel!
    @IBOutlet weak var authorsView: UILabel!
    @IBOutlet weak var titleView: UILabel!
    
    var model : Book
    let delegate: BookViewControllerDelegate? = nil
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emptyStarView.image = UIImage(imageLiteralResourceName: "EmptyStar.jpg")
        filledStarView.image = UIImage(imageLiteralResourceName: "filledStar.png")
        
        synchronizeWithModelView()
    }
    
    func emptyStarTapped(gesture: UIGestureRecognizer){
        
        //Add to favourite
        if (gesture.view as? UIImageView) != nil{
            emptyStarView.isHidden = true
            filledStarView.isHidden = false
            model.isFavourite = true
            
            // Call the delegate to refresh the view
            self.delegate?.bookViewcontroller(vc: self, addToFavourite: model)
            
        }
        
    }
    
    func filledStarTapped(gesture: UIGestureRecognizer){
        
        if (gesture.view as? UIImageView) != nil{
            emptyStarView.isHidden = false
            filledStarView.isHidden = true
            model.isFavourite = false
            
            //call the delegate
            self.delegate?.bookViewcontroller(vc: self, removeFromFavourite: model)
        }
        
    }
    
    func synchronizeWithModelView(){
        
        self.authorsView.text = model.title
        self.authorsView.isUserInteractionEnabled = false
        
        let tags = Array(model.tag!)
        var salida : String = ""
        for each in tags{
            let tagName = (each as AnyObject).value(forKey: "tagName")
            salida.append("\(tagName!), ")
        }
        self.tagsView.text = salida
        self.tagsView.isUserInteractionEnabled = false
        
        let img = Data.init(referencing: (model.photo?.photoData)!)
        self.coverView.image = UIImage(data: img)
        self.coverView.isUserInteractionEnabled = false
        
        self.favourite = model.isFavourite
        
        if (model.isFavourite){
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
