//
//  CookViewController.swift
//  Vision+ML Example
//
//  Created by Ayo  on 5/1/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Parse

class CookViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var food: [String:Any]!

    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func buttonPressed(_ sender: Any) {
        likeButton.setImage(UIImage(named:"like"), for: UIControl.State.normal)
        let alert = UIAlertController(title: "Thank you!", message: "Your feedback is important to us! Feel free to continue browsing SEALifestyle.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
            
    }
    
    @IBOutlet weak var likeButton: UIButton!
    

   
    var recipeData = [[String:Any]]()
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        super.viewDidLoad()
        cookingData()

        // Do any additional setup after loading the view.
    }
   
    
    @IBAction func likeMealButton(_ sender: Any) {
        let foodScore = PFObject(className:"Meals")
        let foodName = food["title"] as! String
        foodScore["foodType"] = foodName
        foodScore.saveInBackground {(success: Bool, error: Error?) in
        if (success) {
            print("Saved...")
        } else {
            print("error \(error!.localizedDescription)")
        }
        }
    }
    
    
    func cookingData(){
           let foodID = food["id"] as! Int
           let FoodID = String(foodID)
           
           let url = URL(string: "https://api.spoonacular.com/recipes/" + FoodID + "/analyzedInstructions?apiKey=c4295465101844b6bdb8ae9b78be04ee")!
           let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
           let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
           let task = session.dataTask(with: request) { (data, response, error) in
                               // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
                //Seems like there is no dataDictionary for rice Krispies
                
                if dataDictionary.count == 0{
                    let alert = UIAlertController(title: "Sorry!", message: "We do not currently have data for this food item. Please check back later", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                   
                    
                }else{
                    self.recipeData = dataDictionary[0]["steps"] as! [[String : Any]]

                    self.tableView.reloadData()
                    
                }

     
            }

           }
        task.resume()
    }

    
//    var liked: Bool = false
//
//    func setLike(_ isLiked:Bool){
//        liked = isLiked
//        if (liked) {
//            likeButton.setImage(UIImage(named:"like_icon"), for: UIControl.State.normal)
//        }
//    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeData.count
     
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cookCell", for: indexPath) as! CookCell
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        
        let steps = recipeData[indexPath.row]
        let info = steps["step"] as? String
        cell.recipeLabel.text = info
        
        return cell
        
    }

    @IBAction func backButton(_ sender: Any) {
          self.dismiss(animated: true, completion: nil)
    }
  
    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destination.
         Pass the selected object to the new view controller.
    }
    */

}
