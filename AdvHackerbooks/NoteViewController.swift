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
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func displayPhoto(_ sender: AnyObject) {
        
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
        // take the book
        
        // create el PhotoViewController
        let pVC = PhotoViewController(withNote: self.model!)
        
        //push the VC
        self.navigationController?.pushViewController(pVC, animated: true)
        
        
        
//        let oldBounds = self.photoView.bounds
//        
//        // Animación
//        UIView.animate(withDuration: 0.9,
//                       animations: {
//                        self.photoView.alpha = 0
//                        self.photoView.bounds = CGRect(x: 0, y: 0, width: 0, height: 0)
//                        self.photoView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
//                        
//        }) { (finished: Bool) in
//            // Dejar todo como estaba
//            self.photoView.bounds = oldBounds
//            self.photoView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
//            self.photoView.alpha = 1
//            
//            // Actualizamos
//            self.model.photo?.image = nil
//            self.syncModelView()
//        }
        
    }
    
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
extension NoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        // Redimensionarla al tamaño de la pantalla
        // deberes (está en el online)
        if model?.photo?.image != nil {
            model?.photo?.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        }else{
            let img  = Photo(withNote: (self.model)!, photoData: info[UIImagePickerControllerOriginalImage] as! UIImage?, context: (self.model?.managedObjectContext)!)
            model?.photo?.image = img.image
            
        }
        
        
        // Quitamos de enmedio al picker
        self.dismiss(animated: true) {
            //
        }
        
        // create el PhotoViewController
        let pVC = PhotoViewController(withNote: self.model!)
        
        //push the VC
        self.navigationController?.pushViewController(pVC, animated: true)
    }
}

