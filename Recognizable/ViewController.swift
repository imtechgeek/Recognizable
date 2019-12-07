//
//  ViewController.swift
//  Recognizable
//
//  Created by Usman on 07/12/2019.
//  Copyright © 2019 Usman. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedimage
            guard let ciImage = CIImage(image: userPickedimage) else{
                fatalError("Could not convert to CI Image")
            }
            detect(image: ciImage)
        }
        imagePicker.dismiss(animated: true,completion: nil)
        
        
    }
    func detect(image:CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Could not load Core ML Model")
            
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Error Retreiving results")
                }
            if let firstResult = results.first {
                self.navigationItem.title = firstResult.identifier
                
            }
        }
        let handler = VNImageRequestHandler(ciImage:image)
        do{
        try handler.perform([request])
        } catch{
            print(error)
        }
        
    }
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
        
        
        
    }
    
}

