# SEA LIFESTYLE


## App Narrated User Story

Can be viewed here: https://www.youtube.com/watch?v=np8aVv6XARs


## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)


## Overview
### Description
SEA Lifestyle tackles issues of overeating, and obesity by helping the user maintain a healthy lifestyle. This app allows the user get nutritional facts on the food they consume. The user would also be able to view previous meals, view the ingredients, and cook a meal.


### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Health/Social
- **Mobile:** This app is made to function on mobile platforms so that users can easily access its features. However, it could be modified for a computer. The same components would still be available on a web platform, however, the mobile version would have the most up to date features. 
- **Story:** Allows users to view nutritional facts about foods to encourage them to make better health choices. The user can also cook a meal, and like a food. The social component of the app is being able to see the food people like the most.
- **Market:** Any individual could choose to use this app. However, the age group we are targeting ranges from ages 12 to 25. We want to promote a healthy lifestyle amongst the youth and young adult age groups so that they can maintain it as they age.
- **Habit:** This can be used based on the user's health goals. If a user is trying to improve their eating lifestyle, they might use the app everyday. If the user is more interested in the cooking feature of the app, they could use the app once a week.
- **Scope:** First, users would be able to type in foods and get information about the food and also a recipe for preparing the food. However, this app could evolve and become convenient for users. Users could take pictures of their home cooked meals, or foods at restaurants and receive real time data about the nutritional facts of the food.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] User can register for an account
- [x] User can log in 
- [x] User can view SEA Lifestyle Logo
- [x] User can view app description
- [x] User can view a table of previously searched meals
- [x] User can see a variety of healthy food options
- [x] User can search foods
- [x] User can click sign up button
- [x] User can click nutritional facts button
- [x] User can view nutritional facts about a food type
- [x] User can view food ingredients
- [x] User can view the image of the food they searched for
- [x] User can click search results images
- [x] User can view number of people who searched for a meal by accessing previous searches
- [x] User can hit "previous searches" button to see previously searched foods
- [x] User can click cook button
- [x] User can view steps to cook a meal
- [x] User can like a meal
- [x] User can log out

**Optional Nice-to-have Stories**

- [x] User can upload a picture of their meals 
- [ ] User can see nutritional facts of food after uploading picture of food.
- [ ] User can put in location to see healthy food restaurants near them.
- [ ] User can see how many calories per food item
- [ ] User has a calorie tracker to see how many calories consumed per day
- [ ] User can generate a meal plan
 

### 2. Screen Archetypes

* Registration Screen
    * User can register for an account
    * User can view SEA Lifestyle Logo
 
* Login Screen 
    * User can log in
    * User can view SEA Lifestyle Logo
    * User can click sign up button

* Home/Search Screen
    * User can view SEA Lifestyle Logo
    * User can search foods
    * User can type in a brand name
    * User can click search button
    * User can see a variety of healthy food options
    * User can view app description
    * User can hit "previous searches" button to see previously searched foods
    * User can log out
   
* Search Result Screen
    * User can view the image of the food they searched for
    * User can view a table of previously searched meals
    * User can view food ingredients
    * User can click nutritional facts button
    * User can click cook button
    * User can log out

* Nutritional Facts Screen
    * User can view nutritional facts about a food type
    * User can log out
    
* Previous Search Screen
    * User can view a table of previously searched meals
    * User can view number of people who searched for a meal by accessing previous searches
    * User can log out

* Cooking Screen 
   *  User can view steps to cook a meal
   *  User can like a meal
   *  User can log out
  

### 3. Navigation

**Tab Navigation** (Tab to Screen)
* Search for Food
* Logout
* Previously Searched

**Flow Navigation** (Screen to Screen)

* login Screen
   * Home/Search Screen
* Registeration Screen
   * Login Screen
* Home/Search Screen
   * Previous Search Screen
   * Login Screen
   * Search Result Screen
* Previous Search Screen
   * Login Screen
   * Home/Search Screen
* Search Result Screen
   * Nutritional Facts Screen
   * Cooking Screen
   * Home/Search Screen
* Nutritional Facts Screen
   * Login Screen
   * Search Result Screen
* Cooking Screen
   * Login Screen
   * Search Result Screen


## Wireframes
![](https://i.imgur.com/CDmAHEm.jpg)


<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups
This is the link to our prototype: 
https://www.figma.com/file/Xys8tWlwc3fL8NnvPDgkRB/SEALifestyle?node-id=0%3A1

### [BONUS] Interactive Prototype
Our prototype is also interactive. Please click the link: https://www.figma.com/file/Xys8tWlwc3fL8NnvPDgkRB/SEALifestyle?node-id=0%3A1

## Schema 
[This section will be completed in Unit 9]
### Models

| Property | Type | Description |
| -------- | -------- | -------- |
| Username    | String     | Text that stores the name of the user     |
| Number of likes    | Number   | Stores the number of people that like a meal     |
| Image    | File | Image of selected food    |


### Networking

* Home/Search Screen
    (create/POST) Searching food items
    * (Read/Get) Previous searches
    * (Delete) Delete existing likes
    * (Create/POST) New liked items
* Search Result Screen
    * (Read/Get) food items 
    * (Read/Get) ingredients on meals
        
* Nutritional Facts Screen
    * (Read/Get) Nutritional facts on food items
* Cooking Screen
    * (Read/Get) instructions on how to prepare meal


* Saving liked cooks with Parse
    * let foodScore = PFObject(className:"FoodScore")
    * foodScore["name"] = food_name
    * foodScore["author"] = PFUser.current!
    * foodScore.saveInBackground { (succeeded, error)  in
    if (succeeded) {
        // The object has been saved.
    } else {
        // There was a problem, check error.description
    }}
    
* Quering liked cooks with Parse
    * let query = PFQuery(className: "FoodScore")
    * query.includeKey("name")
    * query.limit = 20
    * query.findObjectsInBackground{ (posts, error) in
     if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }}
    
* Getting request to Spoontacular api
    * let url = URL(string: "https://api.spoonacular.com/recipes/search&apiKey=a5adb8848cf447679fcce3994122a14f")!
    * let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
    * let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    * let task = session.dataTask(with: request) { (data, response, error) in
 
    * if let error = error {
      print(error.localizedDescription)
   } else if let data = data {
      let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
   }
}
task.resume()
    

* Spoontacular API
    * Base URL: https://api.spoonacular.com

| HTTP Verb | Endpoint | Description |
| -------- | -------- | -------- |
|GET    | /food/menuItems/search   | Get Search Menu Items     |
| GET    | /recipes/search  | Search for food recipes    |
| GET   | recipes/findByIngredients | Search for recipes by ingredients    |
| GET   | /recipes/{id}/nutritionWidget.json| Get a recipe's nutrition widget data.    |
| GET   | /recipes/guessNutrition| Estimate the macronutrients of a dish based on its title.    |
| GET   | /mealplanner/generate| Generate a meal plan with three meals per day (breakfast, lunch, and dinner).    |


* We also used Apple's Vision and Core ML Framework to identify food images.
Preprocess photos using the Vision framework and classify them with a Core ML model.

## App Walkthrough GIF

Here's a walkthrough of implemented user stories:

<img src="http://g.recordit.co/wemNljdIyE.gif" title='Video Walkthrough' width='' alt='Video Walkthrough'/>





















