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

class APIHanlder {
    //This property shouldn't be needed when mdns discovery is implemented
    let IP = "192.168.1.34"
    
    func getSessionKey() -> String {
        return ""
    }
    
    func home() {
        let urlString = "http://\(IP)/api/printer/printerhead"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let json: [String: AnyObject] = [
            "command": "home",
            "axes": ["x", "y", "z"]
        ]
        assert(NSJSONSerialization.isValidJSONObject(json), "JSON not valid")
        var err: NSError?
        let object = NSJSONSerialization.dataWithJSONObject(json, options: nil, error: &err)
        request.HTTPBody = object
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("31D19A28F79D4E29A4592437F5D8A90A", forHTTPHeaderField: "X-Api-Key")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { (response: NSURLResponse!, responseData: NSData!, error: NSError!) -> Void in
            if error != nil {
                println(error.description)
            }
        }
    }
    
    func makeHTTPPostRequest(path: String, body: String) {
        let url = NSURL(string: path)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        let conn = NSURLConnection(request: request, delegate:self)

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
}