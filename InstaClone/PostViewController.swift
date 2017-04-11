//
//  PostViewController.swift
//  InstaClone
//
//  Created by Adrien Maranville on 4/11/17.
//  Copyright © 2017 Adrien Maranville. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var activityIndicator = UIActivityIndicatorView()
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBOutlet weak var imgUserSelected: UIImageView!
    
    @IBOutlet weak var txtBoxImgTitle: UITextField!
    
    @IBAction func btnChooseImg(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgUserSelected.image = image
            imgUserSelected.alpha = 1
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnPostImg(_ sender: Any) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        
        let post = PFObject(className: "Posts")
        
        post["message"] = txtBoxImgTitle.text
        
        post["user_id"] = PFUser.current()?.objectId!
        
        let imageData = UIImageJPEGRepresentation(imgUserSelected.image!, 1)
        
        let imageFile = PFFile(name: "image.jpg", data: imageData!)
        
        post["imageFile"] = imageFile
        
        post.saveInBackground { (success, error) in
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if error != nil {
                self.createAlert(title: "Could not post image", message: "Please try again later")
            } else {
                self.createAlert(title: "Image Posted!", message: "Your image has been posted")
                
                self.txtBoxImgTitle.text = ""
                
                self.imgUserSelected.image = UIImage(named: "Self-Portrait_by_Huijgh_Pietersz._Voskuijl_Mauritshuis_955.jpg")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
