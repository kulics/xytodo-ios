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
        //清空数据
        mDataset = []
        let dataset = mApp.DBMGet().TaskGetAll(param: mFilter)
        if mFilter == "today"
        {
            //遍历添加进数据集
            for v in dataset
            {
                if ToolFunction.ComputeDateToday(time: v.timeTarget)
                {
                    mDataset.append(v)
                }
            }
        }
        else
        {
            //添加进数据集
            mDataset = dataset
        }
        
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
        if segue.identifier == "showTaskEdit"
        {
            let indexPath:IndexPath = self.tableView!.indexPathForSelectedRow!
            let tempVC = segue.destination as! ViewControllerTaskEdit
            tempVC.mID = mDataset[(indexPath as NSIndexPath).row].id
            tempVC.delegate = self
        }
        if segue.identifier == "showTaskAdd"
        {
            let tempVC = segue.destination as! ViewControllerTaskAdd
            tempVC.delegate = self
        }
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
            cell.vCard.backgroundColor = colorGet(color: item.color)
            cell.cbTag.color = PURE_GRAY_500
            cell.cbTag.setOn(on: false, animated: false)
            cell.lbContent.text = item.content
            cell.lbTime.text = ToolFunction.GetDateFromUTC(time: item.timeTarget)
        }
        //选择框设置点击监听
        cell.cbTag.addAction(handler:
        {
            (isOn) in
            let b = isOn ? 1 : 0
            //必须先对当前状态做判断，因为每次装填都会触发事件，这里需要过滤
            if item.status != b {
                item.status = b
                //获取时间
                let time = Int(Date().timeIntervalSince1970)
                item.timeDone = time
                self.mApp.DBMGet().TaskCheck(model: item)
                tableView.reloadRows(at: [indexPath], with: .automatic)
                tableView.reloadSections(IndexSet(integer: 0), with: .none)
            }
        })
        //背景设置点击监听
        cell.vCard.addAction(handler:
        {
            () in
            if tableView.isEditing == false
            {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                //使用segue跳转
                self.performSegue(withIdentifier: "showTaskEdit", sender: self)
                tableView.deselectRow(at: indexPath, animated: false)
            }
        })
        return cell
    }
    //设置隔栏颜色
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        view.tintColor = PURE_BLACK_300
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    //设置分栏标题
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        var title = ""
        switch mFilter {
            case "today":
                title = NSLocalizedString("today", comment: "")
            case "all":
                title = NSLocalizedString("all",comment: "")
            case "todo":
                title = NSLocalizedString("todo",comment: "")
            case "done":
                title = NSLocalizedString("done",comment: "")
            default:
                break
        }
        title = title + "  ·  " + countGet()
        return title
    }
    //动态调整分栏间距
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return CGFloat(30)
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
                //从设置中获取最后使用的颜色
                if let last = UserDefaults.standard.value(forKey: "color_last") as? String {
                    model.color = last
                }
                //获取时间
                let time = Int(Date().timeIntervalSince1970)
                model.timeCreate = time
                model.timeTarget = model.timeCreate
                model.timeDone = 0
                model.timeSort = model.timeCreate
                model.status = 0
                let id = self.mApp.DBMGet().TaskAdd(model: model)
                //必须向tableView的数据源数组中相应的添加一条数据
                self.mDataset.insert(self.mApp.DBMGet().TaskGet(id: id), at: 0)
                self.tableView.setContentOffset(CGPoint(x: 0,y: -64), animated: true)
                self.tableView.beginUpdates()
                self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                self.tableView.endUpdates()
            }
        })
        let negativeAction = UIAlertAction(title: NSLocalizedString("button_cancel",comment: ""), style: UIAlertActionStyle.cancel, handler: nil)
        //装载
        alert.addAction(positiveAction)
        alert.addAction(negativeAction)
        //弹起
        self.present( alert, animated: true, completion: nil)
    }
    
    @IBAction func actionAddDetail(_ sender: Any)
    {
        //使用segue跳转
        self.performSegue(withIdentifier: "showTaskAdd", sender: self)
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
    
    func countGet() -> String
    {
        var iCheckNum = 0;
        for item in mDataset
        {
            if (item.status == 1)
            {
                iCheckNum = iCheckNum + 1;
            }
        }
        return String(iCheckNum) + "/" + String(mDataset.count)
    }
    
    func colorGet(color: String) -> UIColor
    {
        switch color
        {
            case "blue":
                return PURE_BLUE_500
            case "green":
                return PURE_GREEN_500
            case "yellow":
                return PURE_YELLOW_500
            case "red":
                return PURE_RED_500
            default:
                return PURE_BLUE_500
        }
    }
}




