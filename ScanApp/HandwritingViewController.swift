//
//  HandwritingViewController.swift
//  ScanApp
//
//  Created by Voicu Narcis on 03/01/2017.
//  Copyright © 2017 Voicu Narcis. All rights reserved.
//

import UIKit
import QuickLook

class HandwritingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageSourceProtocol {

    // MARK: - IBs
    @IBOutlet weak var textField: UITextField!
    @IBAction func showDocuments(_ sender: UIButton) {
       
    }
    
    @IBAction func proceedWithScanning(_ sender: UIButton) {
        openCamera()
     }
    
    // MARK: - Global variables
    var imageView: UIImageView!
    var spinner: ActivityIndicator!
    
    var popupView: UIView!
    var firstNameTextField = UITextField()
    var lastNameTextField = UITextField()
    var cnpTextField = UITextField()
    var ciNumberTextField = UITextField()
    var sexTextField = UITextField()
    var birthdayTextField = UITextField()
    var dismissButton: UIButton!
    
    // MARK: - Default functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.azureishWhite
        
        spinner = ActivityIndicator(view: view)
        
        imageView = UIImageView(frame: CGRect(x: 50, y: 50, width: 300, height: 150))
        view.addSubview(imageView)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HandwritingViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Camera functions
    
    func openCamera() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .camera
        self.present(picker, animated: true, completion: nil)
    }
    
    // MARK: - ImagePickerController delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        imageView.image = chosenImage
        spinner.addActivityIndicator(view: self.view)
        PDFConverter.savePDFFileToDisk(pdfData: PDFConverter.convertImageToPDF(image: chosenImage))
        picker.dismiss(animated: true, completion: {
            self.spinner.removeActivityIndicator()
            let alert = AlertBuilder(title: "Your PDF was succesfully created", alertStyle: .alert)
            alert.addAction(title: "OK", style: .default)
            alert.createAlert().showAlert()
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
