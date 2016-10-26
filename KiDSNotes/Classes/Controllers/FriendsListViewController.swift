//
//  FriendsListViewController.swift
//  KiDSNotes
//
//  Created by deus4 on 14/10/16.
//  Copyright © 2016 deus4. All rights reserved.
//

import UIKit
import Parse

class FriendsListViewController: ViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var searchResults : [PFUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendString(textField: searchTextField)


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func textFieldChanged(_ sender: UITextField) {
        sendString(textField: sender)
    }
   
    func sendString(textField: UITextField){
        if let text = textField.text{
            getResultsFromParse(inputString: text)
            print(text)
        }
    }
    
    
    func getResultsFromParse (inputString: String) {
        let query = PFQuery(className: "_User")
        query.whereKey("displayName", contains: "")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) in
            if error == nil {
                var sortedObjects : [PFUser] = []
                if inputString != ""{
                    for obj in objects as! [PFUser] {
                        let userName = obj.value(forKey: "displayName") as! String
                        if userName.lowercased().contains(inputString.lowercased()){
                            sortedObjects.append(obj)
                        }
                    }
                }else {
                    sortedObjects = objects as! [PFUser]
                }
                self.searchResults = sortedObjects
                self.tableView.reloadData()
                print(sortedObjects.count)
            } else {
                print("\(error)")
            }
        }
    }


}

extension FriendsListViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count > 0 ? searchResults.count : 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchResults.count == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Didnt found anything"
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! FriendsListCell
            let user = searchResults[indexPath.row]
            cell.userName.text = user.value(forKey: "displayName") as! String?
            if let imgFile = user.value(forKey: "profilePictureSmall") as? PFFile{
                do{
                    let data = try imgFile.getData()
                    let image = UIImage(data: data)!
                     UIGraphicsBeginImageContext(CGSize(width: 90, height: 90))
                    image.draw(in: CGRect(x: 0, y: 0, width: 90, height: 90))
                    let newImg = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    cell.userImage.image = newImg
                    cell.userImage.layer.cornerRadius = 10
                    
                }catch{
                    print("error in data")
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showUserInfo", sender: self)
    }
}
