//
//  ConfigurationsVC.swift
//  ChatApp
//
//  Created by TRIMECH on 20/03/2018.
//  Copyright © 2018 TRIMECH. All rights reserved.
//

import UIKit
import Firebase
class ConfigurationsVC: UIViewController,UITableViewDelegate, UITableViewDataSource{
 
    @IBOutlet weak var TabBar: UITabBarItem!
    @IBOutlet weak var imagee: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var TextLabel: UILabel!
    var Array :[String] = ["Généralités","Aide et commentaires","A propos","Se déconnecter"]
    var ArrayImages :[String] = ["Update.png","help.png","About.png","Deconnect.png"]

    override func viewDidLoad() {
        super.viewDidLoad()
        print("hey configurations")
        
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView!, cellForRowAt indexPath: IndexPath!) -> UITableViewCell!
    {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "mycell")
        cell.textLabel?.text = Array[indexPath.row]
        cell.imageView?.image = UIImage(named:ArrayImages[indexPath.row] )
        return cell
    }

    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let indexPath = tableView.indexPathForSelectedRow
    
    //getting the current cell from the index path
    let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
    
    let currentItem = currentCell.textLabel!.text
    if(currentItem == "Généralités"){
        let loggedInVC:UpdateVC = self.storyboard!.instantiateViewController(withIdentifier: "UpdateVC") as! UpdateVC
        
        
        self.present(loggedInVC, animated: false, completion: nil)    }
    if(currentItem == "Aide et commentaires"){
        print("second view")
    }
    if(currentItem == "A propos"){
        print("third view")
    }
    if(currentItem == "Se déconnecter"){
        User.logOutUser()
        let loggedInVC:AuthentificationVC = self.storyboard!.instantiateViewController(withIdentifier: "AuthentificationVC") as! AuthentificationVC
        
        self.present(loggedInVC, animated: true, completion: nil)
    }
    
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
