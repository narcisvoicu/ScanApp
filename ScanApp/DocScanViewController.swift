//
//  DocScanViewController.swift
//  ScanApp
//
//  Created by Voicu Narcis on 03/01/2017.
//  Copyright © 2017 Voicu Narcis. All rights reserved.
//

import UIKit

class DocScanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageSourceProtocol {

    // MARK: - IBs
    
    @IBAction func proceedWithScanning(_ sender: UIButton) {
        let alert = AlertBuilder(title: "Choose your action", alertStyle: .actionSheet)
        alert.addAction(title: "Scan Document", style: .default) { (action) in self.openCamera()}
        alert.addAction(title: "Convert document to PDF", style: .default) { (action) in self.showPhotos()}
        alert.addAction(title: "Cancel", style: .cancel)
        alert.createAlert().showAlert()
    }
    
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Global variables
    var buttonID: Int = 0
    var imageView: UIImageView!
    var spinner: ActivityIndicator!
    
    // MARK: - Default functions
    override func viewDidLoad() {
        super.viewDidLoad()

        spinner = ActivityIndicator(view: view)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        imageView = UIImageView(frame: CGRect(x: 50, y: 50, width: 300, height: 150))
        view.addSubview(imageView)
    }
    
    // MARK: - Choose image source
    
    func openCamera() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .camera
        self.present(picker, animated: true, completion: nil)
    }
    
    func showPhotos() {
        buttonID = 1
        openCamera()
    }
    
    // MARK: - ImagePickerController delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        if buttonID == 0 {
         //   let bookImage = UIImage(named: "IMG_3354-2.jpeg")
            let scaledImage = Tesseract.scaleImage(image: chosenImage, maxDimension: 640)
            imageView.image = scaledImage
            spinner.addActivityIndicator(view: self.view)
            picker.dismiss(animated: true, completion: {
                self.textView.text = Tesseract.performImageRecognition(image: scaledImage, engineMode: .tesseractCubeCombined, ocrLanguage: "eng")
                self.spinner.removeActivityIndicator()
            })
        } else {
            spinner.addActivityIndicator(view: self.view)
            PDFConverter.savePDFFileToDisk(pdfData: PDFConverter.convertImageToPDF(image: chosenImage))
            picker.dismiss(animated: true, completion: {
                self.spinner.removeActivityIndicator()
                let alert = AlertBuilder(title: "Your PDF was succesfully created", alertStyle: .alert)
                alert.addAction(title: "OK", style: .default)
                alert.createAlert().showAlert()
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
}
