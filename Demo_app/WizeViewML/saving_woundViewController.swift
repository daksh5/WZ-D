//
//  saving_woundViewController.swift
//  Demo_app
//
//  Created by Daksh Parikh on 8/2/19.
//  Copyright © 2019 Daksh Parikh. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import AWSCognito
import AWSS3
import MobileCoreServices

class saving_woundViewController: UIViewController {

    @IBOutlet weak var uploading_lbl: UILabel!
    
    
    var filename = ""
    let bucketName = "wizeview-appimages"
    let woundid:UUID = UUID()
    var result: [String] = []
    var error: [String] = []
    var statuscode = 0
    let aws_secret_access_key = ""
    let aws_access_key_id = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: aws_access_key_id, secretKey: aws_secret_access_key)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration


        
        let paths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
        let dataPath = documentsDirectory.appendingPathComponent(filename)
        print(dataPath.absoluteString)
        
        
        let request = AWSS3TransferManagerUploadRequest()!
        request.bucket = bucketName
        request.key = filename
        request.body = dataPath
        request.contentType = "image/jpeg"
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(request).continueWith(executor: AWSExecutor.mainThread()) { (task) -> Any? in
            if let error = task.error {
                print("error is\(error)")
                self.uploading_lbl.text = "fail"
            }
            if task.result != nil {
                print("Uploaded \(self.filename)")
                self.uploading_lbl.text = "Requesting Data"
                
                let getPreSignedURLRequest = AWSS3GetPreSignedURLRequest()
                getPreSignedURLRequest.bucket = self.bucketName
                getPreSignedURLRequest.key = "\(self.filename)"
                getPreSignedURLRequest.httpMethod = .GET
                getPreSignedURLRequest.expires = Date(timeIntervalSinceNow: 60)
                
                
                
                AWSS3PreSignedURLBuilder.default().getPreSignedURL(getPreSignedURLRequest).continueWith { (task:AWSTask<NSURL>) -> Any? in
                    if let error = task.error as NSError? {
                        print("Error: \(error)")
                        return nil
                    }
                    
                    let presignedURL = task.result
                    print("Download presignedURL is: \(String(describing: presignedURL))")
                    var nonempty: String = (presignedURL?.absoluteString)!
                    let vowels: Set<Character> = ["(",")"]
                    nonempty.removeAll(where: { vowels.contains($0) })
                    let wordToRemove = "Optional"
                    
                    
                    if let range = nonempty.range(of: wordToRemove) {
                        nonempty.removeSubrange(range)
                    }
                    
                    let visitId = "0"
                    let patientId = "1"
                    let pitureURL = nonempty
                    let pitureNumber = 0
                    let tag = "label"
                    
                    let poststring = ["visitId":visitId, "patientId":patientId, "pictureURL":pitureURL, "pictureNumber":pitureNumber, "tag":tag] as [String : Any]
                    
                    let jsonData = try? JSONSerialization.data(withJSONObject: poststring)
                    
                    var request = URLRequest(url: URL(string: "https://api.wizeview.com/v1/wounds/\(self.woundid)/pictures")!)
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
                            print("statusCode: \(response!.statusCode)")
                            self.statuscode = response!.statusCode
                            
                        }
                        
                        if self.statuscode==200 || self.statuscode == 201 {
                            
                            guard let data = data else {return}
                            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                            if let responseJSON = responseJSON as? [String:Any]{
                                DispatchQueue.main.async {
                                    print("respons : \(responseJSON)")
                                    
                                    self.result.append(responseJSON["stage"] as! String)
                                    self.result.append(responseJSON["eschar"] as! String)
                                    self.result.append(responseJSON["slough"] as! String)
                                    self.result.append(responseJSON["primaryColor"] as! String)
                                    
                                    self.resulttable()
                                    
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
    
    
    func resulttable() {
        
        performSegue(withIdentifier: "w_upload_to_table", sender: self)
        
    }
    
    func errortable() {
        
        performSegue(withIdentifier: "w_upload_to_errortable", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is wound_tableViewController
        {
            let vc = segue.destination as? wound_tableViewController
            vc?.result = result
        }
        
        if segue.destination is wound_error_tableViewController{
            let vc = segue.destination as? wound_error_tableViewController
            vc?.error = error
        }
    }
    
}
