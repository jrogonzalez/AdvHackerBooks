//
//  NotesCollectionViewController.swift
//  AdvHackerbooks
//
//  Created by jro on 05/10/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit
import CoreData

class NotesCollectionViewController: CoreDataCollectionViewController, UIGestureRecognizerDelegate {
    
    let book : Book
    let fc : NSFetchedResultsController<NSFetchRequestResult>
    var deletedIndexPath : IndexPath?
    let deleteButton = UIButton(type: UIButtonType.custom)
    var isDeleteActive : Bool = false
    

    
    //MARK: - Initializers
    init(withBook book : Book, fetchedResultsController fc: NSFetchedResultsController<NSFetchRequestResult>, layout: UICollectionViewLayout) {
        self.book = book
        self.fc = fc
        super.init(fetchedResultsController: fc, layout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = UIColor.white
        
        // Register the CustomCell
        self.registerNoteCell()
        
        self.title = "Notes of \(self.book.title)"
        
        //Add the edit buttonBar
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(activateDeletionMode))
        longPress.delegate = self;
        self.collectionView?.addGestureRecognizer(longPress)
        
        deleteButton.addTarget(self, action: #selector(removeNote), for: UIControlEvents.allEvents)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - CoreData
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        //Only one section
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items in section
        guard let notes = self.book.note else {
            return 0
        }
        return notes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Obtain the note
        let note = fc.object(at: indexPath) as! Note
        
        //Get the Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCollectionViewCell", for: indexPath) as! NoteCollectionViewCell
        
        //Fill the Cell
        // Synchronize
        if let img = note.photo?.image {
            cell.noteImageView.image = img
        } else{
            cell.noteImageView.image = UIImage(imageLiteralResourceName: "NoImageAvailable.png")
        }
        
        
        cell.titleView.text = note.text
        if (note.hasLocation){
            cell.positionView.image = UIImage(imageLiteralResourceName: "positionIcon2.png")
        }
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        
        cell.modificationDateView.text = df.string(from: note.modificationDate! as Date)

        cell.deleteButton.addTarget(self, action: #selector(removeNote), for: UIControlEvents.allEvents)
        cell.deleteButton.isHidden = false
        
        //Return the Cell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // check the cell
        let note = fc.object(at: indexPath) as! Note
        
        //Create the note controller
        let noteVC = NoteViewController(withModel: note)
        
        //Push
        navigationController?.pushViewController(noteVC, animated: true)

    }
    
    
    
    //MARK: - Utils
    func registerNoteCell(){
        let nibName = UINib.init(nibName: "NoteCollectionViewCell", bundle: nil)
        
        self.collectionView?.register(nibName, forCellWithReuseIdentifier: "NoteCollectionViewCell")
    }
    
    func activateDeletionMode(gr : UILongPressGestureRecognizer){
        if gr.state == UIGestureRecognizerState.began{
            if (!isDeleteActive){
                let indexPath = self.collectionView?.indexPathForItem(at: gr.location(in: self.collectionView))
                let cell = self.collectionView?.cellForItem(at: indexPath!) as! NoteCollectionViewCell
                deletedIndexPath = indexPath!
                cell.addSubview(deleteButton)
                cell.deleteButton.isHidden = false
                deleteButton.bringSubview(toFront: self.collectionView!)
            }
        }
    }
    
    func removeNote(_ sender: AnyObject){
  
        print("removeNoteSelected")
        
        let senderButton = UIView.init();
        
        let indexPath = self.collectionView?.indexPathsForSelectedItems
        let myIndex = IndexPath(row: 0, section: 0)
//        NSIndexPath *indexPath = [colleVIew indexPathForCell: (UICollectionViewCell *)[[senderButton superview]superview]];
        
//        [array removeObjectAtIndex:indexPath.row];
//        [colleVIew deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
//        
//        
        self.collectionView?.deleteItems(at: [myIndex])
        self.book.managedObjectContext?.processPendingChanges()
        deleteButton.removeFromSuperview()
//        self.collectionView?.reloadData()
        
    }
    

}
