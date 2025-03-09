//
//  ForgetPwdVC.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/16.
//
import FWPopupView
import RxCocoa
import RxSwift
import SnapKit
import SVProgressHUD
import SwiftUI
import UIKit

class ForgetPwdVC: BaseVC {
    let phoeDirList: [String] = ["+86", "+852", "+853", "+886"]

    let disposeBag = DisposeBag()

    var countTimer = 60
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.bindAction()
    }

    @objc func labelTap(_ gesture: UITapGestureRecognizer) {
        let vProperty = FWSheetViewProperty()
        vProperty.touchWildToHide = "1"
        vProperty.titleColor = UIColor.lightGray
        vProperty.titleFont = UIFont.systemFont(ofSize: 15.0)
        vProperty.leftRightTopCornerRadius = 8
        // 取消按钮底下区域通铺效果（必须修改以下属性）
        vProperty.bottomCoherent = true
        vProperty.backgroundColor = UIColor.white
        vProperty.dark_backgroundColor = kPV_RGBA(r: 44, g: 44, b: 44, a: 1)

        let sheetView = FWSheetView.sheet(title: "",
                                          itemTitles: ["+86(中国大陆)", "+852(香港)", "+853(澳门)", "+886(台湾地区)"],
                                          itemBlock: { _, index, _ in
                                              self.areaCodeLabel.text = self.phoeDirList[index]
                                          }, cancenlBlock: {}, property: vProperty)
        sheetView.show()
    }

    func bindAction() {
        self.loginButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.resetPwd()
        }).disposed(by: self.disposeBag)

        // 发送验证码
        self.countdownButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.sendResetCode()
        }).disposed(by: self.disposeBag)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }

    func resetPwd() {
        self.dismissKeyboard()
        SVProgressHUD.show(withStatus: "设置中")
        if (self.accountTextField.text?.count ?? 0) == 0 {
            SVProgressHUD.showInfo(withStatus: "请输入手机号")
            return
        }

        if (self.passwordTextField.text?.count ?? 0) == 0 {
            SVProgressHUD.showInfo(withStatus: "请输入验证码")
            return
        }

        if (self.passwordVerTextField.text?.count ?? 0) == 0 || (self.sureVerTextField.text?.count ?? 0) == 0 {
            SVProgressHUD.showInfo(withStatus: "请输入正确密码")
            return
        }

        // 两次输入密码必须一直
        if self.passwordVerTextField.text != self.sureVerTextField.text {
            SVProgressHUD.showInfo(withStatus: "两次输入密码必须一致")
            return
        }
        // 截取self.areaCodeLabel.text 从第二个字符开始
        let areaCode = String(self.areaCodeLabel.text?.dropFirst() ?? "")

        let params = ["iac": areaCode, "phone": self.accountTextField.text ?? "", "type": "reset_password", "password_new": self.passwordVerTextField.text ?? "", "password_repeat": self.sureVerTextField.text ?? "", "code": self.passwordTextField.text ?? ""] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.resetPassword(params), completion: { requestObj in
            if requestObj.status == .success {
                SVProgressHUD.showSuccess(withStatus: "设置成功，请重新使用新密码登录")
            }

        })
    }

    /// 发送验证码
    func sendResetCode() {
        if (self.accountTextField.text?.count ?? 0) == 0 {
            SVProgressHUD.showInfo(withStatus: "请输入手机号")
            return
        }

        // 倒计时60秒 button的数字改变
        self.countdownButton.isEnabled = false
        // 定时器 改变button的读数
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countdown), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer ?? Timer(), forMode: .common)

        // 截取self.areaCodeLabel.text 从第二个字符开始
        let areaCode = String(self.areaCodeLabel.text?.dropFirst() ?? "")

        let params = ["iac": areaCode, "phone": self.accountTextField.text ?? "", "type": "reset_password"] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.phoneCode(params), completion: { _ in
            SVProgressHUD.showSuccess(withStatus: "发送成功")
        })
    }

    @objc func countdown() {
        self.countTimer = self.countTimer - 1
        self.countdownButton.setTitle("\(self.countTimer)秒后重试", for: .normal)
        if self.countTimer <= 0 {
            self.countdownButton.isEnabled = true
            self.countdownButton.setTitle("获取验证码", for: .normal)
            self.countTimer = 60
            self.timer?.invalidate()
        }
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    func initUI() {
        self.view.addSubview(self.backImageView)
        self.view.addSubview(self.mainBackView)

        // 内部的按钮处理
        self.mainBackView.addSubview(self.backAccountView)
        self.mainBackView.addSubview(self.pwdView)
        self.mainBackView.addSubview(self.pwdVerView)

        self.backAccountView.addSubview(self.areaCodeLabel)
        self.backAccountView.addSubview(self.accountTextField)
        self.pwdView.addSubview(self.passwordTextField)
        self.pwdView.addSubview(self.countdownButton)
        self.pwdVerView.addSubview(self.passwordVerTextField)
        self.mainBackView.addSubview(self.loginButton)
        self.mainBackView.addSubview(self.surePwdView)
        self.surePwdView.addSubview(self.sureVerTextField)

        self.backImageView.snp.makeConstraints { make in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(AdaptedWidth(w: 472 / 2))
        }

        self.mainBackView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(AdaptedWidth(w: 472 / 2 - 12))
        }

        self.backAccountView.snp.makeConstraints { make in
            make.left.equalTo(self.mainBackView).offset(20)
            make.right.equalTo(self.mainBackView).offset(-20)
            make.height.equalTo(52)
            make.top.equalTo(self.mainBackView.snp.top).offset(AdaptedWidth(w: 22))
        }

        self.pwdView.snp.makeConstraints { make in
            make.left.equalTo(self.mainBackView).offset(20)
            make.right.equalTo(self.mainBackView).offset(-20)
            make.height.equalTo(52)
            make.top.equalTo(self.backAccountView.snp.bottom).offset(AdaptedWidth(w: 12))
        }

        self.pwdVerView.snp.makeConstraints { make in
            make.left.equalTo(self.mainBackView).offset(20)
            make.right.equalTo(self.mainBackView).offset(-20)
            make.height.equalTo(52)
            // 设置密码
            make.top.equalTo(self.pwdView.snp.bottom).offset(AdaptedWidth(w: 12))
        }

        self.passwordVerTextField.snp.makeConstraints { make in
            make.left.equalTo(self.pwdVerView).offset(20)
            make.right.equalTo(self.pwdVerView).offset(-20)
            make.centerY.equalTo(self.pwdVerView)
        }

        self.areaCodeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.backAccountView)
            make.left.equalTo(self.backAccountView.snp.left).offset(12)
        }

        // 输入框
        self.accountTextField.snp.makeConstraints { make in
            make.left.equalTo(self.backAccountView).offset(50)
            make.right.equalTo(self.backAccountView).offset(-20)
            make.centerY.equalTo(self.backAccountView)
        }

        self.passwordTextField.snp.makeConstraints { make in
            make.left.equalTo(self.pwdView).offset(20)
            make.right.equalTo(self.pwdView).offset(-120)
            make.centerY.equalTo(self.pwdView)
        }

        self.countdownButton.snp.makeConstraints { make in
            make.right.equalTo(self.pwdView.snp.right).offset(-5)
            make.centerY.equalTo(self.pwdView)
            make.size.equalTo(CGSize(width: 100, height: 20))
        }

        self.surePwdView.snp.makeConstraints { make in
            make.left.equalTo(self.mainBackView).offset(20)
            make.right.equalTo(self.mainBackView).offset(-20)
            make.height.equalTo(52)
            make.top.equalTo(self.pwdVerView.snp.bottom).offset(AdaptedWidth(w: 12))
        }

        self.sureVerTextField.snp.makeConstraints { make in
            make.left.equalTo(self.surePwdView).offset(20)
            make.right.equalTo(self.surePwdView).offset(-120)
            make.centerY.equalTo(self.surePwdView)
        }

        self.loginButton.snp.makeConstraints { make in
            make.left.right.equalTo(self.pwdView)
            make.top.equalTo(self.surePwdView.snp.bottom).offset(AdaptedWidth(w: 24))
            make.height.equalTo(AdaptedWidth(w: 44))
        }
    }
    
    lazy var backImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "app_login_pwd"))
        return imageView
    }()

    // 圆角背景
    lazy var mainBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()

    // 地区的编号
    lazy var areaCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "+86"
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.labelTap(_:)))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        label.textColor = UIColor.text333Color()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    // 一个渐变的按钮 从左到右的渐变背景的按钮
    lazy var loginButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 40, height: 44))
        button.setTitle("提交", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        applyGradientToButton(button)
        return button
    }()
    
    
    private func applyGradientToButton(_ button: UIButton) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.colors = [Color.hex("E84C4F").cgColor, Color.hex("FF7E3F").cgColor] // 设置渐变颜色
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5) // 渐变起始点
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5) // 渐变结束点
        gradientLayer.cornerRadius = 5 // 设置圆角

        // 将渐变层添加到按钮的图层中
        button.layer.insertSublayer(gradientLayer, at: 0)

        // 确保按钮的内容在渐变层之上
        button.setTitleColor(.white, for: .normal)
    }

    // 账号密码输入框背景
    lazy var backAccountView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.backColor()
        view.layer.cornerRadius = 12
        return view
    }()

    lazy var pwdView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.backColor()
        view.layer.cornerRadius = 12
        return view
    }()

    // 密码的验证框
    lazy var passwordVerTextField: UITextField = {
        let textField = UITextField()
        // 设置最多输入4个字符
        textField.placeholder = "请设置密码"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.text333Color()
        return textField
    }()

    // 验证码的View
    lazy var pwdVerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.backColor()
        view.layer.cornerRadius = 12
        return view
    }()

    // 倒计时按钮
    lazy var countdownButton: UIButton = {
        let button = UIButton()
        button.setTitle("获取验证码", for: .normal)
        button.setTitleColor(UIColor.mainColor(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.textColor = UIColor.mainColor()
        return button
    }()

    // 输入框 账号和密码的输入框
    lazy var accountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入手机号"
        textField.keyboardType = .numberPad
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.text333Color()
        return textField
    }()

    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        // 设置最多输入4个字符
        textField.keyboardType = .numberPad
        textField.placeholder = "请输入验证码"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.text333Color()
        return textField
    }()

    // 确认密码
    lazy var surePwdView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.backColor()
        view.layer.cornerRadius = 12
        return view
    }()

    lazy var sureVerTextField: UITextField = {
        let textField = UITextField()
        // 设置最多输入4个字符
        textField.placeholder = "确认密码"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.text333Color()
        return textField
    }()
}
