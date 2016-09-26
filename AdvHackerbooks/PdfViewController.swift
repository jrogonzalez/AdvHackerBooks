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

        //MAke a boton for goin to the last page
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(goToLastPage))
        
        self.navigationItem.rightBarButtonItem = button
        
        self.title = self.model.title
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.model.lastPageReaded = self.model.pdf?.pdf
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
            let myContentView : UIView?
            let viewFrame : CGRect?
            let pageRect: CGRect?
            
            if let thePdf = self.model.pdf?.pdf {
                print(" \n \n  LOAD PDF FROM LOCAL \n \n ")
                pdfData = thePdf

            }else{
                
//                // Load from the RemoteURL and save un model
//                let url = URL(string: (self.model.pdf?.pdfURL!)!)
//                pdfData = try? Data(referencing: (NSData(contentsOf: url!)))
//                
//                guard let document = CGPDFDocument(url as! CFURL) else { return }
//                guard let myPageRef = document.page(at: 1) else { return }
//                
//                
////                self.model.pdf!.pdf = document
//                
////                myPageRef = CGPDFDocumentGetPage(myDocumentRef, 1);
//                let pdfBox = CGPDFBox(rawValue: Int32(kCGPDF)!)
//                pageRect = myPageRef.getBoxRect(pdfBox!).integral;
////
//                let  tiledLayer = CATiledLayer.init();
//                tiledLayer.delegate = self;
//                tiledLayer.tileSize = CGSize(width: 1024.0, height: 1024.0)
////                tiledLayer.tileSize = CGSizeMake(1024.0, 1024.0);
//                
//                tiledLayer.levelsOfDetail = 1000;
//                tiledLayer.levelsOfDetailBias = 1000;
//                tiledLayer.frame = pageRect!;
////
//                 myContentView = UIView.init(frame: pageRect!)
//                myContentView?.layer.addSublayer(tiledLayer)
////
//                viewFrame = self.view.frame;
//                viewFrame?.origin = CGPoint.zero;
////                let  *scrollView = UIScrollView alloc] initWithFrame:viewFrame];
////                self.pdfView.frame = viewFrame
////                self.pdfView.delegate = self;
////                self.pdfView.contentSize = pageRect.size;
////                self.pdfView.maximumZoomScale = 1000;
////                self.pdfView.addSubview(myContentView);
//
////                [self.view addSubview:scrollView];
//
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                //***************************
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

//                    self.pdfView.frame = viewFrame!
//                    self.pdfView.delegate = self;
//                    self.pdfView.contentSize = (pageRect?.size)!;
//                    self.pdfView.maximumZoomScale = 1000;
//                    self.pdfView.addSubview(myContentView!);


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
    
    func goToLastPage(){
        let  selectedPag: CGFloat = 5.0; // i.e. Go to page 5
        
        //get the total height
        let pageHeight : CGFloat = self.pdfView.scrollView.contentSize.height;
        
//        let pageHeight: Int  = 1000; // i.e. Height of PDF page = 1000 px;
        
//        
//        let data = CGDataProvider(data: <#T##CFData#>)
//        let pdf : CGPDFDocumentRef = CGPDFDocument.init(<#T##provider: CGDataProvider##CGDataProvider#>)
//        CGPDFPageRef myPageRef = CGPDFDocumentGetPage(pdf, 1);
//        int  totalPages= CGPDFDocumentGetNumberOfPages(pdf);
        
        let count2: CGFloat = self.pdfView.scrollView.contentSize.width / self.pdfView.scrollView.frame.size.width; // for horizontal paging
            
        let count3: CGFloat = self.pdfView.scrollView.contentSize.height / self.pdfView.scrollView.frame.size.height; // for vertical paging
    
        
        
        
        
        
        let y : CGFloat = count3 * selectedPag;
        
        self.pdfView.scrollView.setContentOffset(CGPoint.init(x: 0, y: y), animated: true)
        
//        [[webView scrollView] setContentOffset:CGPointMake(0,y) animated:YES];
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


}

protocol PdfViewControllerDelegate{
    
    func pdfViewController(vc: PdfViewController, didPdfChanged: Book)
}
