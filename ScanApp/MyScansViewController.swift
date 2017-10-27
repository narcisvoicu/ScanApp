//
//  MyScansViewController.swift
//  ScanApp
//
//  Created by Voicu Narcis on 28/01/2017.
//  Copyright © 2017 Voicu Narcis. All rights reserved.
//

import UIKit
import QuickLook

class MyScansViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, QLPreviewControllerDataSource {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Global variables
    var documents = [URL]()
    let quickLookController = QLPreviewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quickLookController.dataSource = self
        documents = PDFConverter.getDocumentsDirectory()
        // Whatsapp sharing
        //        let urlString = textField.text!
        //        let urlStringEncoded = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        //        let url  = NSURL(string: "whatsapp://send?text=\(urlStringEncoded!)")
        //
        //        if UIApplication.shared.canOpenURL(url! as URL) {
        //            UIApplication.shared.openURL(url! as URL)
        //        }

    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyScansCell")! as UITableViewCell
        let currentFileParts = extractAndBreakFilenameInComponents(fileURL: documents[indexPath.row])
        cell.textLabel?.text = currentFileParts.fileName
        cell.detailTextLabel?.text = getFileTypeFromFileExtension(fileExtension: currentFileParts.fileExtension)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if QLPreviewController.canPreview(documents[indexPath.row] as QLPreviewItem) {
            quickLookController.currentPreviewItemIndex = indexPath.row
            navigationController?.pushViewController(quickLookController, animated: true)
        }
    }
    
    // MARK: - QuickLook
    
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return documents.count
    }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return documents[index] as QLPreviewItem
    }
    
    // MARK: - Get document title from path
    
    func extractAndBreakFilenameInComponents(fileURL: URL) -> (fileName: String, fileExtension: String) {
        let fileURLParts = fileURL.path.components(separatedBy: "/")
        let fileName = fileURLParts.last
        let filenameParts = fileName?.components(separatedBy: ".")
        return (filenameParts![0], filenameParts![1])
    }
    
    func getFileTypeFromFileExtension(fileExtension: String) -> String {
        var fileType = ""
        switch fileExtension {
        case "docx":
            fileType = "Microsoft Word document"
        case "pages":
            fileType = "Pages document"
        case "jpeg":
            fileType = "Image document"
        case "key":
            fileType = "Keynote document"
        case "pdf":
            fileType = "PDF document"
        default:
            fileType = "Text document"
        }
        return fileType
    }

}
