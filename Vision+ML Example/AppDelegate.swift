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
        
        Parse.initialize(
                 with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
                     configuration.applicationId = "sea"
                     configuration.server = "https://sealifestyle.herokuapp.com/parse"
                 })
             )
        return true
    }
    
}
