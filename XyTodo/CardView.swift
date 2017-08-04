import UIKit
//自定义卡片控件，用来承担背景
class CardView: UIControl
{
    private var ClickBlock: (()->Void)?
    func addAction(handler: @escaping () -> Void) {
        ClickBlock = handler
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        //添加点击事件
        self.addTarget(self, action: #selector(CardView.changeDown), for: .touchDown)
        self.addTarget(self, action: #selector(CardView.changeUp), for: .touchCancel)
        self.addTarget(self, action: #selector(CardView.click), for: .touchUpInside)
        self.addTarget(self, action: #selector(CardView.changeUp), for: .touchUpOutside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //添加点击事件
        self.addTarget(self, action: #selector(CardView.changeDown), for: .touchDown)
        self.addTarget(self, action: #selector(CardView.changeUp), for: .touchCancel)
        self.addTarget(self, action: #selector(CardView.click), for: .touchUpInside)
        self.addTarget(self, action: #selector(CardView.changeUp), for: .touchUpOutside)
        //加阴影
        self.layer.shadowColor = PURE_GRAY_500.cgColor //shadowColor阴影颜色
        self.layer.shadowOffset = CGSize(width:0, height:2) //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.7 //阴影透明度，默认0
        self.layer.shadowRadius = 1 //阴影半径，默认3
    }
    //点击动画
    func changeDown()
    {
        UIView.animate(withDuration: 0.275, animations:
        {
                self.alpha = 0.7
        })
    }
    //恢复动画
    func changeUp()
    {
        UIView.animate(withDuration: 0.275, animations:
        {
                self.alpha = 1
        })
    }
    //点击事件
    func click() {
        ClickBlock?()
        UIView.animate(withDuration: 0.275, animations:
            {
                self.alpha = 1
        })
    }
}
