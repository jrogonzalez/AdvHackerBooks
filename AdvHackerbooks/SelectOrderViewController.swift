//
//  SelectOrderViewController.swift
//  AdvHackerbooks
//
//  Created by jro on 22/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class SelectOrderViewController: UIViewController, BooksTableViewControllerDelegate, UISearchBarDelegate {
    
    var table : BooksTableViewController?
    var delegate : BooksTableViewControllerDelegate?
    
    @IBOutlet weak var searchBarView: UISearchBar!

    @IBAction func selectOrderView(_ sender: AnyObject) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if sender.selectedSegmentIndex == 0{
            table?.changeSelectedOrder(Alphabetical: true, context: context)
            table?.orderAlpha = true
    
            print("\n PULSADO ALPHA")
        } else{
            table?.changeSelectedOrder(Alphabetical: false, context: context)
            table?.orderAlpha = false
            print("\n PULSADO TAGS")
        }
    }
    @IBOutlet weak var selectOrder: UISegmentedControl!

    
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
        
        searchBarView.delegate = self
        searchBarView.showsCancelButton = true
        searchBarView.showsSearchResultsButton = true
        
        self.title = "HackerBooksPRO"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Add Subview
    func addTableControllerViewMio(){
        
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
        tableView.translatesAutoresizingMaskIntoConstraints = false // esta propiedad hay que ponerla a false para quitar la mascara de autodimensionamiento ya que somos nosotros quienes manejamos el layout
        
        self.table?.tableView.frame = tableView.frame
        self.table?.tableView.bounds = tableView.bounds
        
        tableView.addSubview((self.table?.tableView)!)

//        let leadingConstraint = NSLayoutConstraint(item: self.table?.tableView,
//                                                   attribute: NSLayoutAttribute.leading,
//                                                   relatedBy: NSLayoutRelation.equal,
//                                                   toItem: tableView,
//                                                   attribute: NSLayoutAttribute.leading,
//                                                   multiplier: 1,
//                                                   constant: 12)
//        
//        
//        let topConstraint = NSLayoutConstraint(item: self.table?.tableView,
//                                                   attribute: NSLayoutAttribute.top,
//                                                   relatedBy: NSLayoutRelation.equal,
//                                                   toItem: tableView,
//                                                   attribute: NSLayoutAttribute.top,
//                                                   multiplier: 1,
//                                                   constant: 12)
//        
//        let widthConstraint = NSLayoutConstraint(item: self.table?.tableView,
//                                               attribute: NSLayoutAttribute.width,
//                                               relatedBy: NSLayoutRelation.equal,
//                                               toItem: nil,
//                                               attribute: NSLayoutAttribute.width,
//                                               multiplier: 1,
//                                               constant: 320)
//        
//        
//        let heighConstraint = NSLayoutConstraint(item: self.table?.tableView,
//                                               attribute: NSLayoutAttribute.height,
//                                               relatedBy: NSLayoutRelation.equal,
//                                               toItem: nil,
//                                               attribute: NSLayoutAttribute.height,
//                                               multiplier: 1,
//                                               constant: 320)
//        
        
        
        
        self.view.addSubview(tableView)
//        self.view.addConstraints([leadingConstraint, topConstraint, widthConstraint, heighConstraint])
//        
//        // DOOOOOOOS
//        let viewsDictionary = ["views": self.table?.tableView]
//        let horiontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H: |-20-[views]-20-|",
//                                                                  options: NSLayoutFormatOptions.alignAllTrailing,
//                                                                  metrics: nil,
//                                                                  views: viewsDictionary)
//        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[views]-20-|",
//                                                                 options: NSLayoutFormatOptions.alignAllTop,
//                                                                 metrics: nil,
//                                                                 views: viewsDictionary)
//        self.view.addConstraints(horiontalConstraints)
//        self.view.addConstraints(verticalConstraints)
    }
    
    
    
    // MARK: - Add Subview
    func addTableControllerView(){
        
        let segBounds = self.selectOrder.bounds
        let searchBounds = self.searchBarView.bounds
        let totalBounds = self.navigationController?.view.bounds
        let tableBounds = self.table?.tableView.bounds
        print("NAVIGATION X: Y: \(totalBounds)")
        print("SEARCH X: Y: \(searchBounds)")
        print("SEGMENTED X: Y: \(segBounds)")
        
        print("TABLE X: Y: \(tableBounds)")
        
        //let position = CGPoint(x: segBounds.origin.x, y: segBounds.origin.y+segBounds.size.height)
        let position = CGPoint(x: segBounds.origin.x, y: segBounds.size.height+searchBounds.size.height)
        print("POSITION X: Y: \(position)")
//        let position = CGPoint(x: segBounds.origin.x, y: 200)
        let totalSpace = CGSize(width: (totalBounds?.size.width)!,
                                height: totalBounds!.size.height-(segBounds.size.height+searchBounds.size.height))
        
        print("CGRECT Width: Height: \(totalSpace)")
        // Hasta aquí calculo donde dibujar la vista
        let cgRect = CGRect(origin: position, size: totalSpace)
        print("CGRECT: \(cgRect.origin)")
        
        
        let tV = UIScrollView(frame: cgRect)
        
        print("tV: \(tV.bounds)")
        tV.bounds = (self.table?.tableView.bounds)!
        tV.frame = CGRect(x: 0,
                          y: segBounds.size.height+searchBounds.size.height+64,
                          width: (totalBounds?.size.width)!,
                          height: totalBounds!.size.height-(segBounds.size.height+searchBounds.size.height))
        
        
        // Modifico los bordes del tableView para que se ajuste bien
        self.table?.tableView.frame = CGRect(x: 0,
                                             y: 0,
                                             width: (totalBounds?.size.width)!,
                                             height: totalBounds!.size.height-(segBounds.size.height+searchBounds.size.height))
        self.table?.tableView.bounds = tV.bounds
        self.table?.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0)
        print("TABLE FRAME: \(self.table?.tableView.frame)")
        print("TABLE BOUNDS: \(self.table?.tableView.bounds)")
        
        
        // Añado la subvista al uiview intermedio
        tV.addSubview((self.table?.tableView)!)
        
        // Inserto la vista en el uiview principal
        self.view.addSubview(tV)
        
        
        
        
        
    }

    
    
    //delegate
    func booksTableViewController(vc: BooksTableViewController, didSelectBook book: Book){
        //create The viewController
        let VC = BookViewController(withBook: book)
        
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Implementar la busqueda
        print("HA PULSADO BUSCAR")
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let search = searchBar.text
        
        table?.searchBooks(text: search!, context: context)
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        clearSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
           print("HA PULSADO CANCELAR_2")
            clearSearch()
            
        }else{
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let search = searchBar.text
            
            table?.searchBooks(text: search!, context: context)
            print("HA PULSADO BUSCAR_2")
        }
    }
    
    func clearSearch(){
        guard let alpha = table?.orderAlpha else{
            print("HA PULSADO CANCELAR")
            return
        }
        
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        if alpha {
            table?.changeSelectedOrder(Alphabetical: true, context: context)
            table?.orderAlpha = true
            
        }else{
            table?.changeSelectedOrder(Alphabetical: false, context: context)
            table?.orderAlpha = false
            
        }

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
