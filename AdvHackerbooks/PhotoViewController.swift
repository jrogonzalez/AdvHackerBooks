//
//  PhotoViewController.swift
//  AdvHackerbooks
//
//  Created by jro on 17/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var model : Note
    
    //MARK: - Intializers
    init(withNote model: Note){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - 
    @IBAction func takePhoto(_ sender: AnyObject) {
        // Crear una instancia de UIImagePicker
        let picker = UIImagePickerController()
        
        // Configurarlo
        if UIImagePickerController.isCameraDeviceAvailable(.rear){
            picker.sourceType = .camera
        }else{
            // me conformo con el carrete
            picker.sourceType = .photoLibrary
        }
        
        
        picker.delegate = self
        
        // Mostrarlo de forma modal
        self.present(picker, animated: true) {
            // Por si quieres hacer algo nada más
            // mostrarse el picker
        }
    }
    
    @IBAction func removePhoto(_ sender: AnyObject) {
        let oldBounds = self.photoView.bounds
        
        // Animación
        UIView.animate(withDuration: 0.9,
                       animations: {
                        self.photoView.alpha = 0
                        self.photoView.bounds = CGRect(x: 0, y: 0, width: 0, height: 0)
                        self.photoView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
                        
        }) { (finished: Bool) in
            // Dejar todo como estaba
            self.photoView.bounds = oldBounds
            self.photoView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.photoView.alpha = 1
            
            // Actualizamos
            self.model.photo?.image = nil
            self.syncModelView()
        }
        
    }
    @IBOutlet weak var photoView: UIImageView!
    
    
    //MARK: - Livecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncDataView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        syncModelView()
    }
    
    func syncModelView() {
        title = model.text
        photoView.image = model.photo?.image
    }
    
    func syncDataView(){
        self.title = model.text
        
        if let img = model.photo?.image {
            self.photoView.image = img
        }else{
            self.photoView.image = UIImage(imageLiteralResourceName: "NoImageAvailable.png")
        }
            
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeCurrentPhoto(){
        let oldBounds = self.photoView.bounds
        
        // Animación
        UIView.animate(withDuration: 0.9,
                       animations: {
                        self.photoView.alpha = 0
                        self.photoView.bounds = CGRect(x: 0, y: 0, width: 0, height: 0)
                        self.photoView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
                        
        }) { (finished: Bool) in
            // Dejar todo como estaba
            self.photoView.bounds = oldBounds
            self.photoView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.photoView.alpha = 1
            
            // Actualizamos
            self.model.photo?.image = nil
            self.syncModelView()
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

//MARK: - Delegates
extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        // Redimensionarla al tamaño de la pantalla
        // deberes (está en el online)
        if model.photo?.image != nil {
            model.photo?.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        }else{
            let img  = Photo(withNote: self.model, photoData: info[UIImagePickerControllerOriginalImage] as! UIImage?, context: (self.model.managedObjectContext)!)
            model.photo?.image = img.image
            
        }
        
        
        // Quitamos de enmedio al picker
        self.dismiss(animated: true) {
            //
        }
        
    }
}
