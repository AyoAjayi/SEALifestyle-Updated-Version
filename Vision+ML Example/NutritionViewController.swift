//
//  NutritionViewController.swift
//  Vision+ML Example
//
//  Created by Ayo  on 5/1/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AlamofireImage

class NutritionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
   
    var food: [String:Any]!
    var baseUrlImage: String!
    
    var nutritionData = [[String:Any]]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var foodImage: UIImageView!
    
    
 
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodImage.layer.masksToBounds = true
        foodImage.layer.cornerRadius = foodImage.bounds.width / 2
        foodImage.layer.borderWidth = 5
        foodImage.layer.borderColor = UIColor.purple.cgColor
        nutrientData()
        
            
        tableView.dataSource = self
        tableView.delegate = self
   
    }


    func nutrientData(){
        let foodID = food["id"] as! Int
        let FoodID = String(foodID)
        let url = URL(string: "https://api.spoonacular.com/recipes/" + FoodID + "/nutritionWidget.json?apiKey=127eb17b57ce4adc9b64e59d0e660990")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
                     // This will run when the network request returns
        if let error = error {
                print(error.localizedDescription)
        } else if let data = data {
            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            self.nutritionData = dataDictionary["good"] as! [[String : Any]]
            print(self.nutritionData)
            self.tableView.reloadData()
            }

            }
                  task.resume()
        }
        

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutritionData.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nutritionCell", for: indexPath) as! NutritionCell
        let nutritionFacts = nutritionData[indexPath.row]
        cell.nutritionLabel.text = nutritionFacts["title"] as? String
        cell.amountLabel.text = nutritionFacts["amount"] as? String
        
        let foodURL = food["image"] as! String
        let urlString = baseUrlImage + foodURL
        let url = URL(string: urlString)
        if (url != nil){
        foodImage.af_setImage(withURL: url!)
        }
        return cell
    }
       
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    
    

}

    
    
    
    
