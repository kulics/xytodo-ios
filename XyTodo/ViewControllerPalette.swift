import UIKit

public enum UIButtonBorderSide
{
    case Top, Bottom, Left, Right
}

extension UIButton
{
    
    public func addBorder(side: UIButtonBorderSide, color: UIColor, width: CGFloat)
    {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side
        {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .Bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .Right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        }
        
        self.layer.addSublayer(border)
    }
}

//自定义对话框
class ViewControllerPalette: UIViewController
{
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnPositive: UIButton!
    @IBOutlet weak var btnNegative: UIButton!
    
    @IBOutlet weak var tag0: UIButton!
    @IBOutlet weak var tag1: UIButton!
    @IBOutlet weak var tag2: UIButton!
    @IBOutlet weak var tag3: UIButton!
    
    @IBOutlet weak var bg0: UIView!
    @IBOutlet weak var bg1: UIView!
    @IBOutlet weak var bg2: UIView!
    @IBOutlet weak var bg3: UIView!
    
    var mColor:String = "blue"
    
    private var actionPositive : ((String)->Void)?
    
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        bg0.backgroundColor = PURE_BLUE_500
        bg1.backgroundColor = PURE_GREEN_500
        bg2.backgroundColor = PURE_YELLOW_500
        bg3.backgroundColor = PURE_RED_500
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        btnNegative.addBorder(side: .Top, color: alertViewGrayColor, width: 1)
        //btnNegative.addBorder(side: .Right, color: alertViewGrayColor, width: 1)
        btnPositive.addBorder(side: .Top, color: alertViewGrayColor, width: 1)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    func setupView()
    {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    func animateView()
    {
        alertView.alpha = 0
        UIView.animate(withDuration: 0.2, animations:
            {
                () -> Void in
                self.alertView.alpha = 1.0
        })
    }
    
    func addAction(handler : @escaping (String)->Void)
    {
        self.actionPositive = handler
    }
    
    //监听颜色按钮
    @IBAction func clickTag0(_ sender: Any){ setColor("blue") }
    @IBAction func clickTag1(_ sender: Any){ setColor("green") }
    @IBAction func clickTag2(_ sender: Any){ setColor("yellow") }
    @IBAction func clickTag3(_ sender: Any){ setColor("red") }
    
    //设置颜色标签
    func setColor(_ color:String)
    {
        clearColor()
        mColor = color
        switch color
        {
            case "blue":
                tag0.backgroundColor = PURE_BLUE_500
            case "green":
                tag1.backgroundColor = PURE_GREEN_500
            case "yellow":
                tag2.backgroundColor = PURE_YELLOW_500
            case "red":
                tag3.backgroundColor = PURE_RED_500
            default:
                tag1.backgroundColor = PURE_BLUE_500
        }
    }
    //重置颜色
    func clearColor()
    {
        let color = UIColor.white
        tag0.backgroundColor = color
        tag1.backgroundColor = color
        tag2.backgroundColor = color
        tag3.backgroundColor = color
    }
    
    @IBAction func doNegative(_ sender:Any)
    {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doPositive(_ sender:Any)
    {
        self.actionPositive?(mColor)
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
}
