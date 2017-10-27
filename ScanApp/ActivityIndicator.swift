//
//  Utils.swift
//  ScanApp
//
//  Created by Voicu Narcis on 03/01/2017.
//  Copyright © 2017 Voicu Narcis. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator{
    
    var activityIndicator = UIActivityIndicatorView()
    
    public init(view: UIView){
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
    }
    
    func addActivityIndicator(view: UIView) {
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
        //activityIndicator = nil
    }
}
