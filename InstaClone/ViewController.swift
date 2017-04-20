//
//  ViewController.swift
//  InstaClone
//
//  Created by Adrien Maranville on 4/1/17.
//  Copyright © 2017 Adrien Maranville. All rights reserved.
//

import UIKit
import Parse

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class ViewController: UIViewController {
    
    var signupMode = true
    
    var activityIndicator = UIActivityIndicatorView()
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    @IBOutlet weak var txtBoxEmail: UITextField!
    @IBOutlet weak var txtBoxPassword: UITextField!
    @IBOutlet weak var btnSignupOrLogin: UIButton!
    @IBAction func btnSignupOrLoginPressed(_ sender: Any) {
        if txtBoxEmail.text == "" || txtBoxPassword.text == "" {
            createAlert(title: "Ooops!", message: "Please enter an email or password")
            
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if signupMode {
                //sign user up
                
                let user = PFUser()
                
                user.username = txtBoxEmail.text
                user.email = txtBoxEmail.text
                user.password = txtBoxPassword.text
                
                user.signUpInBackground(block: { (success, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        var displayErrorMessage = "Please try again in a bit"
                        if let errorMessage = error as NSError? {
                            displayErrorMessage = errorMessage.userInfo["error"] as! String
                        }
                        self.createAlert(title: "Signup Error", message: displayErrorMessage)
                    } else {
                        print("User registered")
                        
                        let following = PFObject(className: "Followers")
                        
                        following["follower"] = PFUser.current()?.objectId
                        following["following"] = PFUser.current()?.objectId
                        following.saveInBackground()
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                    
                })
            } else {
                //user log in
                
                PFUser.logInWithUsername(inBackground: txtBoxEmail.text!, password: txtBoxPassword.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        var displayErrorMessage = "Please try again in a bit"
                        if let errorMessage = error as NSError? {
                            displayErrorMessage = errorMessage.userInfo["error"] as! String
                        }
                        self.createAlert(title: "Login Error", message: displayErrorMessage)
                    } else {
                        print("Logged in")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                })
                
            }
        }
        
    }
    @IBOutlet weak var btnChangeSigninMode: UIButton!
    @IBAction func btnChangeSigninModePressed(_ sender: Any) {
        if signupMode {
            //change to log in mode
            
            btnSignupOrLogin.setTitle("Log In", for: [])
            
            btnChangeSigninMode.setTitle("Sign Up", for: [])
            
            lblHaveAccountMessage.text = "Don't have an account?"
            
            signupMode = false
            
        } else {
            //change to sign up mode
            
            btnSignupOrLogin.setTitle("Sign Up", for: [])
            
            btnChangeSigninMode.setTitle("Log In", for: [])
            
            lblHaveAccountMessage.text = "Already have an account?"
            
            signupMode = true
        }
    }
    @IBOutlet weak var lblHaveAccountMessage: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            performSegue(withIdentifier: "showUserTable", sender: self)
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround() 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

