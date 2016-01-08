//
//  ViewController.swift
//  persist
//
//  Created by suze on 15/11/13.
//  Copyright © 2015年 suze. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.archiver()
        
        let appDeletegate:AppDelegate = AppDelegate.sharedAppDelete()
        let managedObjectContext:NSManagedObjectContext = appDeletegate.managedObjectContext
        
        let managedObject:NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext: managedObjectContext)
        managedObjectContext.setValue("ios", forKey: "name")
        managedObjectContext.setValue(12, forKey: "age")
        managedObjectContext.setValue(1, forKey: "sex")
        
        
        
        
        let request:NSFetchRequest = NSFetchRequest()
        let book:NSEntityDescription = NSEntityDescription.entityForName("Person", inManagedObjectContext: appDeletegate.managedObjectContext)!
        request.entity = book
        do{
            let objects = try  appDeletegate.managedObjectContext.executeFetchRequest(request)
            for obj in objects {
                obj.setValue("hihihihi", forKey: "name")
            }
            
        }catch {
         print("exception")
        }
        
        
        
        appDeletegate.saveContext()
        
    }

    
    func archiver(){
        
        let book:Book = Book()
        book.name = "sence"
        book.writer = "suze"
        book.writeDate = NSDate()
        
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(book, forKey: "sence")
        archiver.finishEncoding()
        
        
        let writePath = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("sence.data")
        data.writeToFile(writePath, atomically: true)
        
        
        
        let readData = NSData(contentsOfFile: writePath)
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: readData!)
        let bookRead = unarchiver.decodeObjectForKey("sence")
        print("\(bookRead?.name)")
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


