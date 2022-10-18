//
//  ResetPasswordViewController.swift
//  ResetPassword
//
//  Created by Mar Cabrera on 19/09/2022.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Properties
    var token: String?
    var tokenId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        if passwordTextField.text != confirmPasswordTextField.text {
            errorLabel.isHidden = false
            errorLabel.text = "Passwords do not match"
        } else {
            errorLabel.isHidden = true
            resetPassword()
        }
    }
    
    private func resetPassword() {
        let password = confirmPasswordTextField.text ?? ""

        app.emailPasswordAuth.resetPassword(to: password, token: token ?? "", tokenId: tokenId ?? "") { (error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed to reset password: \(error!.localizedDescription)")
                    self.presentErrorAlert(message: "There was an error resetting the password")
                    // Should do something here
                    return
                }
                print("Successfully reset password")
                let alert = UIAlertController(title: "Success!", message: "Your password has been reset", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                self.present(alert, animated: true, completion: nil)
                self.performSegue(withIdentifier: "goToMainVC", sender: nil)
            }
        }
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
