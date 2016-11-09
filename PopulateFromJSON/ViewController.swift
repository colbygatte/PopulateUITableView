//
//  ViewController.swift
//  PopulateFromJSON
//
//  Created by Colby Gatte on 11/9/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var url: URL!
    var jsonObject: [[String:Any]]!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        url = URL(string: "https://jsonplaceholder.typicode.com/photos")
        jsonObject = [[String:Any]]()
        
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            self.jsonObject = try! JSONSerialization.jsonObject(with: data!, options: []) as! [[String:Any]]
            
            print("hi")
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }).resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonObject.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let cellData = self.jsonObject[indexPath.row]
        
        cell.textLabel?.text = cellData["title"] as! String
        
        let urlString = cellData["thumbnailUrl"] as! String
        var imageURLComp = URLComponents(string: urlString)!
        imageURLComp.scheme = "https"
        
        URLSession.shared.dataTask(with: imageURLComp.url!, completionHandler:{ (data: Data?, response: URLResponse?, error: Error?) in
            cell.imageView?.image = UIImage(data: data!)
        }).resume()
        
        return cell
    }
}
/*
 ARRAY OF
 
 {
 "albumId": 1,
 "id": 1,
 "title": "accusamus beatae ad facilis cum similique qui sunt",
 "url": "http://placehold.it/600/92c952",
 "thumbnailUrl": "http://placehold.it/150/30ac17"
 },
 */

