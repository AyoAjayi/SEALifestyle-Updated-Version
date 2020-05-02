//
//  MealGridViewController.swift
//  Vision+ML Example
//
//  Created by Ayo  on 4/30/20.
//  Copyright © 2020 Apple. All rights reserved.
//




import UIKit
import AlamofireImage

class MealGridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    var foodData = [[String:Any]]()
    var fullFoodData = [[String:Any]]()
    var filteredData = [String]()
    var data = [String]()
    var baseUrlImage: String!

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var appLogo: UIImageView!
    @IBOutlet var welcomePoster: UIImageView!
    @IBOutlet var greetingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4

        let width = (view.frame.size.width - layout.minimumInteritemSpacing) / 2
        layout.itemSize = CGSize(width: width, height: width * 3 / 4)

        searchBar.delegate = self

        loadFoodData()


    }


    @IBAction func logOut(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func swipeRecognizer(_ sender: Any) {
        view.endEditing(true)
    }

    func loadFoodData(){
        let url = URL(string: "https://api.spoonacular.com/recipes/search?apiKey=c4295465101844b6bdb8ae9b78be04ee")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            self.foodData = dataDictionary["results"] as! [[String:Any]]
            self.fullFoodData = dataDictionary["results"] as! [[String:Any]]
            self.baseUrlImage = dataDictionary["baseUri"] as! String
            for recipe in self.foodData{
                self.data.append(recipe["title"] as! String)
            }
           }
            self.collectionView.reloadData()
        }
        task.resume()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.2, animations: {
            self.searchBar.frame = CGRect(x: self.searchBar.frame.origin.x,
                                          y: self.searchBar.frame.origin.y - 400,
                                          width: self.searchBar.frame.size.width,
                                          height: self.searchBar.frame.size.height)

         self.collectionView.frame = CGRect(x: self.collectionView.frame.origin.x,
                                            y: self.collectionView.frame.origin.y - 400,
                                            width: self.collectionView.frame.size.width, height: self.collectionView.frame.size.height + 300)
            self.appLogo.alpha = 0
            self.welcomePoster.alpha = 0
            self.greetingLabel.alpha = 0
        })
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        var newFrame: CGRect = self.searchBar.frame
        newFrame.origin.y += 400
        var viewFrame: CGRect = self.collectionView.frame
        viewFrame.origin.y += 400
        viewFrame.size.height -= 300

        UIView.animate(withDuration: 0.2, animations: {
            self.searchBar.frame = newFrame
            self.collectionView.frame = viewFrame

            self.appLogo.alpha = 1
            self.welcomePoster.alpha = 1
            self.greetingLabel.alpha = 1
        })
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.foodData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealGridCell", for: indexPath) as! MealViewCell
        let food = foodData[indexPath.row]
        let foodURL = food["image"] as! String
        let urlString = baseUrlImage + foodURL
        let url = URL(string: urlString)
        if (url != nil){
        cell.mealPicture.af_setImage(withURL: url!)
}
        return cell
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredData = searchText.isEmpty ? data : data.filter { (item:String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        var dummy_array = [[String:Any]]()
        for element in self.fullFoodData{
            let foodType = element["title"] as! String
            if filteredData.contains(foodType){
                dummy_array.append(element)
            }
        }
        self.foodData = dummy_array

        collectionView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is IngredientsTableViewController{
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)!
            let food = foodData[indexPath.row]

            let ingredientsViewController = segue.destination as! IngredientsTableViewController
            ingredientsViewController.food = food
            ingredientsViewController.baseUrlImage = baseUrlImage
    }
        else if segue.destination is ImageClassificationViewController{
            let imageClassificationViewController = segue.destination as! ImageClassificationViewController
        }
    }
    
    
    
    

    
    
    
    

}
