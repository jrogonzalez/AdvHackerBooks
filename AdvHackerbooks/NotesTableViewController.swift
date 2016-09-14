//
//  NotesTableViewController.swift
//  AdvHackerbooks
//
//  Created by jro on 14/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class NotesTableViewController: CoreDataTableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Id
        let cellId = "cellId"
        
        // La nota
        let note = fetchedResultsController?.object(at: indexPath) as! Note
        
        // La celda
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        // Synchronize
        cell?.imageView?.image = note.book!.photo?.image
        cell?.textLabel?.text = note.text
        
        // Return the cell
        return cell!
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
        
        guard let fc = fetchedResultsController else{
            return
        }
        
        // set the title of note´s book
        title = (fc.fetchedObjects?.first as? Note)?.book?.title
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
