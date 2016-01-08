//
//  ViewController.swift
//  ScrollingNavBar
//
//  Created by suze on 15/10/18.
//  Copyright © 2015年 suze. All rights reserved.
//

import UIKit
import AMScrollingNavbar
import Alamofire
class ViewController: UITableViewController ,ScrollingNavigationControllerDelegate  {

    //var childNavTitle:String = ""
    var listData:NSDictionary?
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData!.count
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destViewController : NowPlayingViewController = segue.destinationViewController as! NowPlayingViewController
        if (segue.identifier == "detail") {
          
 
             if let indexPath = self.tableView.indexPathForSelectedRow {
               let dict = self.listData![indexPath.row] as! NSDictionary
               // destViewController.song = dict["song"] as? String
                destViewController.title = dict["title"] as? String
            }
        }
    
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:detailCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! detailCellTableViewCell
        //cell.backgroundColor = UIColor.grayColor()
        
      //  print(self.listData)
        let dict = self.listData![indexPath.row] as! NSDictionary//as改为as!
        cell.Song?.text = dict["title"] as? String //as改为as?,NSString改为String
        let str:String = dict["singer"] as! String
        let str1:String = dict["mv"] as! String
        cell.Details?.text = str+"-"+str1
        
        let path = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Collections.plist")
        let data = NSDictionary(contentsOfFile:path)
        
        print("\(NSHomeDirectory())")
        
        if data?[(cell.Song?.text)!] != nil {
            print(cell.Song?.text)
            cell.statusShouchang = true
            cell.Shoucang.image = UIImage(named: "shoucang1")
        } else {
            cell.statusShouchang = false
            cell.Shoucang.image = UIImage(named: "shoucang")

        }
        //as改为as?,NSString改为/Users/suzeepp/Documents/SwiftCode/ScrollingNavBar/ScrollingNavBar/detailCellTableViewCell.swiftString
        
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request(.GET, "http://music.qq.com/musicbox/shop/v3/data/hit/hit_newsong.js", parameters: nil)
            .response { (request, response, data, error) in
                print(request)
                //self.listData = ["songlist"] as? NSDictionary
                print(response)
                print(error)
        }
//        Alamofire.request(.POST, "http://music.qq.com/musicbox/shop/v3/data/hit/hit_newsong.js", parameters: nil, encoding: .JSON(options: nil))
//            .responseJSON {(request, response, JSON, error) in
//                println(JSON)
//                self.listData = JSON
//        }
        
        
        
        NSUserDefaults.standardUserDefaults().registerDefaults(["firstLaunch":true])
        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("firstLaunch")
        if firstLaunch{
            print("firstLaunch")
            //设置plist文件中的值
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "firstLaunch")
            
            let path = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Collections.plist")
            let data = NSDictionary()
            data.writeToFile(path, atomically: true)

        } else {
            print("no  firstLaunch")
        }
        
        
        
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.orangeColor()
        self.navigationItem.title = "新歌榜"
        //self.view.backgroundColor = UIColor.blueColor()
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.scrollingNavbarDelegate = self
        }
        
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadView:", name: "reloadViewNotification", object: nil)
    let parser = Processing()
    NSLog("解析开始")
    parser.start()
}

func reloadView(notification : NSNotification){
    let reslist = notification.object as! NSDictionary
    print(reslist)
    self.listData = reslist
    self.tableView.reloadData()
}

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.stopFollowingScrollView()
        }
    }
    func scrollingNavigationController(controller: ScrollingNavigationController, didChangeState state: NavigationBarState) {
        switch state {
        case .Collapsed:
            print("navbar collapsed")
        case .Expanded:
            print("navbar expanded")
        case .Scrolling:
            print("navbar is moving")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

