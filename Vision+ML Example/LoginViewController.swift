//
//  LoginViewController.swift
//  Vision+ML Example
//
//  Created by Ayo  on 4/30/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var roundedCornerButton: UIButton!
    
    @IBAction func onSignIn(_ sender: Any) {
                   let username = usernameTextField.text!
                   let password = passwordTextField.text!
        
                   PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
                       if user != nil{
                           self.performSegue(withIdentifier: "loginSegue", sender: nil)
                       } else{
                            let alert = UIAlertController(title: "ooops!", message: "Incorrect username or password", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alert, animated: true)
                            print("Error: \(error?.localizedDescription)")
                       }
                   }
        
        
    }
    
    @IBAction func onTaps(_ sender: Any) {
           self.view.endEditing(true)
    }
    override func viewDidLoad() {
                roundedCornerButton.layer.cornerRadius = 10
                roundedCornerButton.layer.borderColor = UIColor.white.cgColor
                usernameTextField.layer.cornerRadius = 10
                usernameTextField.layer.borderWidth = 1.0
                passwordTextField.layer.cornerRadius = 10
                passwordTextField.layer.borderWidth = 1.0
                usernameTextField.layer.masksToBounds = true
                passwordTextField.layer.masksToBounds = true
                passwordTextField!.layer.borderColor = UIColor.white.cgColor
                usernameTextField!.layer.borderColor = UIColor.white.cgColor
                usernameTextField.borderStyle = UITextField.BorderStyle.roundedRect
                passwordTextField.borderStyle = UITextField.BorderStyle.roundedRect
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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



