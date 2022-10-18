//
//  MainViewController.swift
//  ResetPassword
//
//  Created by Mar Cabrera on 19/09/2022.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
        let email = app.currentUser?.profile.email ?? ""
        let client = app.emailPasswordAuth

        client.sendResetPasswordEmail(email) { (error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Reset password email not sent: \(error!.localizedDescription)")
                    return
                }

                print("Password reset email sent to the following address: \(email)")
                
                // Present a success alert
                let alert = UIAlertController(title: "Reset Password", message: "Please check your inbox to continue the process", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                self.present(alert, animated: true, completion: nil)
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
