import UIKit
import SwiftSpinner

class LoginViewController: UIViewController {
    
    var loggedUser: FIRUser? {
        didSet {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
            }
        }
    }
    
    // MARK: Constants
    let loginToList = "LoginToList"
    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    // MARK: Actions
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        SwiftSpinner.show("Connecting...")
        FIRAuth.auth()!.signIn(withEmail: textFieldLoginEmail.text!, password: textFieldLoginPassword.text!) { (user, error) in
            if error == nil {
                print("Logged in as ", user ?? "No user")
                SwiftSpinner.hide()
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
            }
        }
    }
    
    @IBAction func signUpDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let emailField = alert.textFields![0]
                                        let passwordField = alert.textFields![1]
                                        
                                        FIRAuth.auth()!.createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
                                            if error == nil {
                                                FIRAuth.auth()!.signIn(withEmail: self.textFieldLoginEmail.text!, password: self.textFieldLoginPassword.text!, completion: { (user, error) in
                                                    if error == nil {
                                                        print("Signed in with user: ", user!)
                                                    } else {
                                                        print(error as Any)
                                                    }
                                                })
                                            } else {
                                                print(error as Any)
                                            }
                                        })
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()!.addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.loggedUser = user
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldLoginEmail {
            textFieldLoginPassword.becomeFirstResponder()
        }
        if textField == textFieldLoginPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
