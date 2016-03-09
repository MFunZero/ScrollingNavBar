//
//  ChoseSpecialTableViewController.swift
//  Originality
//
//  Created by suze on 16/2/16.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class ChoseSpecialTableViewController: UITableViewController {

    var singlePictureInfo:SinglePictureInfo!
    var specials:[SpecialInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = bgColor
        //self.tableView.backgroundColor = contentColor
        
        print("spscount:\(specials?.count)")
        
        
        self.title = "选择专辑"
        let leftButton = UIBarButtonItem(image: UIImage(named: "cancel"), style: UIBarButtonItemStyle.Done, target: self, action: "back:")
        
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.leftBarButtonItem?.tintColor = titleCorlor
        
        self.tableView.registerClass(PersonTableViewCell.self, forCellReuseIdentifier: "cell")
       
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notificationAction:", name: "NotificationIdentifier", object: nil);
        
        
        
    }
    
    
    
    func notificationAction(fication : NSNotification){
        
        let query = BmobQuery(className: "special")
        
        var specials:[SpecialInfo] = []
        
        query.includeKey("userId,categoryId")
        
        query.whereKey("userId", equalTo: currentUser)
        query.findObjectsInBackgroundWithBlock { (objs, error) -> Void in
            if error != nil {
                NSLog("specialQuery:\(error)")
            }
            else {
                for obj in objs {
                    let special = SpecialInfo()
                    special.objectId = obj.objectId
                    special.title = obj.objectForKey("title") as? String
                    
                    if let picture = obj.objectForKey("mainPicture") as? String {
                        special.pictureName = picture as? String
                    }
                    else {
                        special.pictureName = defaultImage
                    }
                    
                    if let account = obj.objectForKey("count") {
                        special.count = account as? Int
                    }
                    else {
                        special.count = 0
                    }
                    
                    let user:BmobUser = obj.objectForKey("userId") as! BmobUser
                    special.userId = user.objectId
                    
                    //获取专辑信息
                    let category:BmobObject = obj.objectForKey("categoryId") as! BmobObject
                    special.categoryId = category.objectId
                    
                    specials.append(special)
                }
                
                self.specials = specials
        
            }
        }
        self.tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let specialsCount = self.specials?.count {
            return specialsCount + 1
        }
        else {
        return 1
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       
            return 0.01
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PersonTableViewCell

        if indexPath.row == 0 {
            cell.picture.image = UIImage(named: "add_photo")
            cell.titleLabel.text = "创建专辑"
        }
        else {
            
            if defaultImage == self.specials![indexPath.row - 1].pictureName {
                cell.picture.image = UIImage(named: defaultImage)
                cell.titleLabel.text = self.specials![indexPath.row - 1].title
            }
            else {
                cell.pictureName = self.specials![indexPath.row - 1].pictureName
                cell.titleLabel.text = self.specials![indexPath.row - 1].title
                
            }
        }
        // Configure the cell...

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
   
        print("row:\(indexPath.row)")
        if indexPath.row == 0{
            let vc = CreateSpecialViewController()
            let nav = UINavigationController(rootViewController: vc)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            
            if self.singlePictureInfo == nil{
                
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName("Notification", object: nil, userInfo: ["specialId":self.specials![indexPath.row].objectId])
                })
            }
            else {
            
      
            let collectionUserId = currentUser
            
            let chosedSpecial = self.specials![indexPath.row-1]
            let chosedSpecialId = chosedSpecial.objectId
            
            let objSpecial = BmobObject(withoutDatatWithClassName: "special", objectId: chosedSpecialId)
            let objSinglePicture = BmobObject(withoutDatatWithClassName: "SinglePicture", objectId: self.singlePictureInfo.objectId)
            let user = BmobObject(withoutDatatWithClassName: "_User", objectId: collectionUserId)
          
            
            var collectionArray = self.singlePictureInfo?.collection == nil ? Array<NSDictionary>() : singlePictureInfo!.collection
            
            for cl in collectionArray {
                if cl.objectForKey("specialId") as? String == self.singlePictureInfo.objectId {
                    let tip = UIAlertView(title: nil, message: "已被此专辑收藏", delegate: self, cancelButtonTitle: "cancel")
                    tip.show()
                    return
                }
            }
      
            let obj = BmobObject(className: "collection")
            obj.setObject(objSinglePicture, forKey: "spId")
            obj.setObject(objSpecial, forKey: "specialId")
            obj.setObject(user, forKey: "userId")
            
            obj.saveInBackgroundWithResultBlock({ (isSuccessful, error) -> Void in
                
                if isSuccessful {
                    NSLog("comment:\(obj)")
                    let commentId = obj.objectId
                    
                    //[{"userId":"bPVX555A","specialId":"bPVX555A","collectionId":"7BvcFFFY"},{"userId":"7X51IIIZ","specialId":"z4TvDDDI","collectionId":"kNTBFFFR"}]
                    
                    let dict = NSDictionary(objects: [collectionUserId,commentId,chosedSpecialId], forKeys: ["userId","collectionId","specialId"])
                    //let array = Array(object: dict)
                    
                    collectionArray.insert(dict, atIndex: collectionArray.count)
                    
                    let comentObject = BmobObject(withoutDatatWithClassName: "SinglePicture", objectId: self.singlePictureInfo?.objectId)
                    comentObject.setObject(collectionArray, forKey: "collection")
                    comentObject.updateInBackgroundWithResultBlock({ (isSuccessful, error) -> Void in
                        if isSuccessful {
                            print("收藏成功")
                            
                            self.singlePictureInfo?.collection = collectionArray
                            self.singlePictureInfo?.collectionCount = collectionArray.count
                            
                            
                            let specialObject = BmobObject(withoutDatatWithClassName: "special", objectId: chosedSpecialId)
                            specialObject.setObject(chosedSpecial.count + 1, forKey: "count")
                            specialObject.updateInBackground()

                            
                            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                                NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier", object: nil)
                            })
                        }
                        else {
                            let tip = UIAlertView(title: nil, message: "收藏失败", delegate: self, cancelButtonTitle: "cancel")
                            tip.show()
                            print("error:\(error)")
                        }
                    })
                }
                else {
                    let tip = UIAlertView(title: nil, message: "收藏失败，请重试", delegate: self, cancelButtonTitle: "cancel")
                    tip.show()
                    print("collectionArray:\(error)")
                }
                
            })
            
        }
            
        }
       
    }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


extension ChoseSpecialTableViewController{
    
    func back(sender:UIBarButtonItem)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
