//
//  ViewController.swift
//  OCR
//
//  Created by Navi on 19/05/2019.
//  Copyright © 2019 Navi. All rights reserved.
//

import UIKit
import SwiftyTesseract
import CoreImage
import Alamofire

class ViewController: UIViewController {

    private var rect: CIRectangleFeature = CIRectangleFeature()
    private var cropRect: CropRect!
    
    var originalImage = UIImage(named: "font")
    
    private var cropedImage: UIImage!
    
    var currentStep = 0
    let opencvWrapper = OpenCVWrapper();
    
    let arabicTesseract = SwiftyTesseract(language: .arabic)
    let englishTesseract = SwiftyTesseract(language: .english)
//    let hinTesseract = SwiftyTesseract(language: .custom("Arabic"))
    let hinTesseract = SwiftyTesseract(language: .hindi)

    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var imgView3: UIImageView!
    @IBOutlet weak var imgView4: UIImageView!
    @IBOutlet weak var imgView5: UIImageView!
    @IBOutlet weak var imgView6: UIImageView!
    
    @IBOutlet weak var img_photoView: UIImageView!
    
    @IBOutlet weak var img_barcodeView: UIImageView!
    
    
    var str_firstname = ""
    var str_lastname = ""
    var str_address1 = ""
    var str_address2 = ""
    var str_num1 = ""
    var str_num2 = ""
    
    var str_start1 = ""
    var str_start2 = ""
    var str_expiry = ""
    
    var str_data1 = ""
    var str_data2 = ""
    var str_data3 = ""
    var str_data4 = ""
    
    
    
    var ocr_counts = 0
    
    //Front
    var img_firstname : UIImage!
    var img_lastname : UIImage!
    var img_addressline1 : UIImage!
    var img_addressline2 : UIImage!
    var img_num1 : UIImage!
    var img_num2 : UIImage!
    var img_avatar : UIImage!
    
    //Back
    var img_startDate : UIImage!
    var img_startDate2 : UIImage!
    var img_expiryDate : UIImage!
    
    var img_data1 : UIImage!
    var img_data2 : UIImage!
    var img_data3 : UIImage!
    var img_data4 : UIImage!
    
    var img_barcode : UIImage!
//    var img_data1 : UIImage!
//    var img_data1 : UIImage!
    
//    let thres_name = UnsafeMutablePointer<Int32>.init(bitPattern: 50)
//
//    let thres_txt = UnsafeMutablePointer<Int32>.init(bitPattern: 50)
//    let thres_num1 = UnsafeMutablePointer<Int32>.init(bitPattern: 30)
//    let thres_num2 = UnsafeMutablePointer<Int32>.init(bitPattern: 110)
//
//    let thres_date = UnsafeMutablePointer<Int32>.init(bitPattern: 90)
    
    
    let thres_ = UnsafeMutablePointer<Int32>.init(bitPattern: 90)
    
    let thres_num1 = UnsafeMutablePointer<Int32>.init(bitPattern: 60)
    
    let thres_date = UnsafeMutablePointer<Int32>.init(bitPattern: 110)
    
    var isFront = true
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        imageView.image = fixImageOrientation(originalImage!)
        
        if(isFront){
            self.img_barcodeView.isHidden = true
        }else{
            self.img_photoView.isHidden = true
        }
        
    }
    func fixImageOrientation(_ image: UIImage)->UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? image
    }
    @IBAction func changeSide(_ sender: UIButton) {
        
//        self.isFront = !self.isFront
//        if(isFront){
//            self.imageView.image = UIImage(named: "front")
//        }else{
//            self.imageView.image = UIImage(named: "back")
//        }
//        self.currentStep = 0
//
//        self.imgView1.isHidden = true
//        self.imgView2.isHidden = true
//        self.imgView3.isHidden = true
//        self.imgView4.isHidden = true
//        self.imgView5.isHidden = true
//        self.imgView6.isHidden = true
//
//        self.imageView.isHidden = false
        
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func btn_startPressed(_ sender: UIButton) {
        
        if(currentStep == 0){
        

            
            cropRect = imageView.detectEdges()
            cropedImage = imageView.crop(cropRect, andApplyBW: false)
            imageView.image = cropedImage
            
            img_avatar = cropImage(self.imageView.image!,toRect: CGRect(x: 15, y: 23, width: 150, height: 190),viewWidth: 575,viewHeight: 350)
            
            self.img_photoView.image = img_avatar
            
            
            img_barcode = cropImage(self.imageView.image!,toRect: CGRect(x: 14, y: 210, width: 545, height: 143),viewWidth: 575,viewHeight: 350)
            
            self.img_barcodeView.image = img_barcode

            
            
        } else if(currentStep == 1){
            imageView.image = opencvWrapper.makeGray(cropedImage)
            
        }
        else if(currentStep == 2){
            
            if(isFront){
                img_firstname = cropImage(self.imageView.image!,toRect: CGRect(x: 200, y: 85, width: 387, height: 46),viewWidth: 575,viewHeight: 350)
                
                img_lastname = cropImage(self.imageView.image!,toRect: CGRect(x: 200, y: 128, width: 376, height: 42),viewWidth: 575,viewHeight: 350)
                
                img_addressline1 = cropImage(self.imageView.image!,toRect: CGRect(x: 200, y: 166, width: 376, height: 40),viewWidth: 575,viewHeight: 350)
                
                img_addressline2 = cropImage(self.imageView.image!,toRect: CGRect(x: 200, y: 203, width: 376, height: 40),viewWidth: 575,viewHeight: 350)
                
                img_num1 = cropImage(self.imageView.image!,toRect: CGRect(x: 240, y: 270, width: 335, height: 45),viewWidth: 575,viewHeight: 350)
                
                img_num2 = cropImage(self.imageView.image!,toRect: CGRect(x: 24, y: 312, width: 190, height: 36),viewWidth: 575,viewHeight: 350)


                
//              self.imageView.image = img_num2
                
                img_firstname = opencvWrapper.thresholding(img_firstname,thres: thres_)
                img_lastname = opencvWrapper.thresholding(img_lastname, thres: thres_)
                img_addressline1 = opencvWrapper.thresholding(img_addressline1, thres: thres_)
                img_addressline2 = opencvWrapper.thresholding(img_addressline2, thres: thres_)
                img_num1 = opencvWrapper.thresholding(img_num1, thres: thres_num1)
                img_num2 = opencvWrapper.thresholding(img_num2, thres: thres_)
                
                self.imageView.isHidden = true
                
                self.imgView1.image = img_firstname
                self.imgView2.image = img_lastname
                self.imgView3.image = img_addressline1
                self.imgView4.image = img_addressline2
                self.imgView5.image = img_num1
                self.imgView6.image = img_num2
                
                self.imgView1.isHidden = false
                self.imgView2.isHidden = false
                self.imgView3.isHidden = false
                self.imgView4.isHidden = false
                self.imgView5.isHidden = false
                self.imgView6.isHidden = false
                

            }else{
                
                img_startDate = cropImage(self.imageView.image!,toRect: CGRect(x: 145, y: 10, width: 116, height: 40),viewWidth: 575,viewHeight: 360)
                
                img_startDate2 = cropImage(self.imageView.image!,toRect: CGRect(x: 263, y: 10, width: 210, height: 40),viewWidth: 575,viewHeight: 360)
                
                img_data1 = cropImage(self.imageView.image!,toRect: CGRect(x: 190, y: 48, width: 280, height: 30),viewWidth: 575,viewHeight: 360)
                
                img_data2 = cropImage(self.imageView.image!,toRect: CGRect(x: 190, y: 77, width: 277, height: 28),viewWidth: 575,viewHeight: 360)
                
                img_data3 = cropImage(self.imageView.image!,toRect: CGRect(x: 190, y: 108, width: 280, height: 35),viewWidth: 575,viewHeight: 360)
                
                img_expiryDate = cropImage(self.imageView.image!,toRect: CGRect(x: 181, y: 166, width: 126, height: 32),viewWidth: 575,viewHeight: 360)
                
                img_data4 = cropImage(self.imageView.image!,toRect: CGRect(x: 306, y: 168, width: 178, height: 36),viewWidth: 575,viewHeight: 360)
                
                
                
                img_startDate = opencvWrapper.thresholding(img_startDate,thres: thres_date)
                
                img_startDate2 = opencvWrapper.thresholding(img_startDate2,thres: thres_date)
                
                img_data1 = opencvWrapper.thresholding(img_data1,thres: thres_)
                
                img_data2 = opencvWrapper.thresholding(img_data2,thres: thres_)
                
                img_data3 = opencvWrapper.thresholding(img_data3,thres: thres_)
                
                img_expiryDate = opencvWrapper.thresholding(img_expiryDate,thres: thres_date)
                
                
                img_data4 = opencvWrapper.thresholding(img_data4,thres: thres_)
                
                
                self.imageView.isHidden = true
                
                self.imgView1.image = img_startDate
                self.imgView2.image = img_startDate2
                self.imgView3.image = img_data1
                self.imgView4.image = img_data2
                self.imgView5.image = img_expiryDate
//                self.imgView6.image = img_data3
                
                self.imgView1.isHidden = false
                self.imgView2.isHidden = false
                self.imgView3.isHidden = false
                self.imgView4.isHidden = false
                self.imgView5.isHidden = false
//                self.imgView6.isHidden = false
                
            }
        }
        else {
            ocr_counts = 0

          
            if(isFront){
                arabicTesseract.performOCR(on: img_firstname) { recognizedString in
                    
                    guard var recognizedString = recognizedString else { return }
                    recognizedString = recognizedString.replacingOccurrences(of: "\n", with: "")
                    print(recognizedString)
                    
                    
                    self.str_firstname = recognizedString
                    self.ocr_counts = self.ocr_counts + 1
                    if(self.ocr_counts == 6){
                        
                        let ocr = "first name : " + self.str_firstname + "\n" + "last name : " + self.str_lastname + "\n" + "address1 : " + self.str_address1 + "\n" + "address2 : " + self.str_address2 + "\n" +
                            "num1 : " + self.str_num1 + "\n" + "num2 : " + self.str_num2
                        
                        let alert = UIAlertController(title: "Tesseract Success", message: ocr, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                
                arabicTesseract.performOCR(on: img_lastname) { recognizedString in
                    
                    guard var recognizedString = recognizedString else { return }
                    recognizedString = recognizedString.replacingOccurrences(of: "\n", with: "")
                    print(recognizedString)
                    //                let alert = UIAlertController(title: "Tesseract Success", message: recognizedString, preferredStyle: UIAlertController.Style.alert)
                    //                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    //                self.present(alert, animated: true, completion: nil)
                    
                    self.str_lastname = recognizedString
                    
                    self.ocr_counts = self.ocr_counts + 1
                    if(self.ocr_counts == 6){
                        
                        let ocr = "first name : " + self.str_firstname + "\n" + "last name : " + self.str_lastname + "\n" + "address1 : " + self.str_address1 + "\n" + "address2 : " + self.str_address2 + "\n" +
                            "num1 : " + self.str_num1 + "\n" + "num2 : " + self.str_num2 + "\n"
                        
                        
                        let alert = UIAlertController(title: "Tesseract Success", message: ocr, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                
                arabicTesseract.performOCR(on: img_addressline1) { recognizedString in
                    
                    guard var recognizedString = recognizedString else { return }
                    recognizedString = recognizedString.replacingOccurrences(of: "\n", with: "")
                    print(recognizedString)
                    //                let alert = UIAlertController(title: "Tesseract Success", message: recognizedString, preferredStyle: UIAlertController.Style.alert)
                    //                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    //                self.present(alert, animated: true, completion: nil)
                    
                    self.str_address1 = recognizedString
                    
                    self.ocr_counts = self.ocr_counts + 1
                    if(self.ocr_counts == 6){
                        
                        let ocr = "first name : " + self.str_firstname + "\n" + "last name : " + self.str_lastname + "\n" + "address1 : " + self.str_address1 + "\n" + "address2 : " + self.str_address2 + "\n" +
                            "num1 : " + self.str_num1 + "\n" + "num2 : " + self.str_num2 + "\n"
                        
                        
                        let alert = UIAlertController(title: "Tesseract Success", message: ocr, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                arabicTesseract.performOCR(on: img_addressline2) { recognizedString in
                    
                    guard var recognizedString = recognizedString else { return }
                    recognizedString = recognizedString.replacingOccurrences(of: "\n", with: "")
                    print(recognizedString)
                    //                let alert = UIAlertController(title: "Tesseract Success", message: recognizedString, preferredStyle: UIAlertController.Style.alert)
                    //                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    //                self.present(alert, animated: true, completion: nil)
                    
                    self.str_address2 = recognizedString
                    
                    self.ocr_counts = self.ocr_counts + 1
                    if(self.ocr_counts == 6){
                        
                        let ocr = "first name : " + self.str_firstname + "\n" + "last name : " + self.str_lastname + "\n" + "address1 : " + self.str_address1 + "\n" + "address2 : " + self.str_address2 + "\n" +
                            "num1 : " + self.str_num1 + "\n" + "num2 : " + self.str_num2 + "\n"
                        
                        let alert = UIAlertController(title: "Tesseract Success", message: ocr, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                
                hinTesseract.performOCR(on: img_num1) { recognizedString in
                    
                    guard var recognizedString = recognizedString else { return }
                    recognizedString = recognizedString.replacingOccurrences(of: "\n", with: "")
                    print(recognizedString)
                    //                let alert = UIAlertController(title: "Tesseract Success", message: recognizedString, preferredStyle: UIAlertController.Style.alert)
                    //                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    //                self.present(alert, animated: true, completion: nil)
                    
                    self.str_num1 = recognizedString
                    
                    self.ocr_counts = self.ocr_counts + 1
                    if(self.ocr_counts == 6){
                        
                        let ocr = "first name : " + self.str_firstname + "\n" + "last name : " + self.str_lastname + "\n" + "address1 : " + self.str_address1 + "\n" + "address2 : " + self.str_address2 + "\n" +
                            "num1 : " + self.str_num1 + "\n" + "num2 : " + self.str_num2 + "\n"
                        let alert = UIAlertController(title: "Tesseract Success", message: ocr, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                
                englishTesseract.performOCR(on: img_num2) { recognizedString in
                    
                    guard var recognizedString = recognizedString else { return }
                    recognizedString = recognizedString.replacingOccurrences(of: "\n", with: "")
                    print(recognizedString)
                    
                    
                    self.str_num2 = recognizedString
                    
                    self.ocr_counts = self.ocr_counts + 1
                    if(self.ocr_counts == 6){
                        
                        let ocr = "first name : " + self.str_firstname + "\n" + "last name : " + self.str_lastname + "\n" + "address1 : " + self.str_address1 + "\n" + "address2 : " + self.str_address2 + "\n" +
                            "num1 : " + self.str_num1 + "\n" + "num2 : " + self.str_num2 + "\n"
                        
                        let alert = UIAlertController(title: "Tesseract Success", message: ocr, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }else{
                hinTesseract.performOCR(on: img_startDate) { recognizedString in
                    
                    guard var recognizedString = recognizedString else { return }
                    recognizedString = recognizedString.replacingOccurrences(of: "\n", with: "")
                    print(recognizedString)

                    self.ocr_counts = self.ocr_counts + 1
                    self.str_start1 = recognizedString
                    
                    if(self.ocr_counts == 7){
                        
                        let ocr = "Start: " + self.str_start1 + "\n" + "ID: "+self.str_start2 + "\n" + "JOB 1: " + self.str_data1 + "\n" + "JOB 2: " + self.str_data2 + "\n" + "JOB 3: " + self.str_data3 + "\n" + "Expiry: "
                            + self.str_expiry + "\n" + "Data: " + self.str_data4 + "\n"
                        
                        let alert = UIAlertController(title: "Tesseract Success", message: ocr, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    

                }
                
                hinTesseract.performOCR(on: img_startDate2) { recognizedString in
                    
                    guard var recognizedString = recognizedString else { return }
                    recognizedString = recognizedString.replacingOccurrences(of: "\n", with: "")
                    print(recognizedString)
                    self.ocr_counts = self.ocr_counts + 1
                    self.str_start2 = recognizedString
                    
                    if(self.ocr_counts == 7){
                        
                        let ocr = "Start: " + self.str_start1 + "\n" + "ID: "+self.str_start2 + "\n" + "JOB 1: " + self.str_data1 + "\n" + "JOB 2: " + self.str_data2 + "\n" + "JOB 3: " + self.str_data3 + "\n" + "Expiry: "
                            + self.str_expiry + "\n" + "Data: " + self.str_data4 + "\n"
                        
                        let alert = UIAlertController(title: "Tesseract Success", message: ocr, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }

                }
                
                arabicTesseract.performOCR(on: img_data1) { recognizedString in
                    
                    guard var recognizedString = recognizedString else { return }
                    recognizedString = recognizedString.replacingOccurrences(of: "\n", with: "")
                    print(recognizedString)

                    self.ocr_counts = self.ocr_counts + 1
                    self.str_data1 = recognizedString
                    
                    if(self.ocr_counts == 7){
                        
                        let ocr = "Start: " + self.str_start1 + "\n" + "ID: "+self.str_start2 + "\n" + "JOB 1: " + self.str_data1 + "\n" + "JOB 2: " + self.str_data2 + "\n" + "JOB 3: " + self.str_data3 + "\n" + "Expiry: "
                            + self.str_expiry + "\n" + "Data: " + self.str_data4 + "\n"
                        
                        let alert = UIAlertController(title: "Tesseract Success", message: ocr, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                arabicTesseract.performOCR(on: img_data2) { recognizedString in
                    
                    guard var recognizedString = recognizedString else { return }
                    recognizedString = recognizedString.replacingOccurrences(of: "\n", with: "")
                    print(recognizedString)
                    self.ocr_counts = self.ocr_counts + 1
                    self.str_data2 = recognizedString
                    
                    if(self.ocr_counts == 7){
                        
                        let ocr = "Start: " + self.str_start1 + "\n" + "ID: "+self.str_start2 + "\n" + "JOB 1: " + self.str_data1 + "\n" + "JOB 2: " + self.str_data2 + "\n" + "JOB 3: " + self.str_data3 + "\n" + "Expiry: "
                            + self.str_expiry + "\n" + "Data: " + self.str_data4 + "\n"
                        
                        let alert = UIAlertController(title: "Tesseract Success", message: ocr, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                arabicTesseract.performOCR(on: img_data3) { recognizedString in
                    
                    guard var recognizedString = recognizedString else { return }
                    recognizedString = recognizedString.replacingOccurrences(of: "\n", with: "")
                    print(recognizedString)
                    self.ocr_counts = self.ocr_counts + 1
                    self.str_data3 = recognizedString
                    
                    if(self.ocr_counts == 7){
                        
                        let ocr = "Start: " + self.str_start1 + "\n" + "ID: "+self.str_start2 + "\n" + "JOB 1: " + self.str_data1 + "\n" + "JOB 2: " + self.str_data2 + "\n" + "JOB 3: " + self.str_data3 + "\n" + "Expiry: "
                            + self.str_expiry + "\n" + "Data: " + self.str_data4 + "\n"
                        
                        let alert = UIAlertController(title: "Tesseract Success", message: ocr, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                hinTesseract.performOCR(on: img_expiryDate) { recognizedString in
                    
                    guard var recognizedString = recognizedString else { return }
                    recognizedString = recognizedString.replacingOccurrences(of: "\n", with: "")
                    print(recognizedString)
                    self.ocr_counts = self.ocr_counts + 1
                    self.str_expiry = recognizedString
                    
                    if(self.ocr_counts == 7){
                        
                        let ocr = "Start: " + self.str_start1 + "\n" + "ID: "+self.str_start2 + "\n" + "JOB 1: " + self.str_data1 + "\n" + "JOB 2: " + self.str_data2 + "\n" + "JOB 3: " + self.str_data3 + "\n" + "Expiry: "
                            + self.str_expiry + "\n" + "Data: " + self.str_data4 + "\n"
                        
                        let alert = UIAlertController(title: "Tesseract Success", message: ocr, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                arabicTesseract.performOCR(on: img_data4) { recognizedString in
                    
                    guard var recognizedString = recognizedString else { return }
                    recognizedString = recognizedString.replacingOccurrences(of: "\n", with: "")
                    print(recognizedString)
                    self.ocr_counts = self.ocr_counts + 1
                    self.str_data4 = recognizedString
                    
                    if(self.ocr_counts == 7){
                        
                        let ocr = "Start: " + self.str_start1 + "\n" + "ID: "+self.str_start2 + "\n" + "JOB 1: " + self.str_data1 + "\n" + "JOB 2: " + self.str_data2 + "\n" + "JOB 3: " + self.str_data3 + "\n" + "Expiry: "
                            + self.str_expiry + "\n" + "Data: " + self.str_data4 + "\n"
                        
                        let alert = UIAlertController(title: "Tesseract Success", message: ocr, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }

            
        currentStep = currentStep + 1
        
    }
    
    func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage?
    {
        let imageViewScale = max(inputImage.size.width / viewWidth,
                                 inputImage.size.height / viewHeight)
        
        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x:cropRect.origin.x * imageViewScale,
                              y:cropRect.origin.y * imageViewScale,
                              width:cropRect.size.width * imageViewScale,
                              height:cropRect.size.height * imageViewScale)
        
        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
            else {
                return nil
        }
        
        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
    func saveImage(imageName: String, image: UIImage) {
        
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
            
        }
        
        do {
            try data.write(to: fileURL)
            print(fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
        
    }
    
    
}
extension UIImage {
    func fixed() -> UIImage {
        let ciContext = CIContext(options: nil)
        
        let cgImg = ciContext.createCGImage(ciImage!, from: ciImage!.extent)
        let image = UIImage(cgImage: cgImg!, scale: scale, orientation: .left)
        
        return image
    }
}
