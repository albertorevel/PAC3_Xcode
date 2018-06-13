//
//  ProfileViewController.swift
//  PR3
//
//  Copyright © 2018 UOC. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var currentProfile: Profile?
    
    var imageStorage: ImageStorage!
    var dataStorage: DataStorage!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var streetAddressField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var occupationField: UITextField!
    @IBOutlet weak var companyField: UITextField!
    @IBOutlet weak var incomeField: UITextField!
    
    let IMAGE_KEY = "profile_image"
    let PROFILE_KEY = "profile_data"
    
    
    override func viewDidLoad() {
        
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        imageStorage = appDelegate.imageStorage
        dataStorage = appDelegate.dataStorage
        
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
        
        // Keyboard dismission on screen tapped
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //It manages automatic field change on return pressed
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
    
    // Code that lets open camera or photoLibrary
    @IBAction func updateProfilePhoto(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera;
            
        } else  if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary;
        }
        
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // It manages new image in order to store it
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImage.image = image
        
        dismiss(animated: true, completion: { () -> Void in
            self.saveProfileImage(image)
        })
        
    }
    // END-UOC-5
    
    // BEGIN-UOC-6
    
    // It loads the Profile image. If it doesn't exist, it returns a default image
    func loadProfileImage() -> UIImage? {
        
        guard let loadedImage = imageStorage.image(forKey: IMAGE_KEY) else {
            return UIImage(named: "EmptyProfile.png")
        }
        
        return loadedImage;
    }
    
    // It stores a profile image
    func saveProfileImage(_ image: UIImage) {
        
        imageStorage.saveImage(image, forKey: IMAGE_KEY)
    }
    
    // END-UOC-6
    
    // BEGIN-UOC-7
    
    // It gets field's texts and stores profile data
    @IBAction func saveProfileButtonTapped(_ sender: UIButton) {
        
        currentProfile?.name = nameField.text ?? ""
        currentProfile?.surname = surnameField.text ?? ""
        currentProfile?.streetAddress = streetAddressField.text ?? ""
        currentProfile?.city = cityField.text ?? ""
        currentProfile?.occupation = occupationField.text ?? ""
        currentProfile?.company = companyField.text ?? ""
        companyField.text = currentProfile?.company ?? ""
        
        let incomeText:String = incomeField.text ?? "0"
        if let income:Int = Int(incomeText){
            
            currentProfile?.income = income
        }
        
        saveProfileData(currentProfile ?? Profile())
    }
    
    // It stores a Profile object
    func saveProfileData(_ currentProfile: Profile) {
        dataStorage.saveProfile(profile: currentProfile, key: PROFILE_KEY)
    }
    
    
    // It loads a Profile object, if exists. It create an empty one otherwise
    func loadProfileData() -> Profile {
        
        guard let profile = dataStorage.getProfile(key: PROFILE_KEY) else {
            return Profile()
            
        }
    
        return profile
    }
    // END-UOC-7
}
