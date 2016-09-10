//
//  CoreDataTableViewController.swift
//
//
//  Created by Fernando Rodríguez Romero on 22/02/16.
//  Copyright © 2016 udacity.com. All rights reserved.
//

import UIKit
import CoreData

class CoreDataTableViewController: UITableViewController {
    
    // MARK:  - Properties
    var fetchedResultsController : NSFetchedResultsController<AnyObject>?{
        didSet{
            // Whenever the frc changes, we execute the search and
            // reload the table
            fetchedResultsController?.delegate = self
            executeSearch()
            tableView.reloadData()
        }
    }
    
    init(fetchedResultsController fc : NSFetchedResultsController<AnyObject>,
         style : UITableViewStyle = .Plain){
        fetchedResultsController = fc
        super.init(style: style)
        
        
    }
    
    // Do not worry about this initializer. I has to be implemented
    // because of the way Swift interfaces with an Objective C
    // protocol called NSArchiving. It's not relevant.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}



// MARK:  - Subclass responsability
extension CoreDataTableViewController{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        fatalError("This method MUST be implemented by a subclass of CoreDataTableViewController")
    }
}

// MARK:  - Table Data Source
extension CoreDataTableViewController{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let fc = fetchedResultsController{
            return (fc.sections?.count)!;
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fc = fetchedResultsController{
            return fc.sections![section].numberOfObjects;
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let fc = fetchedResultsController{
            return fc.sections![section].name;
        }else{
            return nil
        }
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        if let fc = fetchedResultsController{
            return fc.sectionForSectionIndexTitle(title, atIndex: index)
        }else{
            return 0
        }
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        if let fc = fetchedResultsController{
            return  fc.sectionIndexTitles
        }else{
            return nil
        }
    }
    
    
}

// MARK:  - Fetches
extension CoreDataTableViewController{
    
    func executeSearch(){
        if let fc = fetchedResultsController{
            do{
                try fc.performFetch()
            }catch let e as NSError{
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
}


// MARK:  - Delegate
extension CoreDataTableViewController: NSFetchedResultsControllerDelegate{
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
                    didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                    atIndex sectionIndex: Int,
                    forChangeType type: NSFetchedResultsChangeType) {
        
        let set = NSIndexSet(index: sectionIndex)
        
        switch (type){
            
        case .insert:
            tableView.insertSections(set as IndexSet, with: .fade)
            
        case .delete:
            tableView.deleteSections(set as IndexSet, with: .fade)
            
        default:
            // irrelevant in our case
            break
            
        }
    }
    
    
    func controller(controller: NSFetchedResultsController,
                    didChangeObject anObject: AnyObject,
                    atIndexPath indexPath: NSIndexPath?,
                    forChangeType type: NSFetchedResultsChangeType,
                    newIndexPath: NSIndexPath?) {
        
        
        
        switch(type){
            
        case .insert:
            tableView.insertRows(at: [newIndexPath! as IndexPath], with: .fade)
            
        case .delete:
            tableView.deleteRows(at: [indexPath! as IndexPath], with: .fade)
            
        case .update:
            tableView.reloadRows(at: [indexPath! as IndexPath], with: .fade)
            
        case .move:
            tableView.deleteRows(at: [indexPath! as IndexPath], with: .fade)
            tableView.insertRows(at: [newIndexPath! as IndexPath], with: .fade)
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}
