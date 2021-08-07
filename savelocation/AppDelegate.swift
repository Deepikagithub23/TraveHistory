//
//  AppDelegate.swift
//  savelocation
//
//  Created by Deepika B on 04/08/21.
//

import UIKit
import CoreData
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
    var window: UIWindow?
    var locationManager = CLLocationManager()
    let DBName = "Locationsaving"
    var Timing = 0
    var data = [NSManagedObject]()
    var lastLocation = ""
    var n = 60 * 10 //sec
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        self.startLocationService()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // createLocation()
    
        _ = Timer.scheduledTimer(timeInterval: TimeInterval(n), target: self, selector: #selector(createLocation), userInfo: nil, repeats: true)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // createLocation()
       
        _ = Timer.scheduledTimer(timeInterval: TimeInterval(n), target: self, selector: #selector(createLocation), userInfo: nil, repeats: true)
    }
    
    @objc private func createLocation(){
        let context = persistentContainer.viewContext
        let location = Location(context: context)
        location.currentlocation = lastLocation
        location.time = Date()
        
        do {
            try context.save()
        } catch  {
            debugPrint("Creation of User failed")
        }
    }
    func startLocationService(){
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            if #available(iOS 14.0, *) {
                switch locationManager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    
                @unknown default:
                    break
                }
            } else {
                if CLLocationManager.locationServicesEnabled() {
                    switch CLLocationManager.authorizationStatus() {
                    case .notDetermined, .restricted, .denied:
                        print("No access")
                    case .authorizedAlways, .authorizedWhenInUse:
                        print("Access")
                    }
                } else {
                    print("Location services are not enabled")
                }
            }
        } else {
            print("Location services are not enabled")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Get Location")
        let locationArray = locations as NSArray
        let newLocation = locationArray.lastObject as! CLLocation
        let coordinate = newLocation.coordinate
        
        let tempCoor = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let lat = tempCoor.latitude
        let lon = tempCoor.longitude
        insert(lat:lat, lon: lon)
    }
    
    
    func insert(lat: Double, lon: Double){
        print("\(lat)/\(lon)")
        let cityCoords = CLLocation(latitude: lat, longitude: lon)
        self.getAdressName(coords: cityCoords)
        
    }
    private func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        self.locationManager.stopUpdatingLocation()
        
        if (error) != nil {
            print(error as Any)
        }
    }
    
    func getAdressName(coords: CLLocation) {
        
        CLGeocoder().reverseGeocodeLocation(coords) { (placemark, error) in
            if error != nil {
                print("Hay un error")
            } else {
                
                let place = placemark! as [CLPlacemark]
                if place.count > 0 {
                    let place = placemark![0]
                    var adressString : String = ""
                    if place.thoroughfare != nil {
                        adressString = adressString + place.thoroughfare! + ", "
                    }
                    if place.subThoroughfare != nil {
                        adressString = adressString + place.subThoroughfare! + "\n"
                    }
                    if place.locality != nil {
                        adressString = adressString + place.locality! + " - "
                    }
                    if place.postalCode != nil {
                        adressString = adressString + place.postalCode! + "\n"
                    }
                    if place.subAdministrativeArea != nil {
                        adressString = adressString + place.subAdministrativeArea! + " - "
                    }
                    if place.country != nil {
                        adressString = adressString + place.country!
                    }
                    
                    print(adressString)
                    self.lastLocation = adressString
                    
                    
                }
            }
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "savelocation")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

