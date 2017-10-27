//
//  Utils.swift
//  ScanApp
//
//  Created by Voicu Narcis on 03/01/2017.
//  Copyright © 2017 Voicu Narcis. All rights reserved.
//

import Foundation
import UIKit

public class AlertBuilder{
    
    private var alertController = UIAlertController()
    
    public init(title: String, alertStyle: UIAlertControllerStyle){
        self.alertController = UIAlertController(title: title, message: nil, preferredStyle: alertStyle)
    }
    
    public func addAction(title: String, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Swift.Void)? = nil){
        self.alertController.addAction(UIAlertAction(title: title, style: style, handler: handler))
    }
    
    public func createAlert() -> UIAlertController{
        return alertController
    }
}

extension UIAlertController{
    
    public func showAlert(){
        guard var rootVC = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        while let presentedVC = rootVC.presentedViewController {
            rootVC = presentedVC
        }
        rootVC.present(self, animated: true, completion: nil)
    }
}
