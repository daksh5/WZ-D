//
//  TugViewController.swift
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
import Overture

class TugViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var uploadVideoButton: UIButton!
    @IBOutlet weak var recordVideoButton: UIButton!
    
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var resource:UUID = UUID()
    let type = "mp4"
    let aws_secret_access_key = ""
    let aws_access_key_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: aws_access_key_id, secretKey: aws_secret_access_key)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        with(galleryButton, primaryButtonStyle)
        with(uploadVideoButton, primaryButtonStyle)
        with(recordVideoButton, primaryButtonStyle)
    }
    
    
    @IBAction func open_gallery(_ sender: Any) {
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    

    
    @IBAction func record_video_btn(_ sender: Any) {
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera)){
            if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                    
                    imagePicker.sourceType = .camera
                    imagePicker.mediaTypes = [kUTTypeMovie as String]
                    imagePicker.allowsEditing = false
                    imagePicker.delegate = self
                    
                    present(imagePicker, animated: true, completion: {})
                } else {
                    postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
                }
            } else {
                postAlert("Camera inaccessable", message: "Application cannot access the camera.")
            }
        }
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is saving_tugViewController
        {
            let vc = segue.destination as? saving_tugViewController
            vc?.filename = "\(resource).\(type)"
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
           
            let videoData = try? Data(contentsOf: pickedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
            let dataPath = documentsDirectory.appendingPathComponent("\(resource).\(type)")
            try! videoData?.write(to: dataPath, options: [])
            print("Saved to " + dataPath.absoluteString)
            
            do{
                let key = "\(resource).\(type)"
                
                let paths = NSSearchPathForDirectoriesInDomains(
                    FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
                let dataPath = documentsDirectory.appendingPathComponent(key)
                print(dataPath.absoluteString)
            }
        }
        
        imagePicker.dismiss(animated: true, completion: {
        })
    }
    
    // Called when the user selects cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("User canceled image")
        dismiss(animated: true, completion: {
            
        })
    }
    
    
    func postAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}
