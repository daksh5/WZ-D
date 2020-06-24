//
//  ViewController.swift
//  Demo_app
//
//  Created by Daksh Parikh on 8/2/19.
//  Copyright © 2019 Daksh Parikh. All rights reserved.
//

import UIKit
import Overture

class ViewController: UIViewController {

    @IBOutlet weak var tugVideoButton: UIButton!
    @IBOutlet weak var medicinePictureButton: UIButton!
    @IBOutlet weak var woundPictureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        with(tugVideoButton, primaryButtonStyle)
        with(medicinePictureButton, primaryButtonStyle)
        with(woundPictureButton, primaryButtonStyle)
    }
}

