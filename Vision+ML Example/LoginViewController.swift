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

//    @IBOutlet var backgroundGradientView: UIView!
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
        
        // Create a gradient layer.
//            let gradientLayer = CAGradientLayer()
//            // Set the size of the layer to be equal to size of the display.
//            gradientLayer.frame = view.bounds
//            // Set an array of Core Graphics colors (.cgColor) to create the gradient.
//            // This example uses a Color Literal and a UIColor from RGB values.
//            gradientLayer.colors = [#colorLiteral(red: 0, green: 0.5725490196, blue: 0.2705882353, alpha: 1).cgColor, UIColor(red: 252/255, green: 238/255, blue: 33/255, alpha: 1).cgColor]
//            // Rasterize this static layer to improve app performance.
//            gradientLayer.shouldRasterize = true
//            // Apply the gradient to the backgroundGradientView.
//            backgroundGradientView.layer.addSublayer(gradientLayer)
//
//

    
        
        
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



