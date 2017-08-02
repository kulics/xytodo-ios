//
//  ViewControllerAbout.swift
//  XyKey
//
//  Created by 吴森 on 15/7/16.
//  Copyright (c) 2015年 naxy. All rights reserved.
//

import UIKit
//关于页面
class ViewControllerAbout: UIViewController
{
    
    @IBOutlet weak var lbAppName: UILabel!
    @IBOutlet weak var lbVersion: UILabel!
    @IBOutlet weak var lbDevloper: UILabel!
    
    @IBOutlet weak var btnOfficialWebsite: UIButton!

    //初始化
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        设置ui属性
        //self.navigationItem.hidesBackButton = true
        self.navigationItem.title = NSLocalizedString("page_title_about_app",comment: "")
        lbAppName.text = NSLocalizedString("app_name",comment: "")
        lbVersion.text = NSLocalizedString("about_version",comment: "")
        lbDevloper.text = NSLocalizedString("about_developer",comment: "")
        
        btnOfficialWebsite.setTitle(NSLocalizedString("about_official_website",comment: ""), for: .normal) 
    }
    
//    override func viewWillAppear(animated: Bool)
//    {
//        self.navigationController?.navigationBar.tintColor = PURE_NORMAL_RED
//        self.navigationController?.toolbar.tintColor = PURE_NORMAL_RED
//    }
//    
//    override func viewWillDisappear(animated: Bool)
//    {
//        self.navigationController?.navigationBar.tintColor = PURE_NORMAL_GREEN
//        self.navigationController?.toolbar.tintColor = PURE_NORMAL_GREEN
//    }
    //监听返回动作
    @IBAction func backAction(_ sender : Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func urlAction(_ sender: Any) 
    {
        let url:URL = URL(string:NSLocalizedString("about_website",comment: ""))!
        UIApplication.shared.open(url, options: [:], completionHandler:{ (b) in})
    }
}
