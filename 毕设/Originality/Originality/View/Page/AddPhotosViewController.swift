//
//  AddPhotosViewController.swift
//  Originality
//
//  Created by suze on 16/2/18.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class AddPhotosViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var addPhotoButton:UIButton!
    var chosePhotoButton:UIButton!
    
    var cancelButton:UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        configForView()
        // Do any additional setup after loading the view.
    }
    
    func configForView()
    {
        let imageBG = UIImageView(frame: self.view.frame)
        imageBG.image = UIImage(named: img_login)
        self.view.addSubview(imageBG)
        
        
        cancelButton = UIButton(frame: CGRect(x: screenWidth - 30, y: 30, width: 20, height: 20))
        self.view.addSubview(cancelButton)
        cancelButton.setBackgroundImage(UIImage(named: "cancel"), forState: .Normal)
        cancelButton.addTarget(self, action: "userClick:", forControlEvents: .TouchUpInside)
        cancelButton.tintColor = contentColor
        
        let splitView = UIView(frame: CGRect(x: 40, y: screenHeight / 2, width: screenWidth - 80, height: 1))
        splitView.backgroundColor = maincolor
        self.view.addSubview(splitView)
        
        addPhotoButton = UIButton(frame: CGRect(x: splitView.frame.origin.x, y: splitView.frame.origin.y - 100, width:  splitView.frame.width, height: 100))
        //addPhotoButton.backgroundColor = contentColor
        addPhotoButton.layer.cornerRadius = 4.0
        addPhotoButton.setTitle("上传图片", forState: .Normal)
        addPhotoButton.setTitleColor(contentColor, forState: .Normal)
        addPhotoButton.addTarget(self, action: "loginButtonClick:", forControlEvents: .TouchUpInside)
        
        let subImageView = UIImageView(frame: CGRect(x: 10, y: 20, width: 60, height: 60))
        subImageView.image = UIImage(named: photo)
        addPhotoButton.addSubview(subImageView)
        
        self.view.addSubview(addPhotoButton)
        
        
        
        chosePhotoButton = UIButton(frame: CGRect(x: splitView.frame.origin.x, y: splitView.frame.origin.y, width:  splitView.frame.width, height: 100))
        
        //regesiterButton.alpha = 0.3
        chosePhotoButton.setTitle("拍照上传", forState: .Normal)
        chosePhotoButton.setTitleColor(contentColor, forState: .Normal)
        chosePhotoButton.addTarget(self, action: "regesiterButtonClick:", forControlEvents: .TouchUpInside)
        let subView = UIImageView(frame: CGRect(x: 10, y: 20, width: 60, height: 60))
        subView.image = UIImage(named: camer)
        chosePhotoButton.addSubview(subView)
        
        self.view.addSubview(chosePhotoButton)
        
    }
    
    
    func loginButtonClick(sender:UIButton)
    {
        let page = UIImagePickerController()
        
        page.delegate = self
        
        page.sourceType = .PhotoLibrary
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            
            
            
            page.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            
            
            page.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(page.sourceType)!
            
            
        }
        
        
        self.presentViewController(page, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        print("choose--------->>")
        
        
        
        print(info)
        
        
        
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let editPage = EditPhotoViewController()
        
        let nav = UINavigationController(rootViewController: editPage)
        
       
       
        
        editPage.photoView.image = img
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        self.presentViewController(nav, animated: true, completion: nil)
        
        
        
        
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        let editPage = EditPhotoViewController()
        
        
        editPage.photoView.image = image
        
        
        picker.pushViewController(editPage, animated: true)
    }
    
    
    
    func userClick(sender:UIButton)
    {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func regesiterButtonClick(sender:UIButton)
    {
        let page = UIImagePickerController()
        
        page.delegate = self
        
        page.sourceType = .Camera
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            
            
            
            page.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            
        }
        let mediaTypeArr:NSArray = UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.Camera)!
        
        page.mediaTypes = mediaTypeArr  as! [String]
        //必须，第三步，设置delegate：UIImagePickerControllerDelegate,UINavigationControllerDelegate
        //这两个必须都写上，可以进入头文件查看到
        page.delegate = self
        
        //可选，视频最长的录制时间，这里是10秒，默认为10分钟（600秒）
        page.videoMaximumDuration = 10
        //可选，设置视频的质量，默认就是TypeMedium
        page.videoQuality = UIImagePickerControllerQualityType.TypeMedium
        //设置视频或者图片拍摄好后，是否能编辑，默认为false不能编辑
        //page.allowsEditing = true
        
        
        
        self.presentViewController(page, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
