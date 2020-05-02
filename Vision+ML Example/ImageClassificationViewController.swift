/*
See LICENSE folder for this sample’s licensing information.
Abstract:
View controller for selecting images and applying Vision + Core ML processing.
*/

import UIKit
import CoreML
import Vision
import ImageIO

class ImageClassificationViewController: UIViewController{
    var food_string = [String]()
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var classificationLabel: UILabel!

    
    @IBOutlet weak var nextButton: UIButton!
    
    

    // MARK: - Image Classification
    
    /// - Tag: MLModelSetup
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `MobileNet` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `MobileNet` with that model's generated Swift class.
             */
            let model = try VNCoreMLModel(for: MobileNet().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage) {
        classificationLabel.text = "Classifying..."
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
//        Create a VNImageRequestHandler object with the image to be processed, and pass the requests to that object's perform(_:) method. This method runs synchronously—use a background queue so that the main queue isn't blocked while your requests execute.
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
   

    
    /// Updates the UI with the results of the classification.
    /// - Tag: ProcessClassifications
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
        
            if classifications.isEmpty {
                self.classificationLabel.text = "Nothing recognized."
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(1)
//                print(topClassifications)
                
                let descriptions = topClassifications.map { classification in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
//                   return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                     return String(classification.identifier)
                }
                self.classificationLabel.text = "Classification:\n" + descriptions.joined(separator: "\n")
                let string_data = descriptions[0]
                let string_data_arr = string_data.characters.split{$0 == ","}.map(String.init)
                print(string_data_arr.count)
                self.food_string = string_data_arr
//                print(string_data_arr[0])
//                print(string_data_arr[1])
//                print(string_data_arr[2])
                let dialogMessage = UIAlertController(title: "Confirm", message: "Did we guess correctly?", preferredStyle: .alert)
                       
                // Create OK button with action handler
                let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                print("Yes button tapped")
                
                           
                })
                       
                // Create Cancel button with action handlder
                let no = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in
                let alert = UIAlertController(title: "Sorry", message: "We are still working on improving our upload photo feature", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                self.nextButton.isHidden = true
                        
                print("No button tapped")
                }
                       
                //Add OK and Cancel button to dialog message
                dialogMessage.addAction(no)
                dialogMessage.addAction(yes)
                       
                       
                // Present dialog message to user
                self.present(dialogMessage, animated: true, completion: nil)

            }
        }
        }
    
    // MARK: - Photo Actions
    
    @IBAction func takePicture() {
        // Show options for the source picker only if the camera is available.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        photoSourcePicker.addAction(takePhoto)
        photoSourcePicker.addAction(choosePhoto)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(photoSourcePicker, animated: true)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is FoodViewController{
        let foodViewController = segue.destination as! FoodViewController
              foodViewController.food_string = food_string

        }else if segue.destination is MealGridViewController{
            let mealGridViewController = segue.destination as! MealGridViewController
            
        }
        
    }
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //           if segue.destination is NutritionViewController{
    //                let nutritionViewController = segue.destination as! NutritionViewController
    //                nutritionViewController.food = food
    //                   nutritionViewController.baseUrlImage = baseUrlImage
    //
    //           } else if segue.destination is CookViewController{
    //                   let cookViewController = segue.destination as! CookViewController
    //                   cookViewController.food = food
    //
    //
    //               }
    //
    //        }
    //
        

    
    
    
    
    
    
}

extension ImageClassificationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Handling Image Picker Selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: true)
        
        // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        updateClassifications(for: image)
    }
}



              
//                let alert = UIAlertController(title: "Did we guess correctly", message: "Please select yes or no", preferredStyle: .alert)
//
//                let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle) { (UIAlertAction) in
//                    print("Yes selected")
//                }
//
//                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
//
//                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                 
//                    self.present(alert, animated: true)

//import UIKit
//import CoreML
//import Vision
//import ImageIO
//
//
//class ImageClassificationViewController: UIViewController {
//    // MARK: - IBOutlets
//
//    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var cameraButton: UIBarButtonItem!
//    @IBOutlet weak var classificationLabel: UILabel!
//
//    // MARK: - Image Classification
//
//    /// - Tag: MLModelSetup
//    lazy var classificationRequest: VNCoreMLRequest = {
//        do {
//            /*
//             Use the Swift class `MobileNet` Core ML generates from the model.
//             To use a different Core ML classifier model, add it to the project
//             and replace `MobileNet` with that model's generated Swift class.
//             */
//            let model = try VNCoreMLModel(for: MobileNet().model)
//
//            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
//                self?.processClassifications(for: request, error: error)
//            })
//            request.imageCropAndScaleOption = .centerCrop
//            return request
//        } catch {
//            fatalError("Failed to load Vision ML model: \(error)")
//        }
//    }()
//
//    /// - Tag: PerformRequests
//    func updateClassifications(for image: UIImage) {
//        classificationLabel.text = "Classifying..."
//
//        let orientation = CGImagePropertyOrientation(image.imageOrientation)
//        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
//            do {
//                try handler.perform([self.classificationRequest])
//            } catch {
//                /*
//                 This handler catches general image processing errors. The `classificationRequest`'s
//                 completion handler `processClassifications(_:error:)` catches errors specific
//                 to processing that request.
//                 */
//                print("Failed to perform classification.\n\(error.localizedDescription)")
//            }
//        }
//    }
//
//    /// Updates the UI with the results of the classification.
//    /// - Tag: ProcessClassifications
//    func processClassifications(for request: VNRequest, error: Error?) {
//        DispatchQueue.main.async {
//            guard let results = request.results else {
//                self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
//                return
//            }
//            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
//            let classifications = results as! [VNClassificationObservation]
//
//            if classifications.isEmpty {
//                self.classificationLabel.text = "Nothing recognized."
//            } else {
//                // Display top classifications ranked by confidence in the UI.
//                let topClassifications = classifications.prefix(2)
//                print(to)
//                let descriptions = topClassifications.map { classification in
//                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
//                   return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
//                }
//                self.classificationLabel.text = "Classification:\n" + descriptions.joined(separator: "\n")
//            }
//        }
//    }
//
//    // MARK: - Photo Actions
//
//    @IBAction func takePicture() {
//        // Show options for the source picker only if the camera is available.
//        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
//            presentPhotoPicker(sourceType: .photoLibrary)
//            return
//        }
//
//        let photoSourcePicker = UIAlertController()
//        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
//            self.presentPhotoPicker(sourceType: .camera)
//        }
//        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
//            self.presentPhotoPicker(sourceType: .photoLibrary)
//        }
//
//        photoSourcePicker.addAction(takePhoto)
//        photoSourcePicker.addAction(choosePhoto)
//        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        present(photoSourcePicker, animated: true)
//    }
//
//    func presentPhotoPicker(sourceType: UIImagePickerControllerSourceType) {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = sourceType
//        present(picker, animated: true)
//    }
//}
//
//extension ImageClassificationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    // MARK: - Handling Image Picker Selection
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
//        picker.dismiss(animated: true)
//
//        // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        imageView.image = image
//        updateClassifications(for: image)
//    }
//}
