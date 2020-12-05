/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Contains the application's delegate.
*/

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let parseConfig = ParseClientConfiguration {
                    $0.applicationId = "MBz0m8FmvD69LZV2ZxMChevTI99VKf58a5Q6arVH" // <- UPDATE
                    $0.clientKey = "cd38boq7llo6WdZCpvR1D0oIcQLiUxNnWMl8SYJ6" // <- UPDATE
                    $0.server = "https://parseapi.back4app.com"
            }
            Parse.initialize(with: parseConfig)
//        Parse.initialize(
//                 with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
//                     configuration.applicationId = "sea"
//                     configuration.server = "https://sealifestyle.herokuapp.com/parse"
//                 })
//             )
        return true
    }
    
}
