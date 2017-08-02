import UIKit

class ViewControllerMain: UITableViewController
{
    @IBOutlet weak var mActionButton: UIBarButtonItem!
    @IBOutlet weak var mMenuButton: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("page_title_main",comment: "")
        mActionButton.title = NSLocalizedString("button_add",comment: "")
        mMenuButton.title = NSLocalizedString("button_menu",comment: "")
        self.navigationController?.navigationBar.barTintColor = PURE_BLACK_500
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationController?.toolbar.tintColor = PURE_BLACK_500
        //隐藏空白项
        self.tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }
    
    @IBAction func addAction(_ sender: Any)
    {
        //创建对话框
        let alert = UIAlertController(title: NSLocalizedString("page_title_task_add",comment: ""), message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField (configurationHandler:
            {
                textField -> Void in
                textField.placeholder = NSLocalizedString("content",comment: "")
        })
        //设置按钮
        let positiveAction = UIAlertAction(title: NSLocalizedString("button_ok",comment: ""), style: UIAlertActionStyle.default, handler:
        {
            alertAction -> Void in
            print("ok")
        })
        let negativeAction = UIAlertAction(title: NSLocalizedString("button_cancel",comment: ""), style: UIAlertActionStyle.cancel, handler: nil)
        //装载
        alert.addAction(positiveAction)
        alert.addAction(negativeAction)
        //弹起
        self.present( alert, animated: true, completion: nil)
    }
    
}
