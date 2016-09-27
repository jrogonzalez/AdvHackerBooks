//
//  CoverBookViewController.swift
//  AdvHackerbooks
//
//  Created by jro on 22/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class CoverBookViewController: UIViewController, BooksTableViewControllerDelegate {
    @IBOutlet weak var coverView: UIImageView!

    var delegate: BookViewControllerDelegate? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "HackerbooksPRO"
        self.coverView.image = UIImage(imageLiteralResourceName: "default_cover.png")
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
    
    func booksTableViewController(vc: BooksTableViewController, didSelectBook book: Book){
        //Create the new VC
        let VC = BookViewController(withBook: book)
        
        self.navigationController?.pushViewController(VC, animated: true)
        
    }

}
