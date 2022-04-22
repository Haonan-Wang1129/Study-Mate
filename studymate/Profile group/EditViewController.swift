//
//  EditViewController.swift
//  studymate
//
//  Created by Haonan Wang on 4/22/22.
//

import UIKit
import Parse
import AlamofireImage

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var classSegmented: UISegmentedControl!
    @IBOutlet weak var universityField: UITextField!
    @IBOutlet weak var majorField: UITextField!
    @IBOutlet weak var bioView: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    
    let user = PFUser.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFields()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onEditCollege(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "searchCollege") as? SearchViewController {
            vc.callBack = { (collegeName: String) in
                self.universityField.text = collegeName
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: Any) {
        user!["name"] = nameField.text!
        user!["major"] = majorField.text!
        user!["university"] = universityField.text!
        user!["bio"] = bioView.text!
        
        let segmentIndex = classSegmented.selectedSegmentIndex
        UserDefaults.standard.set(segmentIndex, forKey: "segmentIndex")
        user!["year"] = classSegmented.titleForSegment(at: segmentIndex)!
        
        guard let image = profileImage.image?.pngData() else { return }
        let imageFile = PFFileObject(name: "profileImage.png", data: image)
        user!["image"] = imageFile
        user!.saveInBackground()
        
        self.dismiss(animated: false)
    }
    
    @IBAction func onImageSelect(_ sender: Any) {
        // select image and show in imageView
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 414, height: 360)
        let scaledImage = image.af.imageAspectScaled(toFill: size)
        
        profileImage.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func initializeFields() {
        bioView.layer.borderColor = UIColor.lightGray.cgColor
        bioView.layer.borderWidth = 0.5
        bioView.layer.cornerRadius = 5.0
        nameField.textColor = UIColor.black
        majorField.textColor = UIColor.black
        bioView.textColor = UIColor.black
        
        let years = ["2022": 0, "2023": 1, "2024": 2, "2025": 3, "2026": 4]
        
        nameField.text = user!["name"] as? String
        majorField.text = user!["major"] as? String
        universityField.text = user!["university"] as? String
        bioView.text = user!["bio"] as? String
        let useryear = user!["year"] as! String
        classSegmented.selectedSegmentIndex = years[useryear] ?? 4
        
        
        let userImageFile = user!["image"] as! PFFileObject
        userImageFile.getDataInBackground { (imageData: Data?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let imageData = imageData {
                let image = UIImage(data: imageData)
                let size = CGSize(width: 414, height: 360)
                let scaledImage = image?.af.imageAspectScaled(toFill: size)
                self.profileImage.image = scaledImage
            }
        }
        print("initialized")//TODO: test
    }
}

