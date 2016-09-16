//
//  PdfViewController.swift
//  AdvHackerbooks
//
//  Created by jro on 13/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit
import CoreData

class PdfViewController: UIViewController, UIWebViewDelegate, PdfViewControllerDelegate {
    
    
    @IBAction func createNote(_ sender: AnyObject) {
        //Create a annotation
        print("\n \n Estoy pulsando el createNote \n \n")
        //push the note
        
        let alert = UIAlertController(title: "New Note",
                                      message: "Add a new note",
                                      preferredStyle: .alert)
        
        // SIN CORE DATA
        /*
         let saveAction = UIAlertAction(title: "Save",
         style: .default,
         handler: { (action:UIAlertAction) -> Void in
         
         let textField = alert.textFields!.first
         self.names.append(textField!.text!)
         self.tableView.reloadData()
         })
         */
        
        // CON CORE DATA
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        _ = Note(withBook: self.model, text: textField!.text!, context: self.model.managedObjectContext!)
                                        
                                        //self.saveName(name: textField!.text!)
                                        //self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextField {
            (textField: UITextField) -> Void in
            var frameRect = CGRect(origin: textField.frame.origin, size: textField.frame.size)
            frameRect.size.height = 53;
            textField.frame = frameRect;
        }
        
        
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert,
                animated: true,
                completion: nil)

        
        
        
    }
    
    @IBAction func displayNotes(_ sender: AnyObject) {
        //Create a annotation
        print("\n \n Estoy pulsando el seeAllNotes \n \n")
        //push the note
        
        //Create fetched Results Controller
        let req = NSFetchRequest<Note>.init(entityName: "Note")
        req.fetchBatchSize = 50
        req.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
        
        req.predicate = NSPredicate(format: "book == %@", model)
        
        // Create the fetched Results Controller
        let fr = NSFetchedResultsController(fetchRequest: req,
                                            managedObjectContext: model.managedObjectContext!,
                                            sectionNameKeyPath: nil,
                                            cacheName: nil)
        
        //Crear el controlador
        let notesVC = NotesTableViewController(fetchedResultsController: fr as! NSFetchedResultsController<NSFetchRequestResult>)
        
        
        //mostratlo
        self.navigationController?.pushViewController(notesVC, animated: true)
    }

    @IBOutlet weak var navigationView: UINavigationItem!
    @IBOutlet weak var pdfView: UIWebView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBAction func notesButton(_ sender: AnyObject) {
    }
    
    let model : Book
    var delegate: PdfViewControllerDelegate?
    
    
    //MARK: - Initializers
    init(withModel model: Book){
        self.model = model
        super.init(nibName: nil, bundle: nil)
        

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifec, ycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //synchronize
        synchronizedataWithModel()
    }
    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityView.stopAnimating()
        
        self.pdfView.delegate = self
        self.delegate = self

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        activityView.stopAnimating()
        
        activityView.isHidden = true

    }
    
    //MARK: - Data Source
    func synchronizedataWithModel(){
        
        self.activityView.startAnimating()
        
        
        DispatchQueue.global(qos: .background).async {
            
            var pdfData : Data? = nil
            
            if let thePdf = self.model.pdf?.pdf {
                print(" \n \n  LOAD PDF FROM LOCAL \n \n ")
                pdfData = thePdf

            }else{
                // Load from the RemoteURL and save un model
                let url = URL(string: (self.model.pdf?.pdfURL!)!)
                pdfData = try? Data(referencing: (NSData(contentsOf: url!)))
//                let urlReq = URLRequest(url: url!)
                print(" \n \n  LOAD PDF FROM REMOTE \n \n ")
                self.model.pdf!.pdf = pdfData
                
                
            }
            
            // Call the delegate to refresh the view
            self.delegate?.pdfViewController(vc: self, didPdfChanged: self.model)
            
            DispatchQueue.main.async {

                if pdfData != nil{
                    self.pdfView.load(pdfData!, mimeType: "application/pdf", textEncodingName: "utf-8", baseURL: URL(fileURLWithPath: "http://www.gogle.es"))
                    

                }else{
                    let alert = UIAlertController(title: "Load Error",
                                                  message: "Error in pdf loading",
                                                  preferredStyle: .alert)

                    
                    let cancelAction = UIAlertAction(title: "Accept",
                                                     style: .default) { (action: UIAlertAction) -> Void in
                    }
                    
                    alert.addAction(cancelAction)
                    
                    self.present(alert,
                            animated: true,
                            completion: nil)
                    
                    self.activityView.isHidden = true
                }
                
                
            }

            
            
        }
    }
    
    internal func pdfViewController(vc: PdfViewController, didPdfChanged: Book) {
        print(" \n \n  He entrado en el delegado del pdfViewController \n \n ")
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

    
    func loadPdf() throws -> NSURLRequest?{
        
        //Probamos a buscarla en local
        let localURLCache = obtainLocalCacheUrlDocumentsFile(file: fileForResourceName(name: self.model.pdf!.pdfURL!))
        let localURL = obtainLocalUrlDocumentsFile(file: fileForResourceName(name: self.model.pdf!.pdfURL!))
        
        
        if NSData(contentsOf: localURLCache as URL) != nil{
            let pdfCache = NSURLRequest(url: localURLCache as URL)
            
            return pdfCache
        }else if NSData(contentsOf: localURL as URL) != nil{
            let pdf = NSURLRequest(url: localURL as URL)
            
            return pdf
        }else{
            
            //Si no esta en local probamos en remoto
            let pdfURL = NSURL(string: self.model.pdf!.pdfURL!)
            let pdf = NSURLRequest(url: pdfURL! as URL)
            
            
            do{
                if let pdfData = NSData(contentsOf: pdfURL! as URL) {
                    try pdfData.write(to: localURLCache as URL, options: NSData.WritingOptions.atomicWrite)
                    try pdfData.write(to: localURL as URL, options: NSData.WritingOptions.atomicWrite)
                }
                
            }catch{
                throw BookErrors.imageNotFound
            }
            
            return pdf
            
            
        }
        
    }


}

protocol PdfViewControllerDelegate{
    
    func pdfViewController(vc: PdfViewController, didPdfChanged: Book)
}
