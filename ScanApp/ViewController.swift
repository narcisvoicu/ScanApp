//
//  ViewController.swift
//  ScanApp
//
//  Created by Voicu Narcis on 27/12/2016.
//  Copyright © 2016 Voicu Narcis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - IBs
   
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Lazy var - instances of view controllers
    
    lazy var ciScanViewController: CIScanViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "CIScanViewController") as! CIScanViewController
        self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    
    lazy var docScanViewController: DocScanViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "DocScanViewController") as! DocScanViewController
        self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    
    lazy var handwritingViewController: HandwritingViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "HandwritingViewController") as! HandwritingViewController
        self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    
    // MARK: - Default functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        view.backgroundColor = Colors.azureishWhite
    }


    // MARK: - Helping functions for segmented control
    
    func setupView(){
        setupSegmentedControl()
        updateView()
    }
    
    func updateView(){
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            ciScanViewController.view.isHidden = false
            docScanViewController.view.isHidden = true
            handwritingViewController.view.isHidden = true
        case 1:
            ciScanViewController.view.isHidden = true
            docScanViewController.view.isHidden = false
            handwritingViewController.view.isHidden = true
        case 2:
            ciScanViewController.view.isHidden = true
            docScanViewController.view.isHidden = true
            handwritingViewController.view.isHidden = false
        default:
            break
        }
    }
    
    func setupSegmentedControl(){
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "CI Scan", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Doc Scan", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Handwriting", at: 2, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    func selectionDidChange(sender: UISegmentedControl){
        updateView()
    }
    
    func addViewControllerAsChildViewController(childViewController: UIViewController){
        addChildViewController(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.didMove(toParentViewController: self)
        
    }
}

