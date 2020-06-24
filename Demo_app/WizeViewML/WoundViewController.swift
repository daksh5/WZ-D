//
//  WoundViewController.swift
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

class WoundViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePickerController : UIImagePickerController!

    @IBOutlet weak var imageView: UIImageView!
    
    var resource:UUID = UUID()
    let type = "jpeg"
    
    let aws_secret_access_key = ""
    let aws_access_key_id = "c"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: aws_access_key_id, secretKey: aws_secret_access_key)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration

        
    }
    
    @IBAction func take_picture_btn(_ sender: Any) {
        
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is saving_woundViewController
        {
            let vc = segue.destination as? saving_woundViewController
            vc?.filename = "\(resource).\(type)"
        }
    }
    
    
    
    
    func saveImage(imageName: String){
        
        let fileManager = FileManager.default
        
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        let image = imageView.image!
        
        let data = image.jpegData(compressionQuality: -4)
        print("saving.. \(resource).\(type)")
        
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePickerController.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        do{
            
            let name = "\(resource).\(type)"
            saveImage(imageName: name)
            let paths = NSSearchPathForDirectoriesInDomains(
                FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
            print(documentsDirectory)
            let dataPath = documentsDirectory.appendingPathComponent(name)
            print(dataPath.absoluteString)
            
        }
        
    }
    
}
