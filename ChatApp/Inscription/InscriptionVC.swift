//
//  InscriptionVC.swift
//  ChatApp
//
//  Created by TRIMECH on 12/03/2018.
//  Copyright © 2018 TRIMECH. All rights reserved.
//

import Foundation
import UIKit

class InscriptionVC: UIViewController ,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
 
{
    var name = "Randa"
    var email = "trimechranda94@gmail.com"
    var password:String = ""
    var sex :String = ""
    var birthDate = "09/05/1995"
    var verificationid :String = ""
    var stringPassed = ""
    let picker = UIImagePickerController()
    var imgData = NSData ()
    var profilepicString :String = ""

    @IBOutlet weak var ConfirmPswdpic: UIImageView!
    @IBOutlet weak var MenButton: UIButton!
    @IBOutlet weak var FemeleButton: UIButton!
    @IBOutlet weak var BirthPic: UIImageView!
    @IBOutlet weak var PasswordPic: UIImageView!
    @IBOutlet weak var EmailPic: UIImageView!
    @IBOutlet weak var NamePic: UIImageView!
    @IBOutlet weak var profilePic: UIButton!
    @IBOutlet weak var Registartionbutton: UIButton!
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ConfirmPswdTextField: UITextField!
    @IBOutlet weak var BirthDateTextField: UITextField!
    @IBOutlet weak var DatePickerView: UIView!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var OkDate: UIButton!



    func customization()  {
        let myColor : UIColor = UIColor( red: 255, green: 255, blue:255, alpha: 1.0 )
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = myColor.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        
        
        Registartionbutton.layer.borderWidth = 1
        Registartionbutton.layer.masksToBounds = false
        Registartionbutton.layer.borderColor = myColor.cgColor
        Registartionbutton.layer.cornerRadius = 15
        Registartionbutton.clipsToBounds = true
        var imagesListArray = [UIImage]()
        
        for imageName in 1...3
        {
            imagesListArray.append(UIImage(named: "Phone.png")!)
            imagesListArray.append(UIImage(named: "Email.png")!)

        }
    
        EmailPic.animationImages = imagesListArray
        EmailPic.animationDuration = 4.0
        EmailPic.startAnimating()
    }
    @IBAction func backBtnSelected(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AuthentificationVC") as! AuthentificationVC
        self.present(nextViewController, animated:true, completion:nil)    }
/// Register with mail or phone number
@IBAction func RegistrationAction(){
    let imageFromButton : UIImage = profilePic.image(for: UIControlState.normal)!

    let bool = isStringAnInt(string: emailTextField.text!)
    if(bool == false){

    if (!NameTextField.text!.isEmpty && isValidEmail(email: emailTextField.text!) == true && doPasswordContainsNumber(password: PasswordTextField.text!) == true && (PasswordTextField.text == ConfirmPswdTextField.text)) {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        

                 Inscription.registerUserwithEmail(withName: NameTextField.text!, email: emailTextField.text!, password: PasswordTextField.text!, sexe: sex, birthDate: BirthDateTextField.text!, profilePic: profilepicString , completion: { [weak weakSelf = self] (status) in
            DispatchQueue.main.async {
                if status == true {
                    print(" success")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "AcceuilVC") as! AcceuilVC
                    self.present(vc, animated: true, completion: nil)
                } else {
                    print(" not success")
                    let alert = UIAlertController(title: "Alert", message: "Un probléme", preferredStyle: UIAlertControllerStyle.alert)
                    self.present(alert, animated: true, completion: nil)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                            
                            
                        }}))
                }
                weakSelf = nil

            }
        })
        dismiss(animated: false, completion: nil)

    }
    else{
        print(" not success")
        let alert = UIAlertController(title: "Alert", message: "Verifier vos cordonnées", preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        
        }
        
    }
    else{
        if (!NameTextField.text!.isEmpty && !emailTextField.text!.isEmpty  && doPasswordContainsNumber(password: PasswordTextField.text!) == true && (PasswordTextField.text == ConfirmPswdTextField.text)) {
        Inscription.registerUserwithPhone( phoneNumber: emailTextField.text!, completion: { [weak weakSelf = self] (verificationID) in
            DispatchQueue.main.async {
                self.verificationid = verificationID
                print(verificationID)
                let loggedInVC:ValidateCodePhoneVC = self.storyboard!.instantiateViewController(withIdentifier: "ValidateCodePhoneVC") as! ValidateCodePhoneVC
                loggedInVC.verificationid = verificationID
                loggedInVC.Name = self.NameTextField.text!
                loggedInVC.password = self.PasswordTextField.text!
                loggedInVC.birthDate = self.BirthDateTextField.text!
                loggedInVC.sexe = self.sex
                loggedInVC.PhoneNumber = self.emailTextField.text!
                 loggedInVC.profilePic = self.profilepicString
                
                self.present(loggedInVC, animated: false, completion: nil)
            }
            
            
 
        })
        
    }
        
        else{
            print(" not success")
            let alert = UIAlertController(title: "Alert", message: "Verifier vos cordonnées", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
        }
        
    }
       
    }
    
    
    // test if parameter is string
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
// test format of mail
func isValidEmail(email:String) -> Bool {
    
    print("validate emilId: \(email)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: email)
    return result
    
}
    //test format of password
func doPasswordContainsNumber( password: String) -> Bool{
    
    let numberRegEx  = ".*[0-9]+.*"
    let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
    let containsNumber = testCase.evaluate(with: password)
    
    return containsNumber
}
 //get a borth date from datePicker
@IBAction func datePickerChanged(_ sender: Any) {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "dd-MMM-yyyy"

    let strDate = dateFormatter.string(from: DatePicker.date)
    BirthDateTextField.text = strDate
}
    //hide a datePichker
 @IBAction func ValidateDate(){
    DatePickerView.isHidden = true
     }
    // choose sexe type(women or man)
@IBAction func SexeAction(sender: UIButton){

    switch sender {
    case MenButton:
        MenButton.setImage( UIImage(named:"Chek"), for: .normal)
        FemeleButton.setImage(UIImage(named: "Women"), for: .normal)

        sex = "Men"
    case FemeleButton:
        sex = "Women"
        FemeleButton.setImage(UIImage(named: "Chek"), for: .normal)
        MenButton.setImage( UIImage(named:"Man"), for: .normal)

    default:
        break
        
    }

   
    }
    
// choose image btn selected
@IBAction func chooseImgBtnSelected(_ sender: Any) {
    
    let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
    let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
    {
        UIAlertAction in
        self.openCamera()
    }
    let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
    {
        UIAlertAction in
        self.openGallary()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
    {
        UIAlertAction in
    }
    
    // Add the actions
  //  picker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
    picker.delegate = self

    alert.addAction(cameraAction)
    alert.addAction(gallaryAction)
    alert.addAction(cancelAction)
    self.present(alert, animated: true, completion: nil)
    
}
    //Access to camera
func openCamera(){
    if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
        picker.sourceType = UIImagePickerControllerSourceType.camera
        self .present(picker, animated: true, completion: nil)
    }else{
        let alert = UIAlertView()
        alert.title = "Warning"
        alert.message = "You don't have camera"
        alert.addButton(withTitle: "OK")
        alert.show()
    }
}
// access to gallery
func openGallary(){
    picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
    
    self.present(picker, animated: true, completion: nil)
}

//MARK:UIImagePickerControllerDelegate

func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

    dismiss(animated: true, completion: nil)
}

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
{
    NSLog("\(info)")

        if let imagedata = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            profilePic.setImage(imagedata, for: .normal)
           //profilepicString = ImageFunctions.convertImageToBase64(image: imagedata)
            
            let encrypted  = ImageFunctions.convertImageToBase64(image: imagedata)
            let password = "azdrezcldkdk123dkdbnchpeqwxdplke"  // returns random 32 char string
             profilepicString = AES256CBC.encryptString(encrypted, password: password)!
            
        }
        
        dismiss(animated: true, completion: nil)
    }
// methods keyboard
@objc func dismissKeyboard() {
    view.endEditing(true)
}
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
}
override func viewDidLoad() {
    super.viewDidLoad()
    
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InscriptionVC.dismissKeyboard))
    view.addGestureRecognizer(tap)
    DatePickerView.isHidden = true

    self.customization()
    NotificationCenter.default.addObserver(self, selector: #selector(InscriptionVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(InscriptionVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    
}

//
override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}

//delegate method

@IBAction func DidBegin(_ sender: Any) {
    BirthDateTextField.resignFirstResponder()

    DatePickerView.isHidden = false

}
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("HELLO")
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 25
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 25
            }
        }
    }
func textFieldDidBeginEditing(textField: UITextField) {
    if textField.tag == 5 {
        DatePickerView.isHidden = false
    }
}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }


}
