//
//  ChatListTableViewController.swift
//  TRVLR
//
//  Created by Klara Lucianovic (RIT Student) on 12/9/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//

import UIKit

class ChatListTableViewController: UITableViewController {
    
    var data: [Match] = []
    var chats: [[ChatMessage]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ChatTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ChatTableViewCell.reuseIdentifier)
        DataManager.shared.fetchAllMatches(completion: { (foundMatches) in
            self.data = foundMatches
            self.tableView.reloadData()
        })
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DataManager.shared.fetchAllMatches(completion: { (foundMatches) in
            self.data = foundMatches
            self.data.sort { $0.chatUID < $1.chatUID }
            self.tableView.reloadData()
            
        })
        
        
        self.title = "Messages"
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count //MARK: change dis
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? ChatTableViewCell else {
                                                        return UITableViewCell()
        }
        
        let match = data[indexPath.row]
        
        //MARK: change dis 👎🏿
        if let currentUserUID = DataManager.shared.userID {
            // Saving the local user in the cell
            DataManager.shared.getUserByUID(uid: currentUserUID) { (localUser) in
                guard let localUser = localUser.user else { return }
                cell.user1 = localUser
            }
            
            // Saving the user user and configuring the cell for the other user
            if(match.user1UID == currentUserUID) {
                DataManager.shared.getUserByUID(uid: data[indexPath.row].user2UID) { (foundUser) in
                    guard let user = foundUser.user else { return }
                    cell.user2 = user
                    cell.configure(for: user, and: self.data[indexPath.row])
                }
            } else {
                DataManager.shared.getUserByUID(uid: data[indexPath.row].user1UID) { (foundUser) in
                    guard let user = foundUser.user else { return }
                    cell.user2 = user
                    cell.configure(for: user, and: self.data[indexPath.row])
                }
            }
        }
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let messengerViewController = segue.destination as? MessengerViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            
            guard let cell = tableView.cellForRow(at: indexPath) as? ChatTableViewCell else { return }
            messengerViewController.localUser = cell.user1
            messengerViewController.otherUser = cell.user2
            messengerViewController.match = data[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToMessages", sender: nil)
    }
    
}
