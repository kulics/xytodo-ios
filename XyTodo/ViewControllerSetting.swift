import UIKit

class ViewControllerSetting: UITableViewController
{
    var delegate: ProtocolHomeChange?
    
    var mApp: AppDelegate!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("page_title_settings",comment: "")
        
        //获取本地数据
        mApp = UIApplication.shared.delegate as? AppDelegate
        
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func actionBack(_ sender : Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var num = 0
        switch section
        {
            case 0:
                num = 1
            default:
                num = 0
        }
        return num
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var basecell:UITableViewCell

        switch (indexPath as NSIndexPath).section
        {
            case 0:
                switch (indexPath as NSIndexPath).row
                {
                    case 0:
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cellColumn", for: indexPath) as! TableViewCellColumn
                        cell.lbColumnTitle?.text = NSLocalizedString("column_clear_data",comment: "")
                        cell.lbColumnSub?.text = NSLocalizedString("column_clear_data_sub",comment: "")
                        basecell = cell
                    default:
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cellColumn", for: indexPath) as! TableViewCellColumn
                        basecell = cell
                }
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellColumn", for: indexPath) as! TableViewCellColumn
                basecell = cell
        }
        return basecell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        //读取锁定设置
        //let defaults = UserDefaults.standard
        //let bLock = defaults.bool(forKey: "lock_mode")
        
        switch (indexPath as NSIndexPath).row 
        {
            case 0:
                //创建对话框
                let alert = UIAlertController(title: NSLocalizedString("dialog_title_clear_data",comment: ""), message: NSLocalizedString("dialog_content_clear_data",comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                //设置按钮
                let positiveAction = UIAlertAction(title: NSLocalizedString("button_ok",comment: ""), style: UIAlertActionStyle.destructive) 
                { 
                    (action) -> Void in
                    self.mApp.DBMGet().DBClear()
                    self.delegate?.updateHome()
                    // 没有错误消息抛出
//                    self.delegate?.changeKey()
                    _ = self.navigationController?.popViewController(animated: true)
                }
                let negativeAction = UIAlertAction(title: NSLocalizedString("button_cancel",comment: ""), style: UIAlertActionStyle.cancel, handler: nil)
                //装载
                alert.addAction(positiveAction)
                alert.addAction(negativeAction)
                //弹起
                self.present( alert, animated: true, completion: nil)
            default:
                break
        }
    }
}
