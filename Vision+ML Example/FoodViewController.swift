//
//  FoodViewController.swift
//  Vision+ML Example
//
//  Created by Ayo  on 5/1/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var baseUrlImage: String!
    @IBOutlet weak var tableView: UITableView!
    var food_string = [String]()
    var foodData = [[String:Any]]()
    @IBOutlet weak var foodLabel: UILabel!
 
    


    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
            
        tableView.dataSource = self
        tableView.delegate = self
   
    }


    func loadData(){
        foodLabel.text = food_string[0]
        let url = URL(string: "https://api.spoonacular.com/recipes/search?query=" + food_string[0] + "&number=100&apiKey=c4295465101844b6bdb8ae9b78be04ee")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
        if let error = error {
                print(error.localizedDescription)
        } else if let data = data {
            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            print(dataDictionary)
            self.foodData = dataDictionary["results"] as! [[String : Any]]
            self.baseUrlImage = dataDictionary["baseUri"] as! String
            self.tableView.reloadData()
            }

            }
            task.resume()
        }
        

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodData.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodTablecell", for: indexPath) as! FoodCell
        let foodFacts = foodData[indexPath.row]
        cell.suggestLabel.text = foodFacts["title"] as? String
        let foodURL = foodFacts["image"] as! String
        let urlString = baseUrlImage + foodURL
        let url = URL(string: urlString)
        if (url != nil){
            cell.foodImage.af_setImage(withURL: url!)
        }
    
       return cell


    }
}

    
    
    
    
    
    
    
