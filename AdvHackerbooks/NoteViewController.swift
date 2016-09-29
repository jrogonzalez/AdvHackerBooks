//
//  NoteViewController.swift
//  AdvHackerbooks
//
//  Created by jro on 14/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    var model : Note?
    
    @IBAction func goMapView(_ sender: AnyObject) {
        let mapVC = MapViewController(withLocalization: model?.location)
        
        self.navigationController?.pushViewController(mapVC, animated: true)
        
    }
    @IBAction func goPhotoView(_ sender: AnyObject) {
        
        
        // create el PhotoViewController
        let pVC = PhotoViewController(withNote: self.model!)
        
        //push the VC
        self.navigationController?.pushViewController(pVC, animated: true)
    }
    
    @IBOutlet weak var textView: UITextView!
    
    init(withModel model: Note){
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        syncViewWithModel()
        
        //Create a BarButton for share
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareDisplayController))
        
        self.navigationItem.rightBarButtonItem = shareButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        syncModelWithview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func syncModelWithview(){
        model?.text = textView.text
    }
    
    func syncViewWithModel(){
        textView.text = model?.text
    }
    
    func shareDisplayController(){
        //Create A UIActivityController
        let avc = UIActivityViewController(activityItems: arrayOfItems(), applicationActivities: [])
        avc.popoverPresentationController?.sourceView = self.view //so that IPad dont crash
        
        
        // Present it
        self.present(avc, animated: true, completion: {
            
        })
    }
    
    func arrayOfItems() -> [Any]{
        var salida :  [Any] = []
        
        if let text = (model?.text){
            salida.append(text)
        }
        
        if let img =  (model?.book?.photo?.image) {
            salida.append(img)
        }
        
        // TO-DO  repetir con todos los demas elementos de la nota
        
        return salida
    }


}




