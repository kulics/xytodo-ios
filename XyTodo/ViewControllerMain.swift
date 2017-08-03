import UIKit

protocol ProtocolHomeChange
{
    func updateHome()
}

class ViewControllerMain: UITableViewController, UIPopoverPresentationControllerDelegate, ProtocolHomeChange
{
    @IBOutlet weak var mActionButton: UIBarButtonItem!
    @IBOutlet weak var mMenuButton: UIBarButtonItem!
    
    var mApp: AppDelegate!
    var mDataset: [ModelTask] = []
    var mFilter = "today"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //获取本地数据
        mApp = UIApplication.shared.delegate as? AppDelegate
        
        
        self.navigationItem.title = NSLocalizedString("page_title_main",comment: "")
        mActionButton.title = NSLocalizedString("button_add",comment: "")
        mMenuButton.title = NSLocalizedString("button_menu",comment: "")
        self.navigationController?.navigationBar.barTintColor = PURE_BLACK_500
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationController?.toolbar.tintColor = PURE_BLACK_500
        //隐藏空白项
        self.tableView.tableFooterView = UIView()
        
        setDataset()
    }
    //设置数据
    func setDataset()
    {
        mDataset = mApp.DBMGet().TaskGetAll(param: mFilter)
        tableView.reloadData()
    }
    //刷新数据
    func updateHome()
    {
        setDataset()
    }
    
    //监听跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
//        if segue.identifier == "showKeyView"
//        {
//            let indexPath:IndexPath = self.tableView!.indexPathForSelectedRow!
//            let tempVC = segue.destination as! ViewControllerKeyView
//            tempVC.mID = mSectionArray[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row].id
//            tempVC.delegate = self
//        }
//        if segue.identifier == "showKeyAdd"
//        {
//            let tempVC = segue.destination as! ViewControllerKeyAdd
//            tempVC.delegate = self
//        }
        if segue.identifier == "showMenu"
        {
            let tempVC = segue.destination as! ViewControllerMenu
            tempVC.delegate = self
        }
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return mDataset.count
    }
    
    //装载条目信息
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTask", for: indexPath) as! TableViewCellTask
        //获取数据
        let item = mDataset[indexPath.row]
        if item.status == 1 //根据状态不同设置不同显示
        {
            cell.vCard.backgroundColor = PURE_GRAY_500
            cell.cbTag.color = PURE_GRAY_500
            cell.cbTag.setOn(on: true, animated: false)
            cell.lbContent.attributedText = NSMutableAttributedString(string: item.content, attributes: [NSStrikethroughStyleAttributeName :1])
            cell.lbTime.attributedText = NSMutableAttributedString(string: ToolFunction.GetDateFromUTC(time: item.timeTarget), attributes: [NSStrikethroughStyleAttributeName :1])
        }
        else
        {
            cell.vCard.backgroundColor = PURE_BLUE_500
            cell.cbTag.color = PURE_GRAY_500
            cell.cbTag.setOn(on: false, animated: false)
            cell.lbContent.text = item.content
            cell.lbTime.text = ToolFunction.GetDateFromUTC(time: item.timeTarget)
        }
        
        cell.cbTag.checkboxClickBlock = { isOn in
            let b = isOn ? 1 : 0
            //必须先对当前状态做判断，因为每次装填都会触发事件，这里需要过滤
            if item.status != b {
                item.status = b
                //获取时间
                let time = Int(NSDate().timeIntervalSince1970)
                item.timeDone = time
                self.mApp.DBMGet().TaskCheck(model: item)
                //UpdateTag()
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        return cell
    }
    //列表点击方法
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool
    {
        return false
    }
    
    // 设置 cell 是否允许移动
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    // 移动 cell 时触发
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        // 移动cell之后更换数据数组里的循序
        let dataSource = self.mDataset[sourceIndexPath.row]
        let dataDestination = self.mDataset[destinationIndexPath.row]
        self.mDataset.remove(at: sourceIndexPath.row)
        self.mDataset.insert(dataSource, at: destinationIndexPath.row)
        
        //保存到数据库
        let selectPosition = dataSource.timeSort
        let targetPosition = dataDestination.timeSort
        dataSource.timeSort = targetPosition
        mApp.DBMGet().TaskPosition(model: dataSource);
        dataDestination.timeSort = selectPosition
        mApp.DBMGet().TaskPosition(model: dataDestination);
    }
    
    @IBAction func actionSort(_ sender: Any)
    {
        // 开启编辑模式
        self.tableView.isEditing = !self.tableView.isEditing
    }
    
    @IBAction func actionAdd(_ sender: Any)
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
            let text = alert.textFields![0].text
            if text!.characters.count > 0
            {
                let model = ModelTask()
                model.content = text!
                model.note = ""
                model.color = "blue"
                //获取时间
                let time = Int(NSDate().timeIntervalSince1970)
                model.timeCreate = time
                model.timeTarget = model.timeCreate
                model.timeDone = 0
                model.timeSort = model.timeCreate
                model.status = 0
                let id = self.mApp.DBMGet().TaskAdd(model: model)
                //必须向tableView的数据源数组中相应的添加一条数据
                self.mDataset.insert(self.mApp.DBMGet().TaskGet(id: id), at: 0)
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                self.tableView.endUpdates()
                self.tableView.scrollsToTop = true
            }
        })
        let negativeAction = UIAlertAction(title: NSLocalizedString("button_cancel",comment: ""), style: UIAlertActionStyle.cancel, handler: nil)
        //装载
        alert.addAction(positiveAction)
        alert.addAction(negativeAction)
        //弹起
        self.present( alert, animated: true, completion: nil)
    }
    
    @IBAction func actionFilter(_ sender: Any)
    {
        //转化成按钮
        let btn = sender as! UIBarButtonItem
        //设置弹出菜单
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewControllerPopMenu") as! ViewControllerPopMenu
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        //菜单文本
        vc.menus = [
            NSLocalizedString("today", comment: ""),
            NSLocalizedString("all",comment: ""),
            NSLocalizedString("todo",comment: ""),
            NSLocalizedString("done",comment: "")
        ]
        //监听事件
        vc.addAction(handler:
        {
                (num) in
                switch num
                {
                    case 0:
                        self.mFilter = "today"
                    case 1:
                        self.mFilter = "all"
                    case 2:
                        self.mFilter = "todo"
                    case 3:
                        self.mFilter = "done"
                    default:
                        self.mFilter = "today"
                        break
                }
                self.setDataset()
        })
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        //对齐位置
        popover.barButtonItem = btn
        popover.delegate = self
        //弹出
        self.present(vc, animated: true, completion: nil)
    }
    
    //更改菜单弹窗风格
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.none
    }
}




