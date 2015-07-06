//
//  APIHandler.swift
//  OctoPrint
//
//  Created by Mario on 22/06/15.
//  Copyright (c) 2015 Mario. All rights reserved.
//  
//  This file implements a class that wraps all API methods
//  for the octoprint server.
//

import Foundation

class OctoPrint {
    //This property shouldn't be needed when mdns discovery is implemented?
    let IP = "octopi.local"
    //This should be dinamically obtained when session keys are implemented
    let API_KEY = "31D19A28F79D4E29A4592437F5D8A90A"
    //content type: As soon as i have acces to internet it'll change this to a enum type
    let JSON = "application/json"
    let MULTIPART = "multipart/form-data; boundary=----WebKitFormBoundary"
    
    //API Calls
    func home() {
        let urlString = "http://\(IP)/api/printer/printerhead"
        let json: [String: AnyObject] = [
            "command": "home",
            "axes": ["x", "y", "z"]
        ]
        var err: NSError?
        let object = NSJSONSerialization.dataWithJSONObject(json, options: nil, error: &err)
        makeHTTPPostRequest(urlString, data: object, contentType: JSON)
    }
    
    func getTemp() {
        let urlString = "http://\(IP)/api/printer/tool"
        var url = NSURL(string: urlString)// Creating URL
        var request = NSURLRequest(URL: url!)
        
        var queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response: NSURLResponse!, responseData: NSData!, error: NSError!) -> Void in
            if error != nil {
                println(error.description)
            } else {
                var responseDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as! NSDictionary
                var temps = responseDict["temps"] as! NSDictionary
                var tool = temps["tool0"] as! NSDictionary
                var temp = tool["actual"] as! Double
                println(temp)
            }
        }
    }
    
    func uploadFile(sourcePath: String, destinationPath: String){
        //get file content
        let path = NSBundle.mainBundle().pathForResource("test", ofType: "gcode")
        var file: String?
        if let validPath = path {
            var readError:NSError?
            file = String(contentsOfFile: validPath, encoding: NSUTF8StringEncoding, error: &readError)
            if let error = readError {
                println("\(error.description)")
                return
            }
        }else{
            println("Invalid path")
            return
        }
        //construct multipart form
        let randomBoundary = randomString(16)
        let boundary = "------WebKitFormBoundary\(randomBoundary)"
        let boundaryEnd = "\(boundary)--"
        let filename = "test.gcode"
        let content_disposition = "Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\""
        let content_type = "Content-Type: application/octet-stream"
        let form = "\(boundary)\n\(content_disposition)\n\(content_type)\n\n\(file!)\n\(boundaryEnd)"
        //send request
        let urlString = "http://\(IP)/api/files/\(destinationPath)"
        let data = (form as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        makeHTTPPostRequest(urlString, data: data, contentType: "\(MULTIPART)\(randomBoundary)")
    }
    
    //HTTP requests wrappers
    func makeHTTPPostRequest(url: String, data: NSData?, contentType: String ) {
        let url = NSURL(string: url)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = data
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue(API_KEY, forHTTPHeaderField: "X-Api-Key")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { (response: NSURLResponse!, responseData: NSData!, error: NSError!) -> Void in
            if error != nil {
                println(error.description)
            }
        }
    }
    
    func makeHTTPGetRequest(url:String) -> NSData? {
        let url = NSURL(string: url)
        var request = NSURLRequest(URL: url!)
        
        var queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response: NSURLResponse!, responseData: NSData!, error: NSError!) -> Void in
            if error != nil {
                println(error.description)
            } else {
                //must find a way of returning the request.
            }
        }
        return nil
    }
    
    //Additional functions
    func randomString(size: Int) -> String {
        let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
        var randomString = ""
        for _ in 1...size {
            randomString += "\(alphabet[Int(arc4random_uniform(UInt32(alphabet.count)))])"
        }
        return randomString
    }
}