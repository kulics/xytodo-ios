import UIKit

class ViewControllerNote: UIViewController, UITextViewDelegate
{
    @IBOutlet weak var mActionButton: UIBarButtonItem!
    @IBOutlet weak var tvContent: UITextView!
    
    var mApp : AppDelegate?
    var strContent: String?
    
    private var SaveBlock: ((String)->Void)?
    func addAction(handler: @escaping (String) -> Void) {
        SaveBlock = handler
    }
    
    override func viewDidLoad()
    {
        self.navigationItem.title = NSLocalizedString("page_title_note",comment: "")
        mActionButton.title = NSLocalizedString("button_save",comment: "")
        
        //获取app
        mApp = UIApplication.shared.delegate as? AppDelegate
        
        tvContent.text = strContent
        //解决键盘遮挡
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //监听返回动作
    @IBAction func actionBack(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func keyboardWillShow(notification:NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            //self.contentTextView.frame.origin.y -= keyboardSize.height
            self.tvContent.contentInset.bottom = keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification:NSNotification)
    {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil
        {
            self.tvContent.contentInset.bottom = 0
            //keyboardIsPresent = false
        }
    }
    
    @IBAction func actionDone(_ sender: Any)
    {
        tvContent.resignFirstResponder()
        SaveBlock?(tvContent.text)
        _ = self.navigationController?.popViewController(animated: true)

    }
}
