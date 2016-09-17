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
    

    @IBOutlet weak var photoView: UIImageView!
    
    init(withNote model: Note){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        syncDataView()
        
        //Add a Delete Button
        let trash = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removePhoto))
        
        self.navigationItem.rightBarButtonItem = trash
    }
    
    func removePhoto(){
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
        self.photoView.image = model.photo?.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
