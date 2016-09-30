//
//  NotesTableViewController.swift
//  AdvHackerbooks
//
//  Created by jro on 14/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit
import CoreLocation

class NotesTableViewController: CoreDataTableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Id
        let cellId = "NoteViewCell"
        
        // La nota
        let note = fetchedResultsController?.object(at: indexPath) as! Note
        
        // La celda
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! NoteViewCell
        
        // Synchronize
        if let img = note.photo?.image {
            cell.noteImageView.image = img
        } else{
            cell.noteImageView.image = UIImage(imageLiteralResourceName: "NoImageAvailable.png")
        }
        
        
        cell.titleView.text = note.text
        cell.modificationDateView.text = note.modificationDate?.description
        if let longitude = note.location?.longitude.description,
            let latitude = note.location?.latitude.description {
            cell.longitudeView.text = "longitude: \(longitude)"
            cell.latitudeView.text = "latitude: \(latitude)"
        }else{
            cell.longitudeView.text = "longitude: Not Available"
            cell.latitudeView.text = "latitude: Not Available"
        }
        
        
        
        
        // Return the cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // check the cell
        let note = fetchedResultsController?.object(at: indexPath) as! Note
        
        //Create the note controller
        let noteVC = NoteViewController(withModel: note)
        
        //Push
        navigationController?.pushViewController(noteVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nibName = UINib.init(nibName: "NoteViewCell", bundle: nil)
        
        self.tableView.register(nibName, forCellReuseIdentifier: "NoteViewCell")
        
        guard let fc = fetchedResultsController else{
            return
        }
        
        // set the title of note´s book
        title = (fc.fetchedObjects?.first as? Note)?.book?.title
        
        //Add the edit buttonBar
//        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(deleteNote))
        
        self.navigationItem.rightBarButtonItem = editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deleteNote(){
        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let note = self.fetchedResultsController?.object(at: indexPath) as! Note
            
            note.managedObjectContext?.delete(note)
            
        } 
    }
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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
