//
//  PdfViewController.swift
//  AdvHackerbooks
//
//  Created by jro on 13/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit
import CoreData
import CoreGraphics

class PdfViewController: UIViewController, UIWebViewDelegate, PdfViewControllerDelegate, CALayerDelegate {
    
    var model : Book
    var delegate: PdfViewControllerDelegate?
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var navigationView: UINavigationItem!
    @IBOutlet weak var pdfView: UIWebView!
    
    //MARK: - Initializers
    init(withModel model: Book){
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    //MARK: - IBActions
    @IBAction func createNote(_ sender: AnyObject) {
        //Create a annotation
        //push the note
        
        let alert = UIAlertController(title: "New Note",
                                      message: "Add a new note",
                                      preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Save",
                                       style: .default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        if textField?.text != ""{
                                        _ = Note(withBook: self.model, text: textField!.text!, context: self.model.managedObjectContext!)
                                        }else{
                                            let alertEmptyString = UIAlertController(title: "Empty note not saved",
                                                                          message: "",
                                                                          preferredStyle: .alert)
                                            
                                            let okAction = UIAlertAction(title: "Accept",
                                                                             style: .default) { (action: UIAlertAction) -> Void in
                                            }
                                            alertEmptyString.addAction(okAction)
                                            
                                            self.present(alertEmptyString,
                                                    animated: true,
                                                    completion: nil)
                                        }
                                        
                                        
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
        
//        //Crear el controlador
//        let notesVC = NotesTableViewController(fetchedResultsController: fr as! NSFetchedResultsController<NSFetchRequestResult>)
//        
//        
//        //mostratlo
//        self.navigationController?.pushViewController(notesVC, animated: true)
        
        //Llamamos al CoreDataCollectionViewController
        //Creamos el layout
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 330, height: 100)
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.minimumLineSpacing = 100
        
        let notesCollectionVC = NotesCollectionViewController(withBook: self.model, fetchedResultsController: fr as! NSFetchedResultsController<NSFetchRequestResult>, layout: layout)
        
        //mostratlo
        self.navigationController?.pushViewController(notesCollectionVC, animated: true)
        
    }


    

    
    //MARK: - Lifec, ycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Alta en notificación
        // Define identifier
        let notificationName = Notification.Name("BookDidChangeNotification")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(PdfViewController.bookDidChange), name: notificationName, object: nil)
        
        
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
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
        
        self.activityView.isHidden = false
        self.activityView.startAnimating()
        
        self.title = self.model.title
        
        
        DispatchQueue.global(qos: .background).async {
            
            var pdfData : Data? = nil
            
            if let thePdf = self.model.pdf?.pdf {
                pdfData = thePdf

            }else{

                // Load from the RemoteURL and save un model
                let url = URL(string: (self.model.pdf?.pdfURL!)!)
                pdfData = try? Data(referencing: (NSData(contentsOf: url!)))
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
        // TODO
    }

    
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
    
    func goToLastPage(){
        let  selectedPag: CGFloat = 5.0; // i.e. Go to page 5
        
        //get the total height
        let _ : CGFloat = self.pdfView.scrollView.contentSize.height;
        
        let _: CGFloat = self.pdfView.scrollView.contentSize.width / self.pdfView.scrollView.frame.size.width; // for horizontal paging
            
        let count3: CGFloat = self.pdfView.scrollView.contentSize.height / self.pdfView.scrollView.frame.size.height; // for vertical paging
    
        
        
        
        
        
        let y : CGFloat = count3 * selectedPag;
        
        self.pdfView.scrollView.setContentOffset(CGPoint.init(x: 0, y: y), animated: true)
        
    }
    
    
    func drawPDFfromURL(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }
        
        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height);
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0);
            
            ctx.cgContext.drawPDFPage(page);
        }
        
        return img
    }
    
    func bookDidChange(notification: NSNotification)  {
        
        // Sacar el userInfo
        let info = notification.userInfo!
        
        activityView.startAnimating()
        
        // Sacar el libro
        let book = info["BookKey"] as? Book
        
        // Actualizar el modelo
        self.model = book!
        
        // Sincronizar las vistas
        synchronizedataWithModel()
        
    }



}

protocol PdfViewControllerDelegate{
    
    func pdfViewController(vc: PdfViewController, didPdfChanged: Book)
}

