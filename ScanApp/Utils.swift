//
//  Utils.swift
//  ScanApp
//
//  Created by Voicu Narcis on 16/01/2017.
//  Copyright © 2017 Voicu Narcis. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    // MARK: - Get storyboard
    
    static func getMainStoryboard() -> UIStoryboard {
        return UIStoryboard.init(name: "Main", bundle: nil)
    }
    
    // MARK: - Get view controllers
    
    static func getMyScansViewController() -> UIViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: "MyScansViewController")
    }
    
    // MARK: - Other Utils
    
}
