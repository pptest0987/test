//
//  FilterViewController.swift
//  iServices
//
//  Created by iOS on 29/04/17.
//  Copyright © 2017 Parkhya Solutions. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource  {

    @IBOutlet weak var collectionViewJobCategory: UICollectionView!
    @IBOutlet weak var collectionViewJobStatus: UICollectionView!
    @IBOutlet weak var btnFilter: UIButton!
    
    var arrCategory: NSMutableArray = NSMutableArray()
    var arrStatus: NSMutableArray = NSMutableArray()
    var category_id: String = String()
    let arrCat:NSMutableArray=NSMutableArray()
    let arrWorkStatus:NSMutableArray=NSMutableArray()

//    var category_id:NSMutableArray=NSMutableArray()
    var strFrom_category:String!
    var strFrom_status:String!
    var work_status:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CallWebService_Category()
        arrStatus = ["Draft","Open","Job Evolution","Ongoing","Finished","Completed","Expired"]
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
//        print("arrCategory......\(arrCategory)")
//        category_id = arrCategory.value(forKey: "category_id")as! NSMutableArray
//        print("category_id.......\(category_id)")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var n = Int()
        n=0
        if collectionView==collectionViewJobCategory
        {
            return arrCategory.count
        }
        if collectionView==collectionViewJobStatus
        {
            return arrStatus.count
        }
        return n
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewJobCategory
        {
        
          let cell: FilterCategoryCollectionVC = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCategoryCollectionVC", for: indexPath) as! FilterCategoryCollectionVC
          cell.lblCategory.text = (self.arrCategory[indexPath.row]as! NSDictionary)["category_name"] as? String
            
          let url1 = URL(string: ((self.arrCategory[indexPath.row]as! NSDictionary)["image"] as! String))
          cell.imgView.sd_setImage(with: url1, placeholderImage: UIImage.init(named: "logo1.png"))
            
          return cell
        }
        
        if collectionView == collectionViewJobStatus
        {
           
            let cell: FilterStatusCollectionVC = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterStatusCollectionVC", for: indexPath) as! FilterStatusCollectionVC
            cell.lblStatus.text = self.arrStatus[indexPath.row] as! String
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == collectionViewJobCategory
        {
            let cell:FilterCategoryCollectionVC = collectionViewJobCategory.cellForItem(at: indexPath)! as! FilterCategoryCollectionVC
            if(cell.isSelected)
            {
                cell.contentView.backgroundColor = UIColor.green
            }
            else
            {
                cell.contentView.backgroundColor = UIColor.clear
            }

           
            print("You selected cell #\(indexPath.item)!")
            category_id = ((self.arrCategory[indexPath.item]as! NSDictionary)["category_id"] as? String)!
            
            arrCat.add(category_id)
            
            strFrom_category = (arrCat.componentsJoined(by: ",") as NSString) as String!
            
        }
        if collectionView == collectionViewJobStatus
        {
            let cell:FilterStatusCollectionVC = collectionViewJobStatus.cellForItem(at: indexPath)! as! FilterStatusCollectionVC
            
            cell.lblStatus.text = self.arrStatus[indexPath.row] as? String

            if(cell.isSelected)
            {
                cell.imgView.backgroundColor = UIColor.green
            }
            else
            {
                cell.imgView.backgroundColor = UIColor.clear
            }
            
            if cell.lblStatus.text == "Draft" {
                work_status = "0"
            }
            else if cell.lblStatus.text == "Open" {
                work_status = "1"
            }
            else if cell.lblStatus.text == "Job evaluation" {
                work_status = "2"
            }
            else if cell.lblStatus.text == "Ongoing" {
                work_status = "3"
            }
            else if cell.lblStatus.text == "Finished" {
                work_status = "4"
            }
            else if cell.lblStatus.text == "Completed" {
                work_status = "5"
            }
            else if cell.lblStatus.text == "Expired" {
                work_status = "6"
            }

            arrWorkStatus.add(work_status)
            strFrom_status = (arrWorkStatus.componentsJoined(by: ",") as NSString) as String!
            
            print("You selected cell #\(indexPath.item)!")
            category_id = ((self.arrCategory[indexPath.item]as! NSDictionary)["category_id"] as? String)!
        }

    }

    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let screenRect: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenRect.size.width
        let cellWidth: Float = Float(screenWidth) / 3.0
        //Replace the divisor with the column count requirement. Make sure to have it in float.
        let size = CGSize(width: CGFloat(cellWidth), height: CGFloat(cellWidth))
        
        return size;
    }
    
 /*   func btnCellCancel(_ sender:UIButton){
        let i:Int = (sender.layer.value(forKey: "index")) as! Int
        imagesArray.remove(at: i)
        //        imagesArray.removeObject(at: i)
        let indexPath: IndexPath = IndexPath(row: i, section: 0)
        self.collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: [indexPath])
        }, completion: {
            (finished: Bool) in
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
        })
    }
*/
    
    
    @IBAction func btnReset(_ sender: Any)
    {
        CallWebService_resetFilter()
    }
    
    @IBAction func btnFilter(_ sender: Any)
    {
        CallWebService_saveFilter()
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
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func CallWebService_Category()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let strSubUrl: String="http://parkhyamapps.co.in/icontractor/index.php/user/getCategory"
        let url1 = strSubUrl
        
        let myUrl = URL(string: url1);
        //        let request = NSMutableURLRequest(url:myUrl!);
        var request = URLRequest(url:myUrl!)
        request.timeoutInterval = 10
        request.httpMethod = "POST";
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        // request.httpBody = createBodyWithParameters(params12, boundary: boundary)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if error != nil
            {
                print("error==========\(error)")
                // self.CallWebService_RestrList()
                DispatchQueue.main.async(execute: { () -> Void in
                })
                let uiAlert = UIAlertController(title: "Alert!", message: "Please check your internet connection, \n Try again later", preferredStyle: UIAlertControllerStyle.alert)
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
                    print("Response getCategory >>> \(Dictionar)")
                    let message=Dictionar["message"] as? NSString
                    if message=="success"
                    {
                        print("success==========")
                        
                        var arrRestrInfoNew: NSMutableArray = NSMutableArray()
                        arrRestrInfoNew=(Dictionar["category"]as? NSArray)?.mutableCopy() as! NSMutableArray
                        
                        self.arrCategory.addObjects(from: arrRestrInfoNew as [AnyObject])
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.collectionViewJobCategory .reloadData()
                        })
                    }
                    else
                    {
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.collectionViewJobCategory .reloadData()
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

    func CallWebService_resetFilter()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let strSubUrl: String="http://parkhyamapps.co.in/icontractor/index.php/user/resetFilter"
        let url1 = strSubUrl
        
        let myUrl = URL(string: url1);
        //        let request = NSMutableURLRequest(url:myUrl!);
        var request = URLRequest(url:myUrl!)
        request.timeoutInterval = 10
        request.httpMethod = "POST";
        
        var device_token:String!
        
        if UserDefaults.standard.object(forKey: "DeviceToken") != nil {
            device_token = UserDefaults.standard.object(forKey: "DeviceToken")as! String
            print("DeviceToken....\(device_token!)")
        } else {
            device_token = "8b0a30790da7f683a1f9be78f307cb6449c6ea309e62788e3d906f297eb09665"
        }
        
        let params12 = [
            "user_id"       : "10",
            "session_key"   : "9L3JmqQb3r5X96u1",
            "device_id"     : "\(device_token!)"
        ]
        print("params12....\(params12)")
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBodyWithParameters(params12, boundary: boundary)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if error != nil
            {
                print("error==========\(error)")
                // self.CallWebService_RestrList()
                DispatchQueue.main.async(execute: { () -> Void in
                })
                let uiAlert = UIAlertController(title: "Alert!", message: "Please check your internet connection, \n Try again later", preferredStyle: UIAlertControllerStyle.alert)
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
                    print("Response getCategory >>> \(Dictionar)")
                    let message=Dictionar["message"] as? NSString
                    if message=="success"
                    {
                        print("success==========")
                        
                        var arrRestrInfoNew: NSMutableArray = NSMutableArray()
                        arrRestrInfoNew=(Dictionar["category"]as? NSArray)?.mutableCopy() as! NSMutableArray
                        
                        self.arrCategory.addObjects(from: arrRestrInfoNew as [AnyObject])
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.collectionViewJobCategory .reloadData()
                        })
                    }
                    else
                    {
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.collectionViewJobCategory .reloadData()
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

    
    func CallWebService_saveFilter()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let strSubUrl: String="http://parkhyamapps.co.in/icontractor/index.php/user/saveFilter"
        let url1 = strSubUrl
        
        let myUrl = URL(string: url1);
        //        let request = NSMutableURLRequest(url:myUrl!);
        var request = URLRequest(url:myUrl!)
        request.timeoutInterval = 10
        request.httpMethod = "POST";
        
        var device_token:String!
        
        if UserDefaults.standard.object(forKey: "DeviceToken") != nil {
            device_token = UserDefaults.standard.object(forKey: "DeviceToken")as! String
            print("DeviceToken....\(device_token!)")
        } else {
            device_token = "8b0a30790da7f683a1f9be78f307cb6449c6ea309e62788e3d906f297eb09665"
        }
        
        /*
         user_id
         category : comma sepearted category id
         work_status : comma sepearted status
         device_id
         session_key
 */
        let params12 = [
            "user_id"           : "10",
            "category"          : "\(strFrom_category!)",
            "work_status"       : "\(strFrom_status!)",
            "device_id"         : "\(device_token!)",
            "session_key"       : "9L3JmqQb3r5X96u1"

        ]
        print("params12....\(params12)")
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBodyWithParameters(params12, boundary: boundary)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if error != nil
            {
                print("error==========\(error)")
                // self.CallWebService_RestrList()
                DispatchQueue.main.async(execute: { () -> Void in
                })
                let uiAlert = UIAlertController(title: "Alert!", message: "Please check your internet connection, \n Try again later", preferredStyle: UIAlertControllerStyle.alert)
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
                    print("Response getCategory >>> \(Dictionar)")
                    let message=Dictionar["message"] as? NSString
                    if message=="success"
                    {
                        print("success==========")
                        
                        var arrRestrInfoNew: NSMutableArray = NSMutableArray()
                        arrRestrInfoNew=(Dictionar["category"]as? NSArray)?.mutableCopy() as! NSMutableArray
                        
                        self.arrCategory.addObjects(from: arrRestrInfoNew as [AnyObject])
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.collectionViewJobCategory .reloadData()
                        })
                    }
                    else
                    {
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.collectionViewJobCategory .reloadData()
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
