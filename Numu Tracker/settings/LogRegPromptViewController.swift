//
//  LogRegPromptViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 9/4/17.
//  Copyright © 2017 Numu Tracker. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics


class LogRegPromptViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var topScrollView: UIScrollView!
    @IBOutlet weak var middleScrollView: UIScrollView!
    @IBOutlet weak var bottomScrollView: UIScrollView!

    var topScrollDrection: Int = 0
    var bottomScrollDrection: Int = 0
    var middleScrollDrection: Int = 0

    @IBAction func closeScreen(_ sender: Any) {
        NotificationCenter.default.post(name: .ClosedLogRegPrompt, object: self)
        Answers.logCustomEvent(withName: "Dismissed LogRegPrompt", customAttributes: nil)
        self.dismiss(animated: true, completion: nil)
    }
    var arts: [String] = []

    @IBOutlet weak var signUpFormView: UIView!
    @IBOutlet weak var signUpEmailTextField: NumuTextField!
    @IBOutlet weak var signUpPasswordTextField: NumuTextField!
    @IBOutlet weak var signUpLabel: UILabel!

    @IBOutlet weak var logInFormView: UIView!
    @IBOutlet weak var logInEmailTextField: NumuTextField!
    @IBOutlet weak var logInPasswordTextField: NumuTextField!
    @IBOutlet weak var logInLabel: UILabel!

    @IBOutlet weak var numuIntroLabel: UILabel!

    @IBAction func logInButtonPree(_ sender: Any) {

        var animationDuration = 0.5

        // if sign up form is showing, hide it
        if signUpFormView.alpha == 1 {
            self.signUpFormView.alpha = 0
            animationDuration = 0
        }

        if logInFormView.alpha == 0 {
            UIView.animate(withDuration: animationDuration) {
                self.logInFormView.alpha = 1
                self.logInEmailTextField.becomeFirstResponder()
            }
        } else {
            UIView.animate(withDuration: animationDuration) {
                self.logInFormView.alpha = 0
            }
            self.view.endEditing(true)
        }
    }

    @IBAction func signUpButtonPress(_ sender: Any) {
         var animationDuration = 0.5

        // if log in form is showing, hide it
        if logInFormView.alpha == 1 {
            self.logInFormView.alpha = 0
            animationDuration = 0
        }

        if signUpFormView.alpha == 0 {
            UIView.animate(withDuration: animationDuration) {
                self.signUpFormView.alpha = 1
                self.signUpEmailTextField.becomeFirstResponder()
            }
        } else {
            UIView.animate(withDuration: animationDuration) {
                self.signUpFormView.alpha = 0
            }
            self.view.endEditing(true)
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.signUpPasswordTextField.delegate = self
        self.signUpEmailTextField.delegate = self

        self.logInEmailTextField.delegate = self
        self.logInPasswordTextField.delegate = self

        signUpFormView.alpha = 0
        logInFormView.alpha = 0

        let width = self.view.frame.size.width
        var height: CGFloat = 0
        var max_length: CGFloat = 0
        height = width / 2
        max_length = height * 6

        self.topScrollView.isScrollEnabled = true
        self.topScrollView.alwaysBounceHorizontal = true
        self.topScrollView.contentSize.width = max_length

        self.middleScrollView.isScrollEnabled = true
        self.middleScrollView.alwaysBounceHorizontal = true
        self.middleScrollView.contentSize.width = max_length

        self.bottomScrollView.isScrollEnabled = true
        self.bottomScrollView.alwaysBounceHorizontal = true
        self.bottomScrollView.contentSize.width = max_length

        // Load list of recent releases
        NumuClient.shared.getArt() {[weak self](arts) in
            self?.arts = arts
            DispatchQueue.main.async(execute: {
                let top_artists = Array(self!.arts[0..<15])
                let bot_artists = Array(self!.arts[15..<30])
                self?.loadArts(scrollView: (self?.topScrollView)!, images: top_artists)
                self?.loadArts(scrollView: (self?.bottomScrollView)!, images: bot_artists)
                let width = self?.view.frame.size.width
                var height: CGFloat = 0
                var max_length: CGFloat = 0
                height = width! / 3
                max_length = height * 15
                self?.bottomScrollView.setContentOffset(CGPoint(x:max_length-width!,y:0), animated: false)
                _ = Timer.scheduledTimer(timeInterval: 0.025, target: self!, selector: #selector(self?.autoScroll), userInfo: nil, repeats: true)
            })
        }

        Answers.logCustomEvent(withName: "Login / Signup Screen", customAttributes: nil)

    }

    override func viewWillAppear(_ animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func loadArts(scrollView: UIScrollView, images: [String]) {
        // get width of screen
        let width = self.view.frame.size.width
        var height: CGFloat = 0
        if scrollView.restorationIdentifier == "middle" {
            height = width / 2
        } else {
            height = width / 4
        }

        let imageWidth:CGFloat = height
        let imageHeight:CGFloat = height
        var xPosition:CGFloat = 0

        for image in images {
            let image_url = NSURL(string: image)
            if let image = image_url?.cachedImage {

                // Cached: set immediately.
                let artImage = UIImageView()
                artImage.image = image

                artImage.frame.size.width = imageWidth
                artImage.frame.size.height = imageHeight
                artImage.frame.origin.x = xPosition
                artImage.frame.origin.y = 0

                scrollView.addSubview(artImage)
                xPosition += imageWidth
                //self.topScrollViewSize += imageWidth

            } else {
                // Not cached, so load then fade it in.
                //cell.artImageView.alpha = 0
                image_url?.fetchImage { image in
                    // Check the cell hasn't recycled while loading.

                    let artImage = UIImageView()
                    artImage.image = image

                    artImage.frame.size.width = imageWidth
                    artImage.frame.size.height = imageHeight
                    artImage.frame.origin.x = xPosition
                    artImage.frame.origin.y = 0
                    scrollView.addSubview(artImage)
                    xPosition += imageWidth
                    //self.topScrollViewSize += imageWidth


                }
            }

        }

    }

    @objc func autoScroll() {

        let scrollViewArray: [UIScrollView] = [self.topScrollView,self.middleScrollView,self.bottomScrollView]

        for scrollView in scrollViewArray {
            let width = self.view.frame.size.width
            var height: CGFloat = 0
            var max_length: CGFloat = 0
            let offset = scrollView.contentOffset
            var newOffset: CGFloat = 0

            let intervalPixels: CGFloat = 0.50

            // Determine length:
            if scrollView.restorationIdentifier == "middle" {
                height = width / 2
                max_length = height * 6
            } else {
                height = width / 4
                max_length = height * 12
            }

            let max_offset = max_length - width

            //print("Data: Max \(max_offset) and \(offset.x)")

            if offset.x >= max_offset {
                switch scrollView.restorationIdentifier! {
                    case "middle":
                        self.middleScrollDrection = 1
                    case "top":
                        self.topScrollDrection = 1
                    case "bottom":
                        self.bottomScrollDrection = 1
                    default:
                        print("Borked")
                }
            }

           if offset.x <= 0 {
                switch scrollView.restorationIdentifier! {
                    case "middle":
                        self.middleScrollDrection = 0
                    case "top":
                        self.topScrollDrection = 0
                    case "bottom":
                        self.bottomScrollDrection = 0
                    default:
                        print("Borked")
                }
            }

            switch scrollView.restorationIdentifier! {
            case "middle":
                if self.middleScrollDrection == 0 {
                    newOffset = offset.x + intervalPixels
                } else {
                    newOffset = offset.x - intervalPixels
                }
            case "top":
                if self.topScrollDrection == 0 {
                    newOffset = offset.x + intervalPixels
                } else {
                    newOffset = offset.x - intervalPixels
                }
            case "bottom":
                if self.bottomScrollDrection == 0 {
                    newOffset = offset.x + intervalPixels
                } else {
                    newOffset = offset.x - intervalPixels
                }
            default:
                print("Borked")
            }

            //print ("Max Offset:",max_offset)
            //print ("New Offset:",newOffset)


            scrollView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: false)
        }


    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            //print("Next Pressed")
            if textField.restorationIdentifier == "signEmail" {
                signUpPasswordTextField.becomeFirstResponder()
            } else {
                logInPasswordTextField.becomeFirstResponder()
            }
            return true
        }

        if textField.returnKeyType == .go {
            if textField.restorationIdentifier == "signPassword" {
                //print("Sign Go Pressed")
                return self.goSignUp()
            } else {
                //print("Log Go Pressed")
                return self.goLogIn()
                //self.dismiss(animated: true, completion: nil)
            }
        }

        return false
    }

    func goLogIn() -> Bool {

        self.logInLabel.text = "Logging in..."

        let username = self.logInEmailTextField.text
        let password = self.logInPasswordTextField.text

        // Check Credentials
        NumuClient.shared.authorizeLogIn(username: username!, password: password!) { (result) in
            DispatchQueue.main.async(execute: {
                if result == "1" {
                    // Login Success
                    self.logInLabel.text = "Logged in!"
                    defaults.logged = true
                    // Update interface elsewhere
                    NotificationCenter.default.post(name: .LoggedIn, object: self)
                    NotificationCenter.default.post(name: .UpdatedArtists, object: self)
                    // Close keyboard
                    self.logInPasswordTextField.resignFirstResponder()
                    // Log to Answers
                    Answers.logLogin(withMethod: "LogRegPrompt",success: true,customAttributes: nil)
                    // Pop viewcontroller
                    self.dismiss(animated: true, completion: nil)
                } else {
                    // Login Failure
                    self.logInLabel.text = result
                    // Log to Answers
                    Answers.logLogin(withMethod: "LogRegPrompt",success: false,customAttributes: nil)
                }
            })
        }
        return true

    }

    func goSignUp() -> Bool {

        self.signUpLabel.text = "Signing up...\nPlease wait..."
        let username = self.signUpEmailTextField.text
        let password = self.signUpPasswordTextField.text
        //print("Username",username!)
        //print("Password",password!)

        let emailVerify = isValidEmail(testStr: username!)
        var errorText: String = ""
        var errorInt: Bool = false
        if password == "" {
            errorText = "Please enter a password."
            errorInt = true
        } else if password!.count < 8 {
            errorText = "Password needs to be at least 8 characters."
            errorInt = true
        } else if !emailVerify {
            errorText = "Please enter a valid email."
            errorInt = true
        }

        if !errorInt {
            // Check Credentials
            NumuClient.shared.authorizeRegister(username: username!, password: password!) { (result) in
                DispatchQueue.main.async(execute: {
                    if result == "1" {
                        // Registration Success
                        self.signUpLabel.text = "Registration Successful!"
                        defaults.logged = true
                        // TODO: Remove: Store credentials in user defaults.
                        defaults.username = username
                        defaults.password = password
                        // Update interface elsewhere
                        NotificationCenter.default.post(name: .LoggedIn, object: self)
                        NotificationCenter.default.post(name: .UpdatedArtists, object: self)
                        // Close keyboard
                        self.logInPasswordTextField.resignFirstResponder()
                        // Log to Answers
                        Answers.logSignUp(withMethod: "LogRegPrompt", success: true, customAttributes: nil)
                        // Pop viewcontroller
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        // Registration Failure
                        self.signUpLabel.text = result
                        // Log to Answers
                        Answers.logSignUp(withMethod: "LogRegPrompt", success: false, customAttributes: nil)
                    }
                })
            }
            return true
        } else {
            self.signUpLabel.text = errorText
            return false
        }
    }

    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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
