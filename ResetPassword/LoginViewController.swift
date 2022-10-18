//
//  LoginViewController.swift
//  ResetPassword
//
//  Created by Mar Cabrera on 13/09/2022.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        app.emailPasswordAuth.registerUser(email: email, password: password, completion: { (error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    self.presentErrorAlert(message: "Oops! There was an error on sign up")
                    return
                }

                print("Signup Successful!")
                self.signIn(email: email, password: password)
            }
        })
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {

        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        self.signIn(email: email, password: password)
    }
    
    private func signIn(email: String, password: String) {
        app.login(credentials: Credentials.emailPassword(email: email, password: password)) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("Login failed: \(error.localizedDescription)")
                    self.presentErrorAlert(message: "Invalid Credentials")
                    
                case .success(let user):
                    print("Successfully logged in as user \(user)")
                    self.openRealmSync()
                    
                }
            }
        }
    }
    
    private func openRealmSync() {
        let user = app.currentUser!

        // The partition determines which subset of data to access.
        // Defines a default configuration so the realm being opened on other areas of the app is fetching the right partition
        Realm.Configuration.defaultConfiguration = user.configuration(partitionValue: user.id)

        Realm.asyncOpen() { (result) in
            switch result {
            case .failure(let error):
                print("Failed to open realm: \(error.localizedDescription)")
                self.presentErrorAlert(message: "Oops! Unable to open Realm partition")

            case .success(_):
                // TODO: Change Segue
                self.performSegue(withIdentifier: "goToMainVC", sender: nil)
            }
        }
    }
}
