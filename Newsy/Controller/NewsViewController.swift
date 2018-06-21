//
//  ViewController.swift
//  Newsy
//
//  Created by Bilal on 6/9/18.
//  Copyright © 2018 Bilal Drndo. All rights reserved.
//

import UIKit
import Alamofire

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet var soucesOptionsBtnsOutlet: [UIButton]!
    @IBOutlet weak var darkShadowMenu: UIView!
    
    //MARK: - VARIABLES
    
    var article = [AnyObject]()
    
    var sources = "al-jazeera-english"
    
    var isSlideMenuHidden = true
    
    //MARK: - VIEW DID LOAD METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchNews(source: sources)
        
        tableView.rowHeight = 120
        
        constraint.constant = -160
        
        darkShadowMenu.isHidden = true
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hideMenu (_:)))
        self.darkShadowMenu.addGestureRecognizer(gesture)
    }
    
    //MARK: - FETCH NEWS METHOD
    
    func fetchNews(source: String){
        Alamofire.request("https://newsapi.org/v2/top-headlines?sources=\(source)&apiKey=2ae19b3dc8954830bbf9cfa6a632bd50",method: .get).responseJSON { (response) in
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
            if response.result.isFailure {
                print("failure in json request")
            }
        }
    }

    //MARK: - TABLEVIEW METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return article.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        
        if let titleName = article[indexPath.row]["title"] as? String, let urlToImage = article[indexPath.row]["urlToImage"] as? String{
            cell.imgView.downloadImage(from: urlToImage)
            cell.titleLbl.text = titleName
        }else {
            cell.titleLbl.text = "Aticle Unavailable"
            cell.imgView.image = #imageLiteral(resourceName: "image")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetails", sender: self)
    }
    
    //MARK: - SEGUE METHOD
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? DetailsTableViewController {
            destination.titleName = article[(tableView.indexPathForSelectedRow?.row)!]["title"] as? String
            destination.author = article[(tableView.indexPathForSelectedRow?.row)!]["author"] as? String
            destination.desc = article[(tableView.indexPathForSelectedRow?.row)!]["description"] as? String
            destination.urlToImage = article[(tableView.indexPathForSelectedRow?.row)!]["urlToImage"] as? String
        }
        
    }
    
    @IBAction func dropBtnPressed(_ sender: UIBarButtonItem) {
        if isSlideMenuHidden {
            constraint.constant = 0
            darkShadowMenu.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }else {
            constraint.constant = -160
            darkShadowMenu.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        isSlideMenuHidden = !isSlideMenuHidden
    }
    
    @IBAction func categoriesBtnClicked(_ sender: UIButton) {
        soucesOptionsBtnsOutlet.forEach { (sourcesBtn) in
            UIView.animate(withDuration: 0.4, animations: {
                sourcesBtn.isHidden = !sourcesBtn.isHidden
                self.view.layoutIfNeeded()
            })
    }
    }
    
    @IBAction func sourcePressed(_ sender: UIButton) { /*
        if sender.tag == 1{
            fetchNews(source: "bbc-news")
            tableView.reloadData()
        } */
    }
    
    @objc func hideMenu(_ sender:UITapGestureRecognizer){
        constraint.constant = -160
        darkShadowMenu.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        isSlideMenuHidden = !isSlideMenuHidden
    }
    
}

//MARK: - NEWS VIEW CONTOLLER EXTENSION

extension NewsViewController {
    
}

//MARK: - DOWNLAOD IMAGE METHOD

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

/* */



