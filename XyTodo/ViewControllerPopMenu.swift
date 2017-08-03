import UIKit
//弹窗菜单
class ViewControllerPopMenu: UITableViewController
{
    var menus: [String] = [] //菜单名
    var actionPositive: ((Int)->Void)? //监听方法
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //确定最长的文字
        var longstring = ""
        for item in menus
        {
            if item.lengthOfBytes(using: .utf8) > longstring.lengthOfBytes(using: .utf8)
            {
                longstring = item
            }
        }
        //创建文本
        let lb = UILabel()
        lb.frame = CGRect(x:0,y:0, width:100,height:100)
        lb.text = longstring
        //让文本框自适应文字的长度
        lb.sizeToFit()
        let width = Int(lb.bounds.size.width)
        //计算弹窗大小
        self.preferredContentSize = CGSize(width: width + 40, height: 44 * menus.count)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func addAction(handler: @escaping (_ num:Int)->())
    {
        self.actionPositive = handler
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menus.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMenu", for: indexPath) as! TableViewCellMenu
        let str = menus[indexPath.row]
        cell.lbTitle.text = str
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //响应点击方法
        self.actionPositive?(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        //退出弹窗
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
}

