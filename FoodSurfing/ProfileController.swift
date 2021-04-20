//
//  ProfileController.swift
//  Foodsurfing
//
//  Created by developer on 19/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher

class ProfileController: CustBaseController, ServiceDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var lblLastname: UILabel!
    @IBOutlet weak var lblFirstname: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtFirstname: UITextField!
    @IBOutlet weak var txtLastname: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordAgain: FoodSurfingTextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtPoBox: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtRegion: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var btnMehr: UIButton!
    @IBOutlet weak var btnMehrHeightConst: NSLayoutConstraint!
    @IBOutlet weak var btnLess: UIButton!
    
    let imagePicker = UIImagePickerController()
    var isMoreShown: Bool = false
    
    override func viewDidLoad() {
        super.selectedScreen = .profile
        if (Helper.getValue(forKey: Constants.userRole) ?? "") == "rest" {
            super.isRest = true
        }
        super.viewDidLoad()
        imagePicker.delegate = self
        imgUser.asCircle()
        
        //Remove/showing more button
        if super.isRest {
            btnMehrHeightConst.constant = CGFloat(0)
            btnMehr.isHidden = true
            btnLess.isHidden = true
            txtEmail.isEnabled = false
            txtFirstname.isEnabled = false
            txtLastname.isEnabled = false
            
            lblFirstname.text = "Name des Betriebs"
            lblLastname.text = "Ansprechpartner/in"
        }
        
        //Calling service to get data
        Helper.addLoading(view: (self.navigationController?.view)!, isRemovable: false)
        let params: Parameters = [
            "user_id" : Helper.getValue(forKey: Constants.userIdKey) ?? ""
        ]
        Services.profileService(obj: ProfileResp.self, delegate: self, params: params)
    }
    
    @IBAction func btnChangeProfileAction(_ sender: Any) {
        if !super.isRest {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func btnMehrAction(_ sender: Any) {
        btnMehr.isHidden = true
        btnLess.isHidden = false
        stackViewHeightConst.constant = CGFloat(425)
        for v in stackView.subviews {
            v.isHidden = false
        }
    }
    
    @IBAction func btnLessAction(_ sender: Any) {
        btnLess.isHidden = true
        btnMehr.isHidden = false
        stackViewHeightConst.constant = CGFloat(0)
        for v in stackView.subviews {
            v.isHidden = true
        }
    }
    
    @IBAction func btnUpdateAction(_ sender: Any) {
        var params: Parameters = [
            "user_id" : Helper.getValue(forKey: Constants.userIdKey) ?? ""
        ]
        
        if !super.isRest {
            params["street_name"] = txtStreet.text ?? ""
            params["postal"] = txtPoBox.text ?? ""
            params["city"] = txtCity.text ?? ""
            params["region"] = txtRegion.text ?? ""
            params["country"] = txtCountry.text ?? ""
            params["firstname"] = txtFirstname.text ?? ""
            params["lastname"] = txtLastname.text ?? ""
            params["email"] = txtEmail.text ?? ""
        }
        
        //if password is provided
        if !(txtPassword.text ?? "").isEmpty {
            guard let confirmPassword = txtPasswordAgain.text else {
                Helper.showToast(message: "Please provide matching confirm password")
                return
            }
            
            if txtPassword.text! != confirmPassword {
                Helper.showToast(message: "Please provide matching confirm password")
                return
            }
            
            params["password"] = txtPassword.text!
            params["confirm_password"] = confirmPassword
        }
        
        Helper.addLoading(view: (self.navigationController?.view)!, isRemovable: false)
        Services.updateProfileService(obj: GenericResp.self, delegate: self, params: params)
    }
 
    func uploadImageAndData(image: UIImage){
        var parameters: Parameters = [
            "user_id"   : Helper.getValue(forKey: Constants.userIdKey) ?? "",
            "source"    : "iphone",
            "file"      : "profilePic.jpg"
        ]
        
        let URL = "http://foodsurfing.eu/api/user/profilePicture"
        
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            if  let imageData = UIImageJPEGRepresentation(image, 0.3) {
                multipartFormData.append(imageData, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
            }
            for (key, value) in parameters {
                multipartFormData.append( (value as! String).data(using: String.Encoding.utf8)! , withName: key)
            }
        },
                         to: URL,
                         encodingCompletion: {
            encodingResult in
            
            switch encodingResult {
            case .success(let upload, _, _):
            print("s")
            upload.responseJSON { response in
            }
            
            case .failure(let encodingError):
            print(encodingError)
            }
            })
    }
    
    //MARK: Delegates
    func onSuccess(data: Any, serviceID: Service) {
        Helper.dismissLoadingView(view: (self.navigationController?.view)!)
        if serviceID == .profile {
            let profResp = data as! ProfileResp
            if (profResp.error ?? "") == "OK" {
                txtFirstname.text = profResp.user?.firstname ?? ""
                txtLastname.text = profResp.user?.lastname ?? ""
                txtEmail.text = profResp.user?.email ?? ""
                txtStreet.text = profResp.user?.street_name
                txtPoBox.text = profResp.user?.postal
                txtCity.text = profResp.user?.city
                txtRegion.text = profResp.user?.region
                txtCountry.text = profResp.user?.country
                let url = URL(string: profResp.user?.user_image ?? "")
                imgUser.kf.setImage(with: url)
            }
        }
        else if serviceID == .updateProfile {
            let resp = data as! GenericResp
            if (resp.error ?? "") == "OK" {
                Helper.showToast(message: "Aktualisierung erfolgreich")
            }
        }
    }
    
    func onFailure(serviceID: Service) {
        Helper.dismissLoadingView(view: (self.navigationController?.view)!)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgUser.image = pickedImage
            self.uploadImageAndData(image: pickedImage.normalizedImage())
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension UIImageView{
    func asCircle(){
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.masksToBounds = true
    }
}

extension UIImage {
    func normalizedImage() -> UIImage {
        
        if (self.imageOrientation == UIImageOrientation.up) {
            return self;
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
    }
}
