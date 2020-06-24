//
//  saving_tugViewController.swift
//  Demo_app
//
//  Created by Daksh Parikh on 8/6/19.
//  Copyright © 2019 Daksh Parikh. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import AWSCognito
import AWSS3
import MobileCoreServices

class saving_tugViewController: UIViewController {
    
    let bucketName = "wizeview-appimages"
    let videoid:UUID = UUID()
    var filename = ""
    var result: [Int] = []
    var error: [String] = []
    let aws_access_key_id = ""
    let aws_secret_access_key = ""
    var statuscode = 0
    

    @IBOutlet weak var lbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: aws_access_key_id, secretKey: aws_secret_access_key)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        
        
        
        let key = filename
        let paths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
        let dataPath = documentsDirectory.appendingPathComponent(key)
        print(dataPath.absoluteString)
        
        let request = AWSS3TransferManagerUploadRequest()!
        request.bucket = bucketName
        request.key = key
        request.body = dataPath
        request.contentType = "video/mp4"
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(request).continueWith(executor: AWSExecutor.mainThread()) { (task) -> Any? in
            if let error = task.error {
                print("error is\(error)")
                self.lbl.text = "Fail"
            }
            if task.result != nil {
                print("Uploaded \(key)")
                self.lbl.text = "Requesting Data"
                
                let getPreSignedURLRequest = AWSS3GetPreSignedURLRequest()
                getPreSignedURLRequest.bucket = self.bucketName
                getPreSignedURLRequest.key = key
                getPreSignedURLRequest.httpMethod = .GET
                getPreSignedURLRequest.expires = Date(timeIntervalSinceNow: 3600)
                
                
                
                AWSS3PreSignedURLBuilder.default().getPreSignedURL(getPreSignedURLRequest).continueWith { (task:AWSTask<NSURL>) -> Any? in
                    if let error = task.error as? NSError {
                        print("Error: \(error)")
                        return nil
                    }
                    
                    let presignedURL = task.result
                    var preurl: String = (presignedURL?.absoluteString)!
                    let vowels: Set<Character> = ["(",")"]
                    preurl.removeAll(where: { vowels.contains($0) })
                    let wordToRemove = "Optional"
                    
                    
                    if let range = preurl.range(of: wordToRemove) {
                        preurl.removeSubrange(range)
                    }
                    print("URL:  \(preurl)")
                    let visitId = "0"
                    let patientId = "1"
                    let videoURL = preurl
                    
                    let poststring = ["visitId":visitId, "patientId":patientId, "videoURL":videoURL]
                    
                    
                    let jsonData = try? JSONSerialization.data(withJSONObject: poststring)
                    
                    var request = URLRequest(url: URL(string: "https://temp.wizeview.com/sts")!)
                    request.httpMethod = "POST"
                    request.setValue("1URSEnhMwNqpCVXW0TmA4vtpuXYhXyhdICFOdL90", forHTTPHeaderField: "x-api-key")
                    
                    
                    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                    request.httpBody = jsonData
                    
                    
                    
                    let task = URLSession.shared.dataTask(with: request) {
                        (data, response, error) in
                        if let error = error {
                            print(error)
                            return
                        }else {
                            let response = response as? HTTPURLResponse
                            
                            self.statuscode = response!.statusCode
                            print("statusCode: \(self.statuscode)")
                            
                        }
                        
                        if self.statuscode==200 || self.statuscode == 201 {
                            
                            guard let data = data else {return}
                            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                            if let responseJSON = responseJSON as? [String:Any]{
                                
                                DispatchQueue.main.async {
                                    print("respons : \(responseJSON)")
                                    
                                    self.result.append(responseJSON["unable_rise"] as! Int)
                                    self.result.append(responseJSON["unable_straighten"] as! Int)
                                    self.result.append(responseJSON["sts_count"] as! Int)
                                    self.resultable()
                               }
                                
                                
                                
                            }
                            
                        }else if self.statuscode==500 {
                            
                            guard let data_error = data else {return}
                            let responseJSON_error = try? JSONSerialization.jsonObject(with: data_error, options: [])
                            if let responseJSON = responseJSON_error as? [String:Any]{
                                DispatchQueue.main.async {
                                    print("respons : \(responseJSON)")
                                    
                                    var erroercode: String = "\(String(describing: responseJSON["errorCode"]))"
                                    let vowels: Set<Character> = ["(",")"]
                                    erroercode.removeAll(where: { vowels.contains($0) })
                                    let wordToRemove = "Optional"
                                    
                                    
                                    if let range = erroercode.range(of: wordToRemove) {
                                        erroercode.removeSubrange(range)
                                    }
                                    
                                    self.error.append(responseJSON["errorMessage"] as! String)
                                    self.error.append("\(self.statuscode)")
                                    
                                    self.error.append(erroercode)
                                    self.errortable()
                                }
                                
                                
                                
                            }
                            
                            
                        } else{
                            
                            guard let data_error = data else {return}
                            let responseJSON_error = try? JSONSerialization.jsonObject(with: data_error, options: [])
                            if let responseJSON = responseJSON_error as? [String:Any]{
                                
                               DispatchQueue.main.async {
                                    print("respons : \(responseJSON)")
                                    
                                    var erroercode: String = "\(String(describing: responseJSON["errorCode"]))"
                                    let vowels: Set<Character> = ["(",")"]
                                    erroercode.removeAll(where: { vowels.contains($0) })
                                    let wordToRemove = "Optional"
                                    
                                    
                                    if let range = erroercode.range(of: wordToRemove) {
                                        erroercode.removeSubrange(range)
                                    }
                                    
                                    self.error.append(responseJSON["message"] as! String)
                                    self.error.append("\(self.statuscode)")
                                    
                                    self.error.append(erroercode)
                                    self.errortable()
                                
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    task.resume()
                    
                    return nil
                }
            }
            
            return nil
        }

        
    }
    
    
    func resultable() {
        
        performSegue(withIdentifier: "t_upload_to_table", sender: self)
        
    }
    
    func errortable() {
        
        performSegue(withIdentifier: "t_upload_to_errortable", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is tug_tableViewController
        {
            let vc = segue.destination as? tug_tableViewController
            vc?.result = result
        }
        
        if segue.destination is tug_error_tableViewController{
            let vc = segue.destination as? tug_error_tableViewController
            vc?.error = error
        }
    }
    


}
