//
//  Tesseract.swift
//  ScanApp
//
//  Created by Voicu Narcis on 03/01/2017.
//  Copyright © 2017 Voicu Narcis. All rights reserved.
//

import Foundation

class Tesseract {
    static func performImageRecognition(image: UIImage, engineMode: G8OCREngineMode, ocrLanguage: String) -> String{
        let tesseract = G8Tesseract()
        tesseract.language = ocrLanguage
        tesseract.engineMode = engineMode
        tesseract.pageSegmentationMode = .auto
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        print(tesseract.recognizedText)
        return tesseract.recognizedText
    }
    
    static func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    static func addFilterToImage(image: UIImage) -> UIImage {
        let tesseract = G8Tesseract()
        tesseract.image = image.g8_blackAndWhite()
        return tesseract.image
    }
}
