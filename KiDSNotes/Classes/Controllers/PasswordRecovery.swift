//
//  PasswordRecovery.swift
//  KiDSNotes
//
//  Created by deus4 on 06/10/16.
//  Copyright © 2016 deus4. All rights reserved.
//

import UIKit

class PasswordRecovery: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var designedButtons: [UIButton]!{
        didSet{
            for button in designedButtons{
                button.layer.cornerRadius = 20
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
    
    func validateEmail(candidate: String) -> Bool{
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
            "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: candidate)
    }
    
    @IBAction func sendPasswordButtonAction(_ sender: UIButton) {
        let candidate = emailTextField.text ?? " "
        if validateEmail(candidate: candidate){
            emailCheck(candidate: candidate)
        }
    }
    func emailCheck(candidate: String) {
        let query = PFQuery(className: "_User")
        query.whereKey("email", equalTo: candidate)
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) in
            if error == nil {
                if (objects!.count > 0){
                    print("Found something")
                    self.sendEmail(email: candidate, account: objects![0] as! PFUser)
                } else {
                    print("Wrong email")
                }
            } else {
                print("\(error)")
            }
        }
        
    }
    func passwordGeneration() -> String {
        let lenght = 8
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: lenght)
        for _ in 0 ..< lenght {
            let charPool = UInt32(letters.length)
            let rand = arc4random_uniform(charPool)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        return randomString as String
    }
    
    func sendEmail(email: String, account: PFUser) {
        
        self.view.isUserInteractionEnabled = false
        self.view.alpha = 0.3
        
        do{
            try PFUser.requestPasswordReset(forEmail: email)
            let alert = UIAlertController(title: "Success", message: "Message sent", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel){ UIAlertAction in }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }catch {
            print("Something wrong")
        }
        self.view.isUserInteractionEnabled = true
        self.view.alpha = 1.0
    }
    
    
    
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    


}
