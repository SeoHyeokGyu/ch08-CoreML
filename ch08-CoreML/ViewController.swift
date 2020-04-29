//
//  ViewController.swift
//  ch08-CoreML
//
//  Created by 서혁규 on 2020/04/29.
//  Copyright © 2020 서혁규. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController{
    
    var imagePickerController = UIImagePickerController()
    

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func cameraButtonClicked(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePickerController.sourceType = .camera
        } else {
            imagePickerController.sourceType = .photoLibrary
        }
        present(imagePickerController, animated: true)
    }
    

}
extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imageView.image = image
        
        imagePickerController.dismiss(animated: true, completion: nil)
        
    }
    
    func detectImage(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
        fatalError("Loading CoreML model failed")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Model failed to process image")
                }
            if let topResult = results.first{
                if topResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "Hotdog"
                }else{
                    self.navigationItem.title = "Not Hotdog"
                    
                }
                
            }
        }
    }

  
}

