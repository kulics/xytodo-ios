import UIKit
//指南页面
class ViewControllerGuide: UITableViewController 
{
    //初始化
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        //设置属性
        self.navigationItem.title = NSLocalizedString("page_title_guide",comment: "")
        
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
        //隐藏空白项
        self.tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() 
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //监听返回按钮
    @IBAction func actionBack(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int 
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int 
    {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTextView", for: indexPath) as! TableViewCellTextView
        cell.tvContent.text = NSLocalizedString("longstr_guide",comment: "")
        
        return cell
    }
    
}

