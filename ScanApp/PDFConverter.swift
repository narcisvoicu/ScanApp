//
//  PDFConverter.swift
//  ScanApp
//
//  Created by Voicu Narcis on 28/01/2017.
//  Copyright © 2017 Voicu Narcis. All rights reserved.
//

import Foundation
import UIKit

class PDFConverter {
    
    static let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    
    static func convertImageToPDF(image: UIImage) -> NSData {
        let imageData = UIImageJPEGRepresentation(image, 0.9)
        let pdfSize = image.size // 2.
        let pdfData = NSMutableData(capacity: (imageData?.count)!) // 3.
        
        UIGraphicsBeginPDFContextToData(pdfData!, CGRect(origin: CGPoint(), size: pdfSize), nil)
        let context = UIGraphicsGetCurrentContext()!
        UIGraphicsBeginPDFPage()
        
        UIGraphicsPushContext(context)
        image.draw(at: CGPoint())
        UIGraphicsPopContext()
        
        UIGraphicsEndPDFContext()
        
        return pdfData!
    }
    
    static func savePDFFileToDisk(pdfData: NSData) {
        createDirectoryInDocuments()
        let numberOfLocalFiles = getDocumentsDirectory().count
        let scanAppPath = documentsPath?.appendingPathComponent("/ScanApp")
        let docName = scanAppPath?.appendingPathComponent("Document\(numberOfLocalFiles + 1).pdf")
        pdfData.write(to: docName!, atomically: true)
    }
    
    static func createDirectoryInDocuments(){
        let scanAppPath = documentsPath?.appendingPathComponent("/ScanApp")
        do {
            try FileManager.default.createDirectory(at: scanAppPath!, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError{
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    static func getDocumentsDirectory() -> [URL] {
        let scanAppPath = documentsPath?.appendingPathComponent("/ScanApp")
        var documents = [URL]()
        do {
            let contents = try (FileManager.default.contentsOfDirectory(at: scanAppPath!, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles))
            documents = contents
        } catch let error as NSError{
            print("ERROR: \(error.localizedDescription)")
        }
        print("Docs: \(documents)")
        return documents
    }
}
