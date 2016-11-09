//
//  AppDelegate.swift
//  AdvHackerbooks
//
//  Created by jro on 09/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    final var autoSave : Bool = true
    final let autoSaveDelayInSeconds : Int = 13
    
    
    //Creamos una instancia del modelo
    let model = CoreDataStack(modelName: "AdvHackerbooks")!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        Borramos lo ya existente
//        do {
//            try model.dropAllData()
//        }
//        catch let error as NSError {
//            print(error.localizedDescription)
//        }
        
        
        let defaults = UserDefaults.standard
        
        // ************ CLEAR USER DEFAULTS *******************
//        defaults.removeObject(forKey: "JSON_Data")
//                defaults.removeObject(forKey: "lastBook")
        // ****************************************************
        
        
        //Create the window
        window = UIWindow(frame: UIScreen.main.bounds)

        //Execute the download od the data in background
        model.performBackgroundBatchOperation { context in
            if (defaults.value(forKey: "JSON_Data") == nil){
                do {
                    try readJSON(context: context, local: true)
                    try context.save()
                }
                catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
        
        //Create the fetchedRequest
        let req = NSFetchRequest<Book>(entityName: Book.entityName)
        req.returnsDistinctResults = true  //not repeated occurences
        
        let sd = NSSortDescriptor(key: "title", ascending: true)
        req.sortDescriptors = [sd]
        
        //Create the fetchedRequestController
        let reqCtrl = NSFetchedResultsController(fetchRequest: req,
                                                 managedObjectContext: model.context,
                                                 sectionNameKeyPath: nil,
                                                 cacheName: nil)
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            print("Soy un IPHONE")
            
            //Create the viewController
            let VC = BooksTableViewController(fetchedResultsController: reqCtrl as! NSFetchedResultsController<NSFetchRequestResult>, style: .plain)
            
            let sVC = SelectOrderViewController(withBookTableVC: VC)
            
            //Create the navController
            let navVC = UINavigationController(rootViewController: sVC)
            
            //Assign delegate
            VC.delegate = sVC
            sVC.delegate = sVC
            
            //Assign rootViewcontroller
            window?.rootViewController = navVC
            
            
            break
        // It's an iPhone
        case .pad:
            print("Soy un IPAD")
            
            //Create the viewController
            let VC = BooksTableViewController(fetchedResultsController: reqCtrl as! NSFetchedResultsController<NSFetchRequestResult>, style: .plain)
            
            
            let sVC = SelectOrderViewController(withBookTableVC: VC)
            
            
            //Create the navController
            let navVC = UINavigationController(rootViewController: sVC)
            
            
            
//            let def = NSUbiquitousKeyValueStore()
//            let lastBook = def.object(forKey: "lastBook") as! Book
            
            if let lastBook = VC.lastSelectedBook(context: model.context){
                // Creamos un character view controller
                let bookVC = BookViewController(withBook: lastBook)

                // Lo metro dentro de un navigation
                let charNav = UINavigationController(rootViewController: bookVC)
                
                // Creamos el splitView y le endosmos los dos nav
                let splitVC = UISplitViewController()
                splitVC.viewControllers = [navVC, charNav]
                
                // Nav como root view Controller
                window?.rootViewController = splitVC
                
                //Assign delegates
                VC.delegate = bookVC
                bookVC.delegate = VC

            }else{
                // Creamos un character view controller
                let bookVC = CoverBookViewController(nibName: nil, bundle: nil)
                
                // Lo metro dentro de un navigation
                let charNav = UINavigationController(rootViewController: bookVC)
                
                // Creamos el splitView y le endosmos los dos nav
                let splitVC = UISplitViewController()
                splitVC.viewControllers = [navVC, charNav]
                
                // Nav como root view Controller
                window?.rootViewController = splitVC
                
                //Assign delegates
                VC.delegate = bookVC
                bookVC.delegate = VC

            }
            
            
            
            
            break
            
        // It's an iPad
        case .unspecified:
            print("Soy un OTRA COSA")
            break
        default:
            print("Soy un DEFAULT")
            // Uh, oh! What could it be?
        }

        // make an autosave
        self.saveDelayContext()
        
        //Make the window visible
        window?.makeKeyAndVisible()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
          self.saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        self.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
        print("Cagada, no debemos gurdar aqui porque ya no tenemos time enough")
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "AdvHackerbooks")
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

    func saveDelayContext () {
        
        if (self.autoSave){
            //Guardamos cada 13 segundos lo que haya en la pila del Contexto
            self.model.autoSave(self.autoSaveDelayInSeconds)
            
        }
    }
    
    func saveContext(){
        
        // call the CoreDataStack save method (not with delay)
        self.model.save()
    }

}

