//
//  PdfViewController.swift
//  AdvHackerbooks
//
//  Created by jro on 13/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class PdfViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var navigationView: UINavigationItem!
    @IBOutlet weak var pdfView: UIWebView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBAction func notesButton(_ sender: AnyObject) {
    }
    
    let model : Book
    
    
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
        let url = URL(string: "http://mitpress.mit.edu/sites/default/files/titles/content/9780262514293_Creative_Commons_Edition.pdf")
        let urlReq = URLRequest(url: url!)
        self.pdfView.loadRequest(urlReq)
        
        activityView.startAnimating()
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
