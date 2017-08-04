import UIKit

class ViewControllerTaskEdit: UITableViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate
{
    
    var mApp: AppDelegate!
    var delegate: ProtocolHomeChange?
    var mDataTask: ModelTask! //数据源
    var mID: Int?
    var iCheckNum: Int = 0
    
    @IBOutlet weak var mActionButton: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("page_title_task_edit",comment: "")
        mActionButton.title = NSLocalizedString("button_save",comment: "")
        //获取本地数据
        mApp = UIApplication.shared.delegate as? AppDelegate
        mDataTask = mApp.DBMGet().TaskGet(id: mID!)
        mDataTask.sub = mApp.DBMGet().TaskSubGet(id_task: mDataTask.id)
        for item in mDataTask.sub
        {
            if item.status == 1
            {
                iCheckNum = iCheckNum + 1
            }
        }
        //隐藏空白项
        self.tableView.tableFooterView = UIView()
        //设置自适应高度
        self.tableView.estimatedRowHeight = 64
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        setThemeColor(color: mDataTask.color)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.barTintColor = PURE_BLACK_500
        self.navigationController?.toolbar.tintColor = PURE_BLACK_500
    }
    
    //监听跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showNote"
        {
            let tempVC = segue.destination as! ViewControllerNote
            //设置内容和监听
            tempVC.strContent = mDataTask.note
            tempVC.addAction(handler:
            {
                (note) in
                self.mDataTask.note = note
                self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
            })
        }
    }
    
    //显示条目数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3 + mDataTask.sub.count + 4
    }
    //装载条目信息
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let row = (indexPath as NSIndexPath).row
        switch row
        {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellMain", for: indexPath) as! TableViewCellTaskMain
                cell.tfContent.text = mDataTask.content
                cell.tfContent.placeholder = NSLocalizedString("content",comment: "")
                if mDataTask.status == 1 //根据状态不同设置不同显示
                {
                    cell.tfContent.attributedText = NSMutableAttributedString(string: mDataTask.content, attributes: [NSStrikethroughStyleAttributeName :1])
                    cell.tfContent.textColor = UIColor.gray
                    cell.cbxStatus.setOn(on: true, animated: false)
                }
                else
                {
                    cell.tfContent.text =  mDataTask.content
                    cell.cbxStatus.setOn(on: false, animated: false)
                }
                cell.lbSub.text = String(iCheckNum) + "/" + String(mDataTask.sub.count)
                NotificationCenter.default.addObserver(self, selector: #selector(textFieldEditChanged), name: .UITextFieldTextDidChange, object: cell.tfContent)
                cell.cbxStatus.addAction(handler:
                {
                    (isOn) in
                    let b = isOn ? 1 : 0
                    //必须先对当前状态做判断，因为每次装填都会触发事件，这里需要过滤
                    if self.mDataTask.status != b {
                        self.mDataTask.status = b
                        //获取时间
                        let time = Int(Date().timeIntervalSince1970)
                        self.mDataTask.timeDone = time
                        self.mApp.DBMGet().TaskCheck(model: self.mDataTask)
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                })
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellTime", for: indexPath) as! TableViewCellTaskTime
                cell.lbContent.text = ToolFunction.GetDateFromUTC(time: mDataTask.timeTarget)
                cell.lbTitle.text = NSLocalizedString("target",comment: "")
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellNote", for: indexPath) as! TableViewCellTaskNote
                var str = mDataTask.note
                if str.lengthOfBytes(using: .utf8) == 0
                {
                    str = NSLocalizedString("note",comment: "")
                }
                cell.lbContent.text = str
                cell.vCard.addAction(handler:
                {
                    () in
                    //使用segue跳转
                    self.performSegue(withIdentifier: "showNote", sender: self)
                })
                return cell
            case 3 + mDataTask.sub.count ... 3 + mDataTask.sub.count+4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellNone", for: indexPath)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellSub", for: indexPath) as! TableViewCellTaskSub
                cell.tfContent.text = mDataTask.sub[row-3].content
                cell.tfContent.placeholder = NSLocalizedString("content",comment: "")
                if mDataTask.sub[row-3].status == 1 //根据状态不同设置不同显示
                {
                    cell.tfContent.attributedText = NSMutableAttributedString(string: mDataTask.sub[row-3].content, attributes: [NSStrikethroughStyleAttributeName :1])
                    cell.tfContent.textColor = UIColor.gray
                    cell.cbxStatus.setOn(on: true, animated: false)
                }
                else
                {
                    cell.tfContent.text =  mDataTask.sub[row-3].content
                    cell.cbxStatus.setOn(on: false, animated: false)
                }
                NotificationCenter.default.addObserver(self, selector: #selector(textFieldEditChanged), name: .UITextFieldTextDidChange, object: cell.tfContent)
                cell.cbxStatus.addAction(handler:
                {
                    (isOn) in
                    let b = isOn ? 1 : 0
                    //必须先对当前状态做判断，因为每次装填都会触发事件，这里需要过滤
                    if self.mDataTask.sub[row-3].status != b
                    {
                        if b == 1
                        {
                            self.iCheckNum = self.iCheckNum + 1
                        }
                        else
                        {
                            self.iCheckNum = self.iCheckNum - 1
                        }
                        self.mDataTask.sub[row-3].status = b
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                    }
                })
                return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func setDataset()
    {
        self.tableView.reloadData()
    }
    //监听键盘隐藏
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        //隐藏键盘
        textField.resignFirstResponder()
        return true;
    }
    //监听输入变化
    func textFieldEditChanged(notification:Notification)
    {
        let textField = notification.object as! UITextField
        //获取父级cell
        let cell = textField.superview?.superview?.superview as! UITableViewCell
        let row = (self.tableView.indexPath(for: cell)! as NSIndexPath).row
        let text = textField.text!
        switch row
        {
            case 0:
                mDataTask.content = text
            case 3 ... 3 + mDataTask.sub.count:
                mDataTask.sub[row-3].content = text
            default:
                break
        }
    }
    
    @IBAction func actionBack(_ sender : Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionPalette(_ sender : Any)
    {
        //弹出对话框
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewControllerPalette") as! ViewControllerPalette
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        //弹出
        self.present(vc, animated: true, completion: nil)
        
        vc.lbTitle.text = NSLocalizedString("dialog_title_palette", comment: "")
        vc.btnPositive.setTitle(NSLocalizedString("button_set",comment: ""), for: UIControlState())
        vc.btnPositive.tintColor = PURE_BLUE_500
        vc.btnNegative.setTitle(NSLocalizedString("button_cancel",comment: ""), for: UIControlState())
        vc.btnNegative.tintColor = UIColor.darkGray
        vc.setColor(mDataTask.color)
        vc.addAction { (color) in
            self.mDataTask.color = color
            self.setThemeColor(color: color)
        }
    }
    //保存操作
    @IBAction func actionSave(_ sender : Any)
    {
        if mDataTask.content.lengthOfBytes(using: .utf8) > 0 {
            mApp.DBMGet().TaskUpdate(model: mDataTask)
            self.delegate?.updateHome()
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    //添加sub操作
    @IBAction func actionAddSub(_ sender: Any)
    {
        mDataTask.sub.append(ModelTaskSub())
        self.tableView.reloadData()
    }
    //删除sub操作
    @IBAction func actionDeleteSub(_ sender: Any)
    {
        //转化成按钮
        let btn = sender as! UIButton
        //获取父级cell
        let cell = btn.superview?.superview?.superview as! TableViewCellTaskSub
        //根据cell获得位置
        let index = self.tableView.indexPath(for: cell)
        mDataTask.sub.remove(at: index!.row - 3)
        self.tableView.reloadData()
    }
    
    //删除操作
    @IBAction func actionDelete(_ sender: Any)
    {
        //创建对话框
        let alert = UIAlertController(title: NSLocalizedString("dialog_title_delete",comment: ""), message: NSLocalizedString("dialog_content_delete",comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        //设置按钮
        let positiveAction = UIAlertAction(title: NSLocalizedString("button_delete",comment: ""), style: UIAlertActionStyle.destructive)
        {
            (action) -> Void in
            self.mApp.DBMGet().TaskDelete(model: self.mDataTask)
            self.delegate?.updateHome()
            // 没有错误消息抛出
            _ = self.navigationController?.popViewController(animated: true)
        }
        let negativeAction = UIAlertAction(title: NSLocalizedString("button_cancel",comment: ""), style: UIAlertActionStyle.cancel, handler: nil)
        //装载
        alert.addAction(positiveAction)
        alert.addAction(negativeAction)
        //弹起
        self.present( alert, animated: true, completion: nil)
    }
    @IBAction func actionTimeSet(_ sender: Any)
    {
        //转化成按钮
        let btn = sender as! UIButton
        //设置弹出菜单
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewControllerPopMenu") as! ViewControllerPopMenu
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        //菜单文本
        vc.menus = [
            NSLocalizedString("today", comment: ""),
            NSLocalizedString("tomorrow",comment: ""),
            NSLocalizedString("next_week",comment: ""),
            NSLocalizedString("custom",comment: "")
        ]
        //监听事件
        vc.addAction(handler:
        {
            (num) in
            //获取时间
            let time = Int(Date().timeIntervalSince1970)
            switch num
            {
                case 0: //当天
                    self.mDataTask.timeTarget = time
                case 1: //明天
                    self.mDataTask.timeTarget = time + 86400
                case 2: //下周
                    self.mDataTask.timeTarget = time + 604800
                case 3: //使用选择器自定义
                    let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
                    // 初始化 datePicker
                    let datePicker = UIDatePicker( )
                    //设置居中
                    datePicker.center = CGPoint(x: self.view.center.x, y: datePicker.center.y)
                    // 设置样式，当前设为日期
                    datePicker.datePickerMode = .date
                    // 设置默认时间
                    datePicker.date = Date()
                    // 响应事件（只要滚轮变化就会触发）
                    // datePicker.addTarget(self, action:Selector("datePickerValueChange:"), forControlEvents: UIControlEvents.ValueChanged)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("button_ok", comment: ""), style: .default)
                    {
                        (alertAction) in
                        self.mDataTask.timeTarget = Int(datePicker.date.timeIntervalSince1970)
                        self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
                    })
                    alert.addAction(UIAlertAction(title: NSLocalizedString("button_cancel", comment: ""), style: .cancel, handler:nil))
                    //添加到弹出框
                    alert.view.addSubview(datePicker)
                    self.present(alert, animated: true, completion: nil)
                default:
                    break
            }
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        })
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        //对齐位置
        popover.sourceView = btn
        popover.sourceRect = btn.bounds
        popover.delegate = self
        //弹出
        self.present(vc, animated: true, completion: nil)

    }
    
    //更改菜单弹窗风格
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.none
    }
    
    //设置主题颜色
    func setThemeColor(color:String)
    {
        switch color
        {
        case "green":
            self.navigationController?.navigationBar.barTintColor = PURE_GREEN_500
            self.navigationController?.toolbar.tintColor = PURE_GREEN_500
        case "blue":
            self.navigationController?.navigationBar.barTintColor = PURE_BLUE_500
            self.navigationController?.toolbar.tintColor = PURE_BLUE_500
        case "red":
            self.navigationController?.navigationBar.barTintColor = PURE_RED_500
            self.navigationController?.toolbar.tintColor = PURE_RED_500
        case "yellow":
            self.navigationController?.navigationBar.barTintColor = PURE_YELLOW_500
            self.navigationController?.toolbar.tintColor = PURE_YELLOW_500
        default:
            self.navigationController?.navigationBar.barTintColor = PURE_GREEN_500
            self.navigationController?.toolbar.tintColor = PURE_GREEN_500
        }
    }
}





