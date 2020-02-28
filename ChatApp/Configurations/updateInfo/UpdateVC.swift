//
//  UpdateVC.swift
//  ChatApp
//
//  Created by TRIMECH on 21/03/2018.
//  Copyright © 2018 TRIMECH. All rights reserved.
//

import UIKit
import Firebase
class UpdateVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var MenButton: UIButton!
    @IBOutlet weak var FemeleButton: UIButton!
   
    @IBOutlet weak var profilePic: UIButton!
    @IBOutlet weak var Modificationbutton: UIButton!
    @IBOutlet weak var NameTextField: UITextField!
   
    @IBOutlet weak var BirthDateTextField: UITextField!
    @IBOutlet weak var DatePickerView: UIView!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var OkDate: UIButton!
    let picker = UIImagePickerController()
    var email :String = ""
    var sexe :String = ""
    var picProfil :String = ""
    var  numCompte : Int = 0
     var   profilepicString :String = ""
    func getUserInformations()  {
        let myColor : UIColor = UIColor( red: 255, green: 255, blue:255, alpha: 1.0 )
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = myColor.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        if let id = Auth.auth().currentUser?.uid {
            
            User.GetInfoUser(forUserID: id, completion: {[weak weakSelf = self] (user) in
                DispatchQueue.main.async {
                    weakSelf?.NameTextField.text = user.name
                    weakSelf?.BirthDateTextField.text = user.birthDate
                   // weakSelf?.email = user.email
                    weakSelf?.sexe = user.sexe
                    weakSelf?.picProfil = user.profilpicString
                    weakSelf?.numCompte = user.numCompte

                   
                    weakSelf?.profilePic.setImage(( ImageFunctions.convertBase64ToImage(base64String: self.picProfil)), for: .normal)
                    if(self.sexe == "Women"){
                        self.FemeleButton.setImage(UIImage(named: "Chek"), for: .normal)
                        self.MenButton.setImage( UIImage(named:"Man"), for: .normal)
                    }
                    else if (self.sexe == "Men"){
                        self.MenButton.setImage( UIImage(named:"Chek"), for: .normal)
                        self.FemeleButton.setImage(UIImage(named: "Women"), for: .normal)
                    }

                    weakSelf = nil
                }
            })
        }}
    
    @IBAction func ResetPasswordAction(){
        
        Authentification.ResetPassword(withEmail: email) { [weak weakSelf = self](status) in
            DispatchQueue.main.async {
                
                if status == true {
                    let alert = UIAlertController(title: nil, message: "Consulter email", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    let when = DispatchTime.now() + 4
                    DispatchQueue.main.asyncAfter(deadline: when){
                        alert.dismiss(animated: true, completion: nil)
                    }
                    
                }
                else{
                    print("error")
                } }
        }}
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
            
            self.sexe = "Men"
        case FemeleButton:
            FemeleButton.setImage(UIImage(named: "Chek"), for: .normal)
            MenButton.setImage( UIImage(named:"Man"), for: .normal)
            self.sexe = "Women"

        default:
            break
            
        }
    }
    @IBAction func backBtnSelected(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AcceuilVC") as! AcceuilVC
        self.present(nextViewController, animated:true, completion:nil)    }
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
    @IBAction func updateValues() {
        let imageFromButton : UIImage = profilePic.image(for: UIControlState.normal)!
if (!NameTextField.text!.isEmpty && (!BirthDateTextField.text!.isEmpty)) {
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
    loadingIndicator.startAnimating();
    
    alert.view.addSubview(loadingIndicator)
    present(alert, animated: true, completion: nil)
    let password = "azdrezcldkdk123dkdbnchpeqwxdplke"  // returns random 32 char string
    let encrypted = AES256CBC.encryptString(profilepicString, password: password)
    User.updateUser(withName: NameTextField.text!, email:self.email, sexe: self.sexe, birthDate: BirthDateTextField.text!, profilePic: profilepicString,numCompte:numCompte ,completion: { [weak weakSelf = self] (status) in
            DispatchQueue.main.async {
                if status == true {
                    print(" success")
                   
                } else {
                    print(" not success")
                }
                weakSelf = nil
                
            }
        })
    dismiss(animated: false, completion: nil)

        }
else{
    
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
         profilepicString = ImageFunctions.convertImageToBase64(image: imagedata)
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func DidBegin(_ sender: Any) {
        self.view.endEditing(true)
        DatePickerView.isHidden = false
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.BirthDateTextField.resignFirstResponder()

        self.view.endEditing(true)
        return true
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
        if textField.tag == 2 {
            self.view.endEditing(true)

            DatePickerView.isHidden = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
getUserInformations()
        BirthDateTextField.delegate = self

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UpdateVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        DatePickerView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)        // Do any additional setup after loading the view.
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
