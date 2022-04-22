//
//  SignUpViewController.swift
//  studymate
//
//  Created by Haonan Wang on 4/21/22.
//

import UIKit
import Parse
import AlamofireImage

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var yearSegmented: UISegmentedControl!
    @IBOutlet weak var majorField: UITextField!
    @IBOutlet weak var universityField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFields()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: Any) {
        if fieldsNotEmpty() {
            let user = PFUser()
            user.username = usernameField.text
            user.password = passwordField.text
            user["name"] = nameField.text ?? ""
            user["major"] = majorField.text ?? ""
            user["university"] = universityField.text ?? ""
            user["bio"] = "Edit your biography to help people get to know you!"
            print("point 1")//TODO: test
            let segmentIndex = yearSegmented.selectedSegmentIndex
            UserDefaults.standard.set(segmentIndex, forKey: "segmentIndex")
            user["year"] = yearSegmented.titleForSegment(at: segmentIndex)!
            print("point 2")//TODO: test
            guard let image = profileImage.image?.pngData() else {
                user.signUpInBackground {(success, error) in
                    if success {
                        print("user create success") //TODO: test
                        self.performSegue(withIdentifier: "signUpToHome", sender: nil)
                    } else {
                        print("create failed")//TODO: test
                        self.displaySignupError(error: error!)
                    }
                }
                return
            }
            
            let imageFile = PFFileObject(name: "profileImage.png", data: image)
            user["image"] = imageFile

            user.signUpInBackground {(success, error) in
                if success {
                    print("user create success") //TODO: test
                    self.performSegue(withIdentifier: "signUpToHome", sender: nil)
                } else {
                    print("create failed")//TODO: test
                    self.displaySignupError(error: error!)
                }
            }
        } else {
            self.displayContentError()
        }
    }
    
    // present image picker, set this action
    @IBAction func onSelectImage(_ sender: Any) {
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
    
    // scale and fit image into view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 414, height: 360)
        let scaledImage = image.af.imageAspectScaled(toFill: size)
        profileImage.image = scaledImage
        dismiss(animated: true, completion: nil)
    }
    
    func initializeFields() {
        usernameField.textColor = UIColor.black
        passwordField.textColor = UIColor.black
    }
    
    // check if essential text fields are empty
    func fieldsNotEmpty() -> Bool {
        return usernameField.text != "" && passwordField.text != ""
    }
    
    // display sign up error as alert
    func displaySignupError(error: Error) {
        let title = "Sign up error"
        let message = "Oops! Something went wrong while signing up: \(error.localizedDescription)"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default)
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    
    func displayContentError() {
        let title = "Error"
        let message = "Username and password field cannot be empty"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default)
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
