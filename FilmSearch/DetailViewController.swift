//
//  DetailViewController.swift
//  Master-Detail
//
//  Created by Denys on 9/1/16.
//  Copyright © 2016 Denys Holub. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var tableView: UITableView!
  
  var user: User!
  
  let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
  // 2
  var dataTask: URLSessionDataTask?
  
  var currentFilm = [CurrentFilm]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      let url = NSURL(string: user.image!)
      let data = NSData(contentsOf: url! as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check
      self.productImageView.image = UIImage(data: data! as Data)
      //self.productImageView.image = UIImage(named: user.image!)
//      let url = NSURL(string: currentFilm[0].poster!)
//      let data = NSData(contentsOf: url! as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check
//      self.productImageView.image = UIImage(data: data! as Data)
      self.tableView.backgroundColor = UIColor(red: 250 / 255, green: 212 / 255, blue: 255 / 255, alpha: 1.0)
      self.tableView.tableFooterView = UIView(frame: CGRect.zero)
      self.tableView.separatorColor = UIColor(red: 252 / 255, green: 232 / 255, blue: 255 / 255, alpha: 1.0)
      
      self.tableView.estimatedRowHeight = 44
      self.tableView.rowHeight = UITableViewAutomaticDimension
      currentFilmRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func updateResults(data: Data?) {
    do {
      if let data = data, let response = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
        
        // Get the results array
        let title = response["Title"] as? String
        let year = response["Year"] as? String
        let poster = response["Poster"] as? String
        let director = response["Director"] as? String
        let writer = response["Writer"] as? String
        let actors = response["Actors"] as? String
        let country = response["Country"] as? String
        let imdbRating = response["imdbRating"] as? String
        let imdbVotes = response["imdbVotes"] as? String
        let type = response["Type"] as? String
        currentFilm.append(CurrentFilm(title: title, year: year, poster: poster, director: director, writer: writer, actors: actors, country: country, imdbRating: imdbRating, imdbVotes: imdbVotes, type: type))
      } else {
        print("JSON Error")
      }
    } catch let error as NSError {
      print("Error parsing results: \(error.localizedDescription)")
    }
    
//    DispatchQueue.main.async(execute:{
//      self.tableView.reloadData()
//      //self.tableView.setContentOffset(CGPoint.zero, animated: false)
//    })
  }
  
  // MARK: Keyboard dismissal

  func currentFilmRequest() {
    let stringUrl = "https://www.omdbapi.com/?t=\(user.login!)&y=\(user.link!)&plot=short&r=json"
    let replaseUrl = stringUrl.replacingOccurrences(of: " ", with: "+")
    let replaseUrl1 = replaseUrl.replacingOccurrences(of: "–", with: "%2D")
    //2
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    // 4
    let url = NSURL(string: replaseUrl1)
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
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 9
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailTableViewCell
    
    //отображение информации в ячейках
    
    //    if indexPath.row == 0 {
    //      cell.keyLabel.text = "Название"
    //      cell.valueLabel.text = product.title
    //    }
    //    if indexPath.row == 1 {
    //      cell.keyLabel.text = "Тип"
    //      cell.valueLabel.text = product.subtitle
    //    }

    switch indexPath.row {
    case 0:
      cell.keyLabel.text = "Название"
      cell.valueLabel.text = currentFilm[0].title!
    case 1:
      cell.keyLabel.text = "Год"
      cell.valueLabel.text = currentFilm[0].year!
    case 2:
      cell.keyLabel.text = "Директор"
      cell.valueLabel.text = currentFilm[0].director!
    case 3:
      cell.keyLabel.text = "Режисер"
      cell.valueLabel.text = currentFilm[0].writer!
    case 4:
      cell.keyLabel.text = "Актеры"
      cell.valueLabel.text = currentFilm[0].actors!
    case 5:
      cell.keyLabel.text = "Страна"
      cell.valueLabel.text = currentFilm[0].country!
    case 6:
      cell.keyLabel.text = "imdbRating"
      cell.valueLabel.text = currentFilm[0].imdbRating!
    case 7:
      cell.keyLabel.text = "imdbVotes"
      cell.valueLabel.text = currentFilm[0].imdbVotes!
    case 8:
      cell.keyLabel.text = "Тип"
      cell.valueLabel.text = currentFilm[0].type!
    default:
      cell.keyLabel.text = ""
      cell.valueLabel.text = ""
    }
//    cell.valueLabel.text = film.login
//    cell.valueLabel.text = film.link
    cell.backgroundColor = UIColor.clear
    
    return cell
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
