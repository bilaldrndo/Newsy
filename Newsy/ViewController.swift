//
//  ViewController.swift
//  Newsy
//
//  Created by Bilal on 6/9/18.
//  Copyright © 2018 Bilal Drndo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var article = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNews(url: "https://newsapi.org/v2/top-headlines?sources=al-jazeera-english&apiKey=2ae19b3dc8954830bbf9cfa6a632bd50")
    }

    func fetchNews(url: String){
        Alamofire.request(url).responseJSON { (response) in
            if response.result.isSuccess {
                print("Succes")
                let result = response.result
                if let dict = result.value as? Dictionary<String,AnyObject>{
                    if let innerDict = dict["articles"] {
                        self.article = innerDict as! [AnyObject]
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return article.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        
        cell.titleLbl.text = article[indexPath.row]["title"] as? String
        
        
        return cell
    }

}


extension UIImageView {
    
    func downloadImage(from url: String){
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data,response,error) in
            
            if error != nil {
                
                print(error)
                return
                
            }
            
            DispatchQueue.main.async {
                
                self.image = UIImage(data: data!)
                
            }
            
        }
        
        task.resume()
    }
    
}























