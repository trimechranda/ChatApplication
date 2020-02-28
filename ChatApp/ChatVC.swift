//
//  ChatVC.swift
//  ChatApp
//
//  Created by TRIMECH on 26/03/2018.
//  Copyright © 2018 TRIMECH. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import MapKit

class SenderCell: UITableViewCell {
    
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var GroundImageView: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    
    func clearCellData()  {
        self.messageTextView.text = nil
        self.messageTextView.isHidden = false
       self.GroundImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.messageTextView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        self.GroundImageView.layer.cornerRadius = 15
      self.GroundImageView.clipsToBounds = true
    }
}

class ReceiverCell: UITableViewCell {
    
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var messageBackground: UIImageView!
    
    func clearCellData()  {
        self.message.text = nil
        self.message.isHidden = false
        self.messageBackground.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        self.messageBackground.layer.cornerRadius = 15
        self.messageBackground.clipsToBounds = true
    }
}

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate {
   
    @IBOutlet weak var MapView: MKMapView!
    
    
    @IBOutlet weak var FriendImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var FriendNameLabel: UILabel!
    @IBOutlet weak var SendButton: UIButton!
    @IBOutlet weak var MessageTextFiled: UITextField!
    @IBOutlet weak var NameLabel: UILabel!

    var Name :String = ""
    var IDRoom: String = ""
    var ID : String = ""
    var picProfilString : String = ""
    var PicToSendString : String = ""
    var values : NSDictionary = NSDictionary()
    var myArray : NSMutableArray? = []
    let picker = UIImagePickerController()

    
    var items = [Message]()
    let imagePicker = UIImagePickerController()
    let barHeight: CGFloat = 50
    var currentUser: User?
    var canSendLocation = true
    let locationManager = CLLocationManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()

        self.NameLabel.text = self.Name
                let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AuthentificationVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(AuthentificationVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AuthentificationVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.customization()
        self.fetchData()
            }
    // Back Button
    @IBAction func backBtnSelected(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AcceuilVC") as! AcceuilVC
        self.present(nextViewController, animated:true, completion:nil)

    }
   
    func customization() {
        self.tableView.estimatedRowHeight = self.barHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset.bottom = self.barHeight
        self.tableView.scrollIndicatorInsets.bottom = self.barHeight
        self.navigationItem.title = self.currentUser?.name
        self.navigationItem.setHidesBackButton(true, animated: false)
        locationManager.delegate = self
    }
    
    // get conversations
    
    func fetchData() {
        let messageCount = self.items.count
        Message.downloadAllMessages(IdRoom: self.IDRoom,kPagination: messageCount,completion: {[weak weakSelf = self] (message) in
            print(message.content )
            weakSelf?.items.append(message)
            weakSelf?.items.sort{ $0.timestamp < $1.timestamp }
            DispatchQueue.main.async {
                if let state = weakSelf?.items.isEmpty, state == false {
                    weakSelf?.tableView.reloadData()
                    weakSelf?.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: false)
                }
              //  Message.markMessagesRead(toID: self.ID) 
            }
        })
    }
    
  
    /// Composer le message
    ///
    /// - Parameters:
    ///   - type: type du message
    ///   - content: son contenu
    func composeMessage(type: MessageType, content: Any)  {
        let message = Message.init(type: type, content: content, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false)
        Message.send(message: message ,toID: self.ID, completion: {(_) in
        })
    }
    
    /// Action d'envoi de message
    @IBAction func SendMessageAction() {
             if let text = self.MessageTextFiled.text {
             if text.characters.count > 0 {
                let password = "azdrezcldkdk123dkdbnchpeqwxdplke"  // returns random 32 char string
                let encrypted = AES256CBC.encryptString(self.MessageTextFiled.text!, password: password)
                self.composeMessage(type: .text, content: encrypted)
                self.MessageTextFiled.text = ""
            }
        }
        else if (PicToSendString.count > 0){
               
                
            self.composeMessage(type: .photo, content: PicToSendString)
 
        }
    }
    
  
    //MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.items[indexPath.row].owner {
            case .receiver:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
            cell.clearCellData()
            switch self.items[indexPath.row].type {
            case .text:
                let password = "azdrezcldkdk123dkdbnchpeqwxdplke"  // returns random 32 char string
                let decrypted = AES256CBC.decryptString(self.items[indexPath.row].content as! String, password: password)
                
                cell.message.text = decrypted
                
            case .photo:
              let imagestring =   self.items[indexPath.row].content as! String
             
              cell.messageBackground.image  = ImageFunctions.convertBase64ToImage(base64String: imagestring)
                cell.message.isHidden = true
            case .video:
                print("is video")
            case .location:
                print("is location")
                cell.messageBackground.image = #imageLiteral(resourceName: "location")
                cell.message.isHidden = true

            }
            return cell
       
            case .sender:

            let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
            if let id = Auth.auth().currentUser?.uid {
                User.GetInfoUser(forUserID: id, completion: {[weak weakSelf = self] (user) in
                    DispatchQueue.main.async {
                        weakSelf?.picProfilString = user.profilpicString
                        cell.profilePic.image = ImageFunctions.convertBase64ToImage(base64String: self.picProfilString)
                         weakSelf = nil
                    } })
            }

            cell.clearCellData()
            switch self.items[indexPath.row].type {
            case .text:
                let password = "azdrezcldkdk123dkdbnchpeqwxdplke"  // returns random 32 char string
                let decrypted = AES256CBC.decryptString(self.items[indexPath.row].content as! String, password: password)
                
                cell.messageTextView.text =  decrypted
            case .photo:
                 let imagestring = self.items[indexPath.row].content as! String
                 
                 cell.GroundImageView.image  = ImageFunctions.convertBase64ToImage(base64String: imagestring)
            case .video:
                print("is video")

            case .location:
                print("is location")
                cell.GroundImageView.image = #imageLiteral(resourceName: "location")
               // cell.messageTextView.isHidden = true


            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       self.MessageTextFiled.resignFirstResponder()
        let newPin = MKPointAnnotation()

        switch self.items[indexPath.row].type {
               case .location:
            let coordinates = (self.items[indexPath.row].content as! String).components(separatedBy: ":")
            let location = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(coordinates[0])!, longitude: CLLocationDegrees(coordinates[1])!)
         
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            //set region on the map
            MapView.setRegion(region, animated: true)
            
          //  newPin.coordinate = locationManager.coordinate
           // MapView.addAnnotation(location as! MKAnnotation)

            
            self.inputAccessoryView?.isHidden = true
        default: break
        }
    }
   func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.isLoading = true;
    var isLoading = false
    if (indexPath.row  == self.items.count - 1) {
     //  loadMore()
    }
    }
    
    func loadMore() {
        let messageCount = 1
     
        Message.downloadAllMessages(IdRoom: self.IDRoom, kPagination:messageCount,completion: {[weak weakSelf = self] (message) in
                self.items.append(message)
            weakSelf?.items.sort{ $0.timestamp < $1.timestamp }
            DispatchQueue.main.async {
                if let state = weakSelf?.items.isEmpty, state == false {
                    weakSelf?.tableView.reloadData()
                    weakSelf?.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: false)
                }
                //  Message.markMessagesRead(toID: self.ID)
            }
            })
        
        }
    
    //Delegates Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("HELLO")
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
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
    @IBAction func selectLocation(_ sender: Any) {
        self.canSendLocation = true
        if self.checkLocationPermission() {
            self.locationManager.startUpdatingLocation()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        if let lastLocation = locations.last {
            if self.canSendLocation {
                let coordinate = String(lastLocation.coordinate.latitude) + ":" + String(lastLocation.coordinate.longitude)
                let message = Message.init(type: .location, content: coordinate, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false)
                Message.send(message: message ,toID: self.ID, completion: {(_) in
                })
                self.canSendLocation = false
            }
        }
    }
    func checkLocationPermission() -> Bool {
        var state = false
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            state = true
        case .authorizedAlways:
            state = true
        default: break
        }
        return state
    }
    //MARK:UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let imagedata = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
           // profilePic.setImage(imagedata, for: .normal)
            let encrypted  = ImageFunctions.convertImageToBase64(image: imagedata)
            let password = "azdrezcldkdk123dkdbnchpeqwxdplke"  // returns random 32 char string
            PicToSendString = AES256CBC.encryptString(encrypted, password: password)!
        }
        
        dismiss(animated: true, completion: nil)
        if (PicToSendString.count > 0){
            self.composeMessage(type: .photo, content: PicToSendString)
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
