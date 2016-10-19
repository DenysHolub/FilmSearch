//
//  UserTableViewController.swift
//  UserData
//
//  Created by Denys on 9/20/16.
//  Copyright © 2016 Denys Holub. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController, UISearchBarDelegate {

  // 1
  let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
  // 2
  var dataTask: URLSessionDataTask?
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  var searchResults = [User]()
  
  lazy var tapRecognizer: UITapGestureRecognizer = {
    var recognizer = UITapGestureRecognizer(target:self, action: #selector(UIInputViewController.dismissKeyboard))
    return recognizer
  }()
  
  
    override func viewDidLoad() {
      super.viewDidLoad()
      
      //searchBarSearchButtonClicked(searchBar)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
      

    }
  
  func updateResults(data: Data?) {
    searchResults.removeAll()
    do {
      if let data = data, let response = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
        
        // Get the results array
        if let array: AnyObject = response["Search"] {
          for trackDictonary in array as! [AnyObject] {
            if let trackDictonary = trackDictonary as? [String: AnyObject] {
              // Parse the search result
              let name = trackDictonary["Title"] as? String
              let artist = trackDictonary["Year"] as? String
              let previewUrl = trackDictonary["Poster"] as? String
              searchResults.append(User(login: name, link: artist, image: previewUrl))
            } else {
              print("Not a dictionary")
            }
          }
        } else {
          print("Results key not found in dictionary")
        }
      } else {
        print("JSON Error")
      }
    } catch let error as NSError {
      print("Error parsing results: \(error.localizedDescription)")
    }
    
    DispatchQueue.main.async(execute:{
      self.tableView.reloadData()
      //self.tableView.setContentOffset(CGPoint.zero, animated: false)
    })
  }
  
  // MARK: Keyboard dismissal
  
  func dismissKeyboard() {
    searchBar.resignFirstResponder()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    dismissKeyboard()
    
    if !searchBar.text!.isEmpty {
      // 1
      if dataTask != nil {
        dataTask?.cancel()
      }
      // 2
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      // 3
      let expectedCharSet = NSCharacterSet.urlQueryAllowed
      let searchTerm = searchBar.text!.addingPercentEncoding(withAllowedCharacters: expectedCharSet)!
      // 4
      let url = NSURL(string: "https://www.omdbapi.com/?s=\(searchTerm)")
      // 5
      dataTask = defaultSession.dataTask(with: url! as URL) {
        data, response, error in
        // 6
        DispatchQueue.main.async(execute:{
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
        // 7
        if let error = error {
          print(error.localizedDescription)
        } else if let httpResponse = response as? HTTPURLResponse {
          if httpResponse.statusCode == 200 {
            self.updateResults(data: data)
          }
        }
      }
      // 8
      dataTask?.resume()
    }
  }
  
//  func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
//    return .topAttached
//  }
//  
//  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//    view.addGestureRecognizer(tapRecognizer)
//  }
//  
//  func searchBarTextDidEndEditing(searchBar: UISearchBar) {
//    view.removeGestureRecognizer(tapRecognizer)
//  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      return searchResults.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cellIdentifier = "Cell"
      
      let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserTableViewCell

        // Configure the cell...
      
      // Delegate cell button tap events to this view controller
      //cell.delegate = self
      let users = searchResults[indexPath.row]
      let url = NSURL(string: users.image!)
      let data = NSData(contentsOf: url! as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check
      cell.thumbnailImageView.image = UIImage(data: data! as Data)
      
      //cell.thumbnailImageView.image = UIImage(named: user[indexPath.row].image!)
      
      cell.loginLabel.text = users.login
      cell.linkLabel.text = users.link
      cell.thumbnailImageView.layer.cornerRadius = cell.thumbnailImageView.frame.size.height / 2
      cell.thumbnailImageView.clipsToBounds = true

      return cell
    }
  
//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//      if searchController.isActive {
//        return false
//      } else {
//        return true
//      }
//    }
  

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "showDetailsSegue" {
        if let indexPath = self.tableView.indexPathForSelectedRow {
          let detinationVC = segue.destination as! DetailViewController
          detinationVC.user = searchResults[indexPath.row]
        }
      }
  }

}
