//
//  SegmentViewController.swift
//  Example
//
//  Created by iOS on 25/04/17.
//  Copyright © 2017 iOS. All rights reserved.
//

import UIKit

class SegmentViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate , UIDocumentPickerDelegate  {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var lblDocName: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var btnChooseFile: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    
    var status0:String!
    var status1:String!
    var imagePicker = UIImagePickerController()
    var imageUIimage : UIImage?
    var isimageDocPicker:Bool!
    var isimageSelected:Bool!
    var file:String!
    var pickedImage : UIImage = UIImage()
    var strType:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         isimageSelected = false
        isimageDocPicker = false
        status0 = "Yes"
        status1 = "No"
        
        
    }

    @IBAction func segmentControl(_ sender: Any)
    {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            status0 = "Yes"
            status1 = "No"
            break
        case 1:
            status1 = "Yes"
            status0 = "No"
            break
        default:
            break;
        }
    }
    
    @IBAction func btnChooseFile(_ sender: Any)
    {
        if status0 == "Yes"
        {
            choosePDF()
            strType = "1"
        }
        if status1 == "Yes"
        {
            chooseFile()
            strType = "0"
        }
    }
    
    
    func chooseFile()
    {
        let alert = UIAlertController(title: "Select Option", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.actionLaunchCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Chooose from Gallery", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum)
            {
                print("Chooose from Gallery")
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
                
               self.imagePicker.mediaTypes = ["public.image", "public.movie"]
                
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func choosePDF()
    {
//        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.text", "public.data","public.pdf", "public.doc"], in: .import)
//        importMenu.delegate = self as? UIDocumentMenuDelegate
//        present(importMenu, animated: true, completion: nil)

        let types: [Any]? = ["public.text", "public.data","public.pdf", "public.doc"]
        //Create a object of document picker view and set the mode to Import
        let docPicker = UIDocumentPickerViewController(documentTypes: types as! [String], in: .import)
        //Set the delegate
        docPicker.delegate = self
        //present the document picker
        present(docPicker, animated: true, completion: { _ in })

    }
    
    
    @IBAction func btnOpenFile(_ sender: Any)
    {
        //Export
/*        let documentPicker = UIDocumentPickerViewController(url: Bundle.main.url(forResource: "image", withExtension: "jpg")!, in: .exportToService)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        present(documentPicker, animated: true, completion: { _ in })
*/

 /*       let importMenu = UIDocumentMenuViewController(documentTypes: ["public.text", "public.data","public.pdf", "public.doc"], in: .import)
        importMenu.delegate = self as? UIDocumentMenuDelegate
        importMenu.addOption(withTitle: "Create New Document", image: nil, order: .first, handler: { print("New Doc Requested") })
        present(importMenu, animated: true, completion: nil)
 */
        
        let filePathToUpload = URL(fileURLWithPath: Bundle.main.path(forResource: "pdf-sample", ofType: "pdf")!)
        //Create a object of document picker view and set the mode to Export
        let docPicker = UIDocumentPickerViewController(url: filePathToUpload, in: .exportToService)
        //Set the delegate
        docPicker.delegate = self
        //present the document picker
        present(docPicker, animated: true, completion: { _ in })

    }
    
    
    @IBAction func btnDownload(_ sender: Any)
    {
        let types: [Any]? = ["public.text", "public.data","public.pdf", "public.doc"]
        //Create a object of document picker view and set the mode to Import
        let docPicker = UIDocumentPickerViewController(documentTypes: types as! [String], in: .import)
        //Set the delegate
        docPicker.delegate = self
        //present the document picker
        present(docPicker, animated: true, completion: { _ in })
    }
    
    
    @IBAction func btnUpload(_ sender: Any)
    {
        
        CallWebService_getSelectedWorkOrder(str: strType)
    }
    
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: { _ in })
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        if controller.documentPickerMode == .import {
            let alertMessage: String = "Successfully imported \(url.lastPathComponent)"
            lblDocName.text = url.lastPathComponent
//            pickedImage = url
            isimageDocPicker=true
            let imageData:NSData = NSData(contentsOf: url)!
            UserDefaults.standard.set(imageData, forKey: "imageData")
            UserDefaults.standard.synchronize()
  
//==========
            
//            let imageData:NSData = NSData(contentsOf: url)!
//            let image = UIImage(data: imageData as Data)
//            imgView.image = image
//            imageUIimage = image
            
//==========
        
            DispatchQueue.main.async(execute: {() -> Void in
                let alertController = UIAlertController(title: "Import", message: alertMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            })
        }else if controller.documentPickerMode == .exportToService {
            // Called when user uploaded the file - Display success alert
            DispatchQueue.main.async(execute: {() -> Void in
                let alertMessage: String = "Successfully exported \(url.lastPathComponent)"
                self.lblDocName.text = url.lastPathComponent
                let alertController = UIAlertController(title: "Export", message: alertMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: { _ in })
            })
        }
    }


//// correct
func openFile(path:String, UTF8:String.Encoding = String.Encoding.utf8) -> String?{
    if FileManager().fileExists(atPath: path) {
        do {
            let string = try String(contentsOfFile: path, encoding: .utf8)
            return string
        }catch let error as NSError{
            return error.localizedDescription
        }
    } else {
        return nil
    }
}


    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    }

    func actionLaunchCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            let imagePicker:UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController(title: "Camera Unavailable", message: "Unable to find a camera on this device", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        pickedImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        print("pickedImage......\(pickedImage)")
        isimageSelected = true
        self.dismiss(animated: true, completion: { () -> Void in
        })

        
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//        imageUIimage = image
//        isimageSelected = true
//            
//        print("imageUIimage........\(imageUIimage!)")
//        }
//        picker.dismiss(animated: true, completion: nil);
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    //MARK: - API calling
    func createBodyWithParameters(_ parameters: [String: String]?, boundary: String) -> Data {
        let body = NSMutableData();
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        body.appendString("--\(boundary)--\r\n")
        return body as Data
    }
    
    func createBodyWithParameters(_ parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        if self.isimageSelected==true {
            let filename = "picture.png"
            let mimetype = "application/octet-stream"
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageDataKey)
            body.appendString("\r\n")
   //====
        }else if self.isimageDocPicker==true {
            let filename = "picture.pdf"
            let mimetype = "application/octet-stream"
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageDataKey)
            body.appendString("\r\n")

  //======
        }else{
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(String(describing: filePathKey))\"\r\n\r\n")
            let value : String = ""
            body.appendString("\(value)\r\n")
        }
        body.appendString("--\(boundary)--\r\n")
        
        return body as Data
    }

    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    func CallWebService_getSelectedWorkOrder(str:String)
    {
        //web service
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let strSubUrl: String="http://parkhyamapps.co.in/icontractor/index.php/contractor/uploadFiles"
        let url1 =  strSubUrl
        
        let myUrl = URL(string: url1);
        var request = URLRequest(url:myUrl!)
        request.timeoutInterval = 10
        request.httpMethod = "POST";
        
        var device_token:String!
        
        if UserDefaults.standard.object(forKey: "DeviceToken") != nil {
            device_token = UserDefaults.standard.object(forKey: "DeviceToken")as! String
            print("DeviceToken....\(device_token!)")
        } else {
            device_token = ""
        }
        
            /*
     user_id
     session_key
     device_id
     type : 0 - image / 1 - pdf
     files
     */
        let params12 = [
            "user_id"     : "10",
            "session_key"       : "k8umx5TRY11SAuC",
            "device_id"         : "\(device_token!)",
            "type"              : "\(str)",
//           "files"             : ""
        ]
        print("params12.......\(params12)")

        let boundary = generateBoundaryString()
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        let imageData = UIImageJPEGRepresentation(imageUIimage!, 0.3)
//        if(imageData==nil){
//            return;
//        }
//        request.httpBody = createBodyWithParameters(params12, filePathKey: "files", imageDataKey: imageData!, boundary: boundary)
       
        
        if self.isimageSelected == true {
            let imageData = UIImageJPEGRepresentation(pickedImage, 0.3)
            
            if(imageData==nil)  {
                return;
            }
            request.httpBody = createBodyWithParameters(params12, filePathKey: "profile", imageDataKey: imageData!, boundary: boundary)
            
            
        }else if self.isimageDocPicker == true {
            let data = UserDefaults.standard.value(forKey: "imageData")!
            request.httpBody = createBodyWithParameters(params12, filePathKey: "profile", imageDataKey: data as! Data, boundary: boundary)
            
        }else{
            request.httpBody = createBodyWithParameters(params12,boundary: boundary)
        }

        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if error != nil
            {
                print("error==========\(error)")
                DispatchQueue.main.async(execute: { () -> Void in
                })
                
                let uiAlert = UIAlertController(title: "Alert!", message: "Network connection may have been lost, \n Try again later", preferredStyle: UIAlertControllerStyle.alert)
                self.present(uiAlert, animated: true, completion: nil)
                
                uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                }))
                
                return
                
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("response data ========== \(responseString!)")
            
            do
            {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                if let Dictionar = json as? NSDictionary
                {
                    print("Response Dictionar >>> \(Dictionar)")
                    let message=Dictionar["message"] as? NSString
                    
                    if message=="success"
                    {
                        print("success==========")
                    }
                    else
                    {
                        DispatchQueue.main.async(execute: { () -> Void in
                        })
                    }
                }
            }
            catch
            {
            }
        })
        task.resume()
    }
}


extension NSMutableData {
    func appendString(_ string: String){
        let data = string.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: true)
        append(data!)
    }
}
