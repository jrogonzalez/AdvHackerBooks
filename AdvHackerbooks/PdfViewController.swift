//
//  PdfViewController.swift
//  AdvHackerbooks
//
//  Created by jro on 13/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class PdfViewController: UIViewController, UIWebViewDelegate, PdfViewControllerDelegate {
    
    
    @IBAction func createNote(_ sender: AnyObject) {
        //Create a annotation
        print("\n \n Estoy pulsando el createNote \n \n")
        //push the note
    }
    
    @IBAction func displayNotes(_ sender: AnyObject) {
        //Create a annotation
        print("\n \n Estoy pulsando el seeAllNotes \n \n")
        //push the note
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
        
        DispatchQueue.global(qos: .background).async {
            
           
            let url = URL(string: (self.model.pdf?.pdfURL!)!)
            let pdfData = NSData(contentsOf: url!)
            let urlReq = URLRequest(url: url!)
            self.model.pdf!.pdfData = pdfData
            
            // Call the delegate to refresh the view
            self.delegate?.pdfViewController(vc: self, didPdfChanged: self.model)
            
            DispatchQueue.main.async {
                self.pdfView.loadRequest(urlReq)
                
                self.activityView.startAnimating()
                
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
