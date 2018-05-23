//
//  ProfileViewController.swift
//  PR3
//
//  Copyright © 2018 UOC. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var currentProfile: Profile?
    var storage: Storage!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var streetAddressField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var occupationField: UITextField!
    @IBOutlet weak var companyField: UITextField!
    @IBOutlet weak var incomeField: UITextField!
    
    let IMAGE_KEY = "profile_image"
    
    override func viewDidLoad() {
        storage = Storage()
        
        profileImage.image = loadProfileImage()
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        currentProfile = loadProfileData()
    
    // BEGIN-UOC-4
        
        // We initialize fields with loaded data
        
        nameField.text = currentProfile?.name
        surnameField.text = currentProfile?.surname
        streetAddressField.text = currentProfile?.streetAddress
        cityField.text = currentProfile?.city
        occupationField.text = currentProfile?.occupation
        companyField.text = currentProfile?.company
        
        if let income = currentProfile?.income {
            
            incomeField.text = String(income)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            
        case nameField:
            surnameField.becomeFirstResponder()
            
        case surnameField:
            streetAddressField.becomeFirstResponder()
            
        case streetAddressField:
            cityField.becomeFirstResponder()
            
        case cityField:
            occupationField.becomeFirstResponder()
            
        case occupationField:
            companyField.becomeFirstResponder()
            
        case companyField:
            incomeField.becomeFirstResponder()
            
        default:
            incomeField.resignFirstResponder()
            return true
        }
        
        return false
    }
    // END-UOC-4
    
    
    // BEGIN-UOC-5
    @IBAction func updateProfilePhoto(sender: AnyObject) {

        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera;
           
        } else  if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary;
        }
        
        imagePicker.delegate = self
//        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            profileImage.image = image
            dismiss(animated: true, completion: { () -> Void in
                 self.saveProfileImage(image)
            })
            
        }
    // END-UOC-5
    
    // BEGIN-UOC-6
    func loadProfileImage() -> UIImage? {
//        guard let loadedImage = storage?.image(forKey: IMAGE_KEY) else {
//            return UIImage(named: "EmptyProfile.png")
//        }
        let loadedImage = storage?.image(forKey: IMAGE_KEY)
        
        return loadedImage;
    }
    
    func saveProfileImage(_ image: UIImage) {
        
        storage?.setImage(image, forKey: IMAGE_KEY)
    }
    
    // END-UOC-6
    
    // BEGIN-UOC-7
    func saveProfileData(_ currentProfile: Profile) {
        
    }
    
    func loadProfileData() -> Profile {
        let profile = Profile(name: "Sherlock", surname: "Holmes", streetAddress: "221B Baker Street", city: "London", occupation: "Detective", company: "Self-employed", income: 500)
        return profile
    }
    // END-UOC-7
}
