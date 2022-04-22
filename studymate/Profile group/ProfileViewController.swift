//
//  ProfileViewController.swift
//  studymate
//
//  Created by Haonan Wang on 4/22/22.
//

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var collegeLabel: UILabel!
    @IBOutlet weak var bioText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = PFUser.current()!
        self.nameLabel.text = user.value(forKey: "name") as? String
        self.majorLabel.text = user.value(forKey: "major") as? String
        self.yearLabel.text = user.value(forKey: "year") as? String
        self.collegeLabel.text = user.value(forKey: "university") as? String
        self.bioText.text = user["bio"] as? String
        let imageFile = user["image"] as? PFFileObject
        imageFile!.getDataInBackground {(imageData: Data?, error: Error?) in
            if let error = error {
                print("show profile image failed in PFUser: \(error.localizedDescription)")
            }
            else if let imageData = imageData {
                let image = UIImage(data: imageData)
                self.profileImage.image = image
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidLoad()
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LogInViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        delegate.window?.rootViewController = loginViewController
    }
    
    /*
    func showProfile() {
        let query = PFQuery(className: "User")
        query.getObjectInBackground(withId: UserDefaults.standard.string(forKey: "profileId")!) {
            (profile, error) in
            if error == nil {
                self.nameLabel.text = profile!["name"] as? String
                self.yearLabel.text = profile!["year"] as? String
                self.majorLabel.text = profile!["major"] as? String
                self.bioText.text = profile!["biography"] as? String
                
                let imageFile = profile!["image"] as? PFFileObject
                imageFile!.getDataInBackground {(imageData: Data?, error: Error?) in
                    if let error = error {
                        print("show profile image failed in PFQuery: \(error.localizedDescription)")
                    }
                    else if let imageData = imageData {
                        let image = UIImage(data: imageData)
                        self.profileImage.image = image
                    }
                }
            } else {
                self.nameLabel.text = "No name"
                self.majorLabel.text = "No major"
                self.yearLabel.text = "No year"
                self.bioText.text = "No biography"
            }
        }
    }
    
     */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
