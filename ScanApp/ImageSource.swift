//
//  ImageSource.swift
//  ScanApp
//
//  Created by Voicu Narcis on 03/01/2017.
//  Copyright © 2017 Voicu Narcis. All rights reserved.
//

import Foundation
import UIKit

@objc protocol ImageSourceProtocol {
    func openCamera()
    @objc optional func showPhotos()
}
