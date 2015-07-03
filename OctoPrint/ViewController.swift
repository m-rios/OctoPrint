//  ViewController.swift
//  OctoPrint
//
//  Created by Mario on 22/06/15.
//  Copyright (c) 2015 Mario. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let API = OctoPrint()
    
    @IBAction func home() {
        API.home()
    }
    
    @IBAction func getTemp() {
        API.getTemp()
    }

    @IBAction func uploadFile() {
        API.uploadFile("test.gcode", destinationPath: "local")
    }
}

