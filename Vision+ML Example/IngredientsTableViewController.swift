//
//  IngredientsTableViewController.swift
//  Vision+ML Example
//
//  Created by Ayo  on 5/1/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AlamofireImage

class IngredientsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var food: [String:Any]!
    var baseUrlImage: String!
    var foodData = [[String:Any]]()
    
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var foodLabel: UILabel!
    
    @IBAction func backButton(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    

 override func viewDidLoad() {
     displayImage.layer.masksToBounds = true
    displayImage.layer.cornerRadius = displayImage.bounds.width / 2
     displayImage.layer.borderWidth = 4
     displayImage.layer.borderColor = UIColor.lightGray.cgColor
     foodLabel.text = food["title"] as? String
     
     let foodURL = food["image"] as! String
     let urlString = baseUrlImage + foodURL
     let url = URL(string: urlString)
     if (url != nil){
         displayImage.af_setImage(withURL: url!)
         
     }
     super.viewDidLoad()
     
     self.theTableView.delegate = self
     self.theTableView.dataSource = self
     loadRecipeData()
 
 }
 
func loadRecipeData(){
      let foodID = food["id"] as! Int
      let FoodID = String(foodID)
      let url = URL(string: "https://api.spoonacular.com/recipes/" + FoodID + "/ingredientWidget.json?apiKey=c4295465101844b6bdb8ae9b78be04ee")!
      let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
      let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
      let task = session.dataTask(with: request) { (data, response, error) in
         // This will run when the network request returns
         if let error = error {
            print(error.localizedDescription)
         } else if let data = data {
            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
          self.foodData = dataDictionary["ingredients"] as! [[String:Any]]
          self.theTableView.reloadData()
         }
          
      }
      task.resume()
  }
      
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      self.foodData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientsCell", for: indexPath) as! IngredientsCell
      let ingredient = foodData[indexPath.row]
      cell.ingredientsLabel.text = ingredient["name"] as? String
      let ingredientURL = ingredient["image"] as! String
      let urlString = "https://spoonacular.com/cdn/ingredients_100x100/" + ingredientURL

      let url = URL(string: urlString)
      if (url != nil){
              cell.ingredientsImage.af_setImage(withURL: url!)

      }
      return cell
  }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NutritionViewController{
             let nutritionViewController = segue.destination as! NutritionViewController
             nutritionViewController.food = food
                nutritionViewController.baseUrlImage = baseUrlImage
                
        } else if segue.destination is CookViewController{
                let cookViewController = segue.destination as! CookViewController
                cookViewController.food = food
     

            }
    
     }
    
    
    
    
}
