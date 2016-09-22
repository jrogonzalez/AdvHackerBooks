//
//  SelectOrderViewController.swift
//  AdvHackerbooks
//
//  Created by jro on 22/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class SelectOrderViewController: UIViewController, BooksTableViewControllerDelegate {
    
    var table : BooksTableViewController?
    var delegate : BooksTableViewControllerDelegate?
    
    @IBOutlet weak var searchBarView: UISearchBar!

    @IBAction func selectOrderView(_ sender: AnyObject) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if sender.selectedSegmentIndex == 0{
//            table?.changeSelectedOrder(Alphabetical: true, context: context)
            
            print("\n PULSADO ALPHA")
        } else{
//            table?.changeSelectedOrder(Alphabetical: false, context: context)
            print("\n PULSADO TAGS")
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    init(withBookTableVC bookTableVC : BooksTableViewController){
        self.table = bookTableVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addTableControllerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Add Subview
    func addTableControllerView(){
        
//        let ancho = self.tableView.bounds.width
//        let alto = self.tableView.bounds.height
        
        
        let ancho = CGFloat(320)
        let alto = CGFloat(650)
        
        let X = CGFloat(0)
        let Y = CGFloat(63)
        
        let position = CGPoint(x: X, y: Y)
        
        let tamanio = CGSize(width: ancho,
                             height: alto)
        
        let area = CGRect(origin: position, size: tamanio)
        
        let tableView = UIScrollView(frame: area)
        
        self.table?.tableView.frame = tableView.frame
        self.table?.tableView.bounds = tableView.bounds
        
        tableView.addSubview((self.table?.tableView)!)
        
        self.view.addSubview(tableView)
    }

    
    
    //delegate
    func booksTableViewController(vc: BooksTableViewController, didSelectBook book: Book){
        //create The viewController
        let VC = BookViewController(withBook: book)
        
        self.navigationController?.pushViewController(VC, animated: true)
        
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
