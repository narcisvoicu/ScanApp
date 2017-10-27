//
//  CIScanViewController.swift
//  ScanApp
//
//  Created by Voicu Narcis on 03/01/2017.
//  Copyright © 2017 Voicu Narcis. All rights reserved.
//

import UIKit
import AVFoundation

class CIScanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageSourceProtocol {

    // MARK: - IBs
    
    @IBAction func proceedWithScanning(_ sender: UIButton) {
        let alert = AlertBuilder(title: "Choose your action", alertStyle: .actionSheet)
        alert.addAction(title: "Scan IC", style: .default) { (action) in self.openCamera()}
        alert.addAction(title: "Convert IC to PDF", style: .default) { (action) in self.showPhotos()}
        alert.addAction(title: "Cancel", style: .cancel)
        alert.createAlert().showAlert()
    }
    @IBOutlet weak var textView: UITextView! {
        didSet{
            textView.isHidden = true
        }
    }
    
    // MARK: - Global variables
    var buttonID: Int = 0
    
    var picker: UIImagePickerController?
    
    var spinner: ActivityIndicator!
    
    var imageView: UIImageView!
    
    var lastNameComponent: String!
    var cnpComponent: String!
    var lastName: String!
    var firstName: String!
    var cnp: String!
    var birthday: String!
    var ciSeries: String!
    var sex: String!
    
    // MARK: - Default functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        spinner = ActivityIndicator(view: view)
        imageView = UIImageView(frame: CGRect(x: 25, y: 100, width: view.frame.width - 50, height: 100))
        
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "_UIImagePickerControllerUserDidCaptureItem"), object: nil, queue: nil) { (note) in
            self.picker?.cameraOverlayView = nil
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "_UIImagePickerControllerUserDidRejectItem"), object: nil, queue: nil) { (note) in
            self.picker?.cameraOverlayView = self.createCameraOverlay()
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        view.addSubview(imageView)
        
    }
    
    // MARK: - Parse recognized string
    
    func replaceRegexWithString(recognizedString: String) -> String{
        let parsedString = recognizedString.replacingOccurrences(of: "\\<+", with: "<", options: .regularExpression)
        return parsedString
    }
    
    func trimParsedString(parsedString: String) -> String{
        let trimmedString = parsedString.replacingOccurrences(of: "\\n*", with: "", options: .regularExpression)
        return trimmedString
    }
    
    func splitString(parsedString: String) -> [String]{
        let splitArray = parsedString.components(separatedBy: "<")
        return splitArray
    }
    
    func getComponents(splittedArray: [String]){
        firstName = splittedArray[1]
        if splittedArray.count > 4 {
            for i in 2...splittedArray.count-3{
                firstName = firstName + " " + splittedArray[i]
            }
        }
        ciSeries = splittedArray[splittedArray.count-2]
        lastNameComponent = splittedArray.first
        cnpComponent = splittedArray.last
    }
    
    func getLastName() -> String{
        let index = lastNameComponent.index(lastNameComponent.startIndex, offsetBy: 5)
        let lastName = lastNameComponent.substring(from: index)
        return lastName
    }
    
    func getCNP() -> String{
        var cnp = String()
        
        let end1 = cnpComponent.index(cnpComponent.endIndex, offsetBy: -1)
        let string = cnpComponent.substring(to: end1)
        let end2 = cnpComponent.index(cnpComponent.endIndex, offsetBy: -7)
        let lastSixNumbers = string.substring(from: end2)
        
        let birthdayNumbers = getBirthdayFromCNPComponent()
        
        if cnpComponent.contains("M"){
            cnp = "1" + birthdayNumbers + lastSixNumbers
            sex = "masculin"
        } else if cnpComponent.contains("F"){
            cnp = "2" + birthdayNumbers + lastSixNumbers
            sex = "feminin"
        }
        return cnp
    }
    
    func getBirthday() -> String{
        var fullBirthday = String()
        let shortBirthday = getBirthdayFromCNPComponent()
        let yearStart = shortBirthday.index(shortBirthday.startIndex, offsetBy: 2)
        let shortYear = shortBirthday.substring(to: yearStart)
        let monthStart = shortBirthday.index(shortBirthday.startIndex, offsetBy: 2)
        let monthEnd = shortBirthday.index(shortBirthday.endIndex, offsetBy: -2)
        let monthRange = monthStart..<monthEnd
        let shortMonth = shortBirthday.substring(with: monthRange)
        let dayEnd = shortBirthday.index(shortBirthday.endIndex, offsetBy: -2)
        let day = shortBirthday.substring(from: dayEnd)
        fullBirthday = day + " " + shortMonth + " " + "19" + shortYear
        return fullBirthday
    }
    
    func getBirthdayFromCNPComponent() -> String{
        let start = cnpComponent.index(cnpComponent.startIndex, offsetBy: 4)
        let end = cnpComponent.index(cnpComponent.endIndex, offsetBy: -17)
        let range = start..<end
        let birthday = cnpComponent.substring(with: range)
        return birthday
    }
    
    // MARK: - Camera setup
        
    func openCamera(){
        picker = UIImagePickerController()
        picker?.delegate = self
        picker?.allowsEditing = false
        picker?.sourceType = .camera;
        picker?.cameraOverlayView = createCameraOverlay()
        picker?.cameraDevice = .rear
        self.present(picker!, animated: true, completion: nil)
    }
    
    func showPhotos() {
        buttonID = 1
        openCamera()
    }

    
    func createCameraOverlay() -> UIView{
        let overlayView = UIView(frame: CGRect(x: 20, y: 50, width: view.frame.width - 40, height: view.frame.height - 180))
        overlayView.layer.borderWidth = 2
        overlayView.layer.borderColor = UIColor.red.cgColor
        overlayView.layer.cornerRadius = 8
        
        let label = UILabel(frame: CGRect(x: -75, y: 0, width: 200, height: 30))
        label.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        label.center.y = overlayView.center.y
        label.text = "Put your CI here"
        label.textColor = UIColor.red
        label.textAlignment = NSTextAlignment.center
        label.layer.opacity = 0.6
        overlayView.addSubview(label)
        
        return overlayView
    }
    
    // MARK: - ImagePickerController delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        if buttonID == 0 {
            let portraitImage  : UIImage = UIImage(cgImage:chosenImage.cgImage!, scale: 1.0, orientation: UIImageOrientation.up)
            let scaledImage = Tesseract.scaleImage(image: portraitImage, maxDimension: 640)
            let croppedImage = cropImage(image: scaledImage)
            
            imageView.image = croppedImage
            spinner.addActivityIndicator(view: self.view)
            picker.dismiss(animated: true, completion: {
                self.scanCI(image: croppedImage)
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

    // MARK: - Processing image
    
    func cropImage(image: UIImage) -> UIImage{
        let height = CGFloat(image.size.height / 4)
        let rect = CGRect(x: 40, y: image.size.height - height - 5, width: image.size.width - 80, height: height - 60)
        let cgimage: CGImage = (image.cgImage?.cropping(to: rect))!
        let croppedImage = UIImage(cgImage: cgimage)
        return croppedImage
    }
    
    func scanCI(image: UIImage){
        spinner.addActivityIndicator(view: view)
        textView.isHidden = false
        let recognizedString = Tesseract.performImageRecognition(image: image, engineMode: .tesseractOnly, ocrLanguage: "OCRB")
        print("Number of characters: \(recognizedString.characters.count)")
        if (recognizedString.characters.count > 72 && recognizedString.characters.count < 78) {
            let parsedString = replaceRegexWithString(recognizedString: recognizedString)
            let trimmedString = trimParsedString(parsedString: parsedString)
            let splittedArray = splitString(parsedString: trimmedString)
            getComponents(splittedArray: splittedArray)
            lastName = getLastName()
            cnp = getCNP()
            textView.text = "Last Name: \(lastName!) \n" + "First Name: \(firstName!) \n" + "CNP: \(cnp!) \n" + "CI Number: \(ciSeries!) \n" + "Sex: \(sex!) \n" + "Birthday: \(getBirthday())"
            spinner.removeActivityIndicator()
        } else {
            textView.text = "Error at scanning"
            spinner.removeActivityIndicator()
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

}


