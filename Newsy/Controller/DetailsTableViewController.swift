//
//  NewsTableViewController.swift
//  Newsy
//
//  Created by Bilal on 6/18/18.
//  Copyright © 2018 Bilal Drndo. All rights reserved.
//

import UIKit

class DetailsTableViewController: UITableViewController{
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var imgView: UIImageView!
    
    //MARK: - VARIABLES

    private let kTableHeaderHeight : CGFloat = 262
    var headerView: UIView!
    
    var titleName : String?
    var desc : String?
    var author : String?
    var urlToImage : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sizableImage()
        tableView.rowHeight = 320
        tableView.separatorStyle = .none
    }
    
    //MARK: - TABLEVIEW METHODS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreNewsCell", for: indexPath) as! DetailsNewsTableViewCell
        
        if let titleA = titleName, let authorA = author, let descA = desc, let url = urlToImage {
            cell.titleLbl.text = titleA
            cell.authorLbl.text = "Author: \(authorA)"
            cell.descLbl.text = descA
            imgView.downloadImage(from: url)
        }else {
            cell.titleLbl.text = "Sorry, We couldnt find Title"
            cell.descLbl.text = "Description Not Found"
            cell.authorLbl.text = "Author Not Found"
            imgView.image = #imageLiteral(resourceName: "image")
        }
        return cell
    }
 

}


//MARK: - SIZABLE HEADER FUNCTIONS

extension DetailsTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    //MARK: - FUNCTIONS
    
    func sizableImage() {
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        
        tableView.addSubview(headerView)
        
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        updateHeaderView()
    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }
}
