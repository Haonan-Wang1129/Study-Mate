//
//  logInViewController.swift
//  studymate
//
//  Created by Haonan Wang on 4/21/22.
//

import UIKit
import Parse

class logInViewController: UIViewController {
    
    // reference to view elements
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // do signup action
    //@IBAction func onSignUp(_ sender: Any) {
        //self.performSegue(withIdentifier: "signUpSegue", sender: nil)
    //}
    
    // do login action
    @IBAction func onLogIn(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground:username, password:password) {
          (user: PFUser?, error: Error?) -> Void in
            if let error = error {
                print("User login failed: \(error.localizedDescription)")
                self.displayLogInError(error: error)
            } else {
                print("User \(username) logged in successfull!")
                NotificationCenter.default.post(name: NSNotification.Name("login"), object: nil)
            }
        }
    }
    
    // display login errors as alert
    func displayLogInError(error: Error) {
        let title = "Login Error"
        let message = "Oops! Something went wrong while logging in: \(error.localizedDescription)"
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
