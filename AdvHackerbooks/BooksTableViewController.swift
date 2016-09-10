//
//  BooksTableViewController.swift
//  AdvHackerbooks
//
//  Created by jro on 10/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class BooksTableViewController: CoreDataTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nibName = UINib.init(nibName: "BookViewCell", bundle: nil)
        
        //self.tableView.register(nibName, forCellReuseIdentifier: <#T##String#>)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Search the Book
//        let book = self.fetchedResultcontroller.objectAtIndexPath(indexPath)
                
        //Create a Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookViewCell", for: indexPath)
        
        
        // Sincronize cell and book
        //cell =
        
        // Return Cell
        return cell
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
