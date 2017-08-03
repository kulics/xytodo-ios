import UIKit
//自定义卡片控件，用来承担背景
class CardView: UIControl
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        //添加点击事件
        self.addTarget(self, action: #selector(CardView.changeDown), for: .touchDown)
        self.addTarget(self, action: #selector(CardView.changeUp), for: .touchCancel)
        self.addTarget(self, action: #selector(CardView.changeUp), for: .touchUpInside)
        self.addTarget(self, action: #selector(CardView.changeUp), for: .touchUpOutside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //添加点击事件
        self.addTarget(self, action: #selector(CardView.changeDown), for: .touchDown)
        self.addTarget(self, action: #selector(CardView.changeUp), for: .touchCancel)
        self.addTarget(self, action: #selector(CardView.changeUp), for: .touchUpInside)
        self.addTarget(self, action: #selector(CardView.changeUp), for: .touchUpOutside)
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

}
