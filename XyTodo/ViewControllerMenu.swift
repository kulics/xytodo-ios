//
//  ViewControllerMenu.swift
//  XyKey
//
//  Created by 吴森 on 15/11/22.
//  Copyright © 2015年 naxy. All rights reserved.
//

import UIKit

class ViewControllerMenu: UITableViewController, ProtocolHomeChange
{
    var delegate: ProtocolHomeChange?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("button_menu",comment: "")
    }
    
    func updateHome() {
        delegate?.updateHome()
    }
    
    @IBAction func actionBack(_ sender : Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showSetting"
        {
            let tempVC = segue.destination as! ViewControllerSetting
            tempVC.delegate = self
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var num = 0
        switch section
        {
            case 0:
                num = 1
            case 1:
                num = 3
            default:
                num = 0
        }
        return num
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:UITableViewCell
        switch (indexPath as NSIndexPath).section
        {
            case 0:
                switch (indexPath as NSIndexPath).row
                {
                    case 0:
                        cell = tableView.dequeueReusableCell(withIdentifier: "cellSetting", for: indexPath)
                        cell.textLabel?.text = NSLocalizedString("page_title_settings",comment: "")
                    default:
                        cell = tableView.dequeueReusableCell(withIdentifier: "cellAbout", for: indexPath)
                }
            case 1:
                switch (indexPath as NSIndexPath).row
                {
                    case 0:
                        cell = tableView.dequeueReusableCell(withIdentifier: "cellAbout", for: indexPath)
                        cell.textLabel?.text = NSLocalizedString("page_title_about_app",comment: "")
                    case 1:
                        cell = tableView.dequeueReusableCell(withIdentifier: "cellGuide", for: indexPath)
                        cell.textLabel?.text = NSLocalizedString("page_title_guide",comment: "")
                    case 2:
                        cell = tableView.dequeueReusableCell(withIdentifier: "cellContactUs", for: indexPath)
                        cell.textLabel?.text = NSLocalizedString("page_title_contact_us",comment: "")
                    default:
                        cell = tableView.dequeueReusableCell(withIdentifier: "cellAbout", for: indexPath)
                }
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: "cellAbout", for: indexPath)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
