//
//  LoginVC.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/5.
//

import Foundation
import FWPopupView
import RxCocoa
import RxSwift
import SnapKit
import SVProgressHUD
import SwiftUI
import UIKit

class LoginVC: BaseVC {
    var loginCallback: ((Bool) -> Void)?
    // 跳转到忘记密码界面
    var pushForgetPageBlock: ((Bool) -> Void)?

    let disposeBag = DisposeBag()
    @ObservedObject var model = Model()

    let phoeDirList: [String] = ["+86", "+852", "+853", "+886"]

    var countTimer = 60
    var timer: Timer?

    var isAgress = false

    var loginType = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bindAction()
        setLoginType(type: 1)
        loginCofig()
    }

    func loginCofig() {
        wechatImageView.isHidden = !isShowOtherLogin
        weiboImageView.isHidden = !isShowOtherLogin
        qqImageView.isHidden = !isShowOtherLogin
        bottomInfoLabel.isHidden = !isShowOtherLogin
    }

    func bindAction() {
        loginButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.login()
        }).disposed(by: disposeBag)

        // 发送验证码
        countdownButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.sendCode()
        }).disposed(by: disposeBag)

        // 验证码登录和密码登录
        verButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.setLoginType(type: 1)
        }).disposed(by: disposeBag)

        pwdButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.setLoginType(type: 2)
        }).disposed(by: disposeBag)

        // 跳转到设置密码的页面
        forgetPassword.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.pushViewController(ForgetPwdVC(), animated: true)
        }).disposed(by: disposeBag)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    // 设置当前登录方式
    func setLoginType(type: Int) {
        verButton.isSelected = type == 1
        pwdButton.isSelected = type == 2

        forgetPassword.isHidden = type == 1
        pwdVerView.isHidden = type == 1
        pwdView.isHidden = type == 2
        loginType = type

        buttonSelectView.snp.updateConstraints { make in
            if type == 1 {
                make.centerX.equalTo(self.verButton.centerX)
            } else {
                make.centerX.equalTo(self.pwdButton.centerX)
            }
        }

        bottomLineView.snp.remakeConstraints { make in
            if type == 1 {
                make.centerX.equalTo(self.verButton)
                make.top.equalTo(self.mainBackView).offset(35)
                make.size.equalTo(CGSize(width: 24, height: 5))

            } else {
                make.centerX.equalTo(self.pwdButton)
                make.top.equalTo(self.mainBackView).offset(35)
                make.size.equalTo(CGSize(width: 24, height: 5))
            }
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // 跳转到忘记密码页面
    func pushForgetPage() {
        let pwd = ForgetPwdVC()
        // 跳转到设置密码的页面
        navigationController?.pushViewController(pwd, animated: true)
    }

    // 登录操作
    func login() {
        dismissKeyboard()
        if (accountTextField.text?.count ?? 0) == 0 {
            SVProgressHUD.showInfo(withStatus: "请输入手机号")
            return
        }

        if loginType == 1 {
            loginByCode()
        } else {
            loginByPwd()
        }
    }

    // 验证码登录
    func loginByCode() {
        if (passwordTextField.text?.count ?? 0) == 0 {
            SVProgressHUD.showInfo(withStatus: "请输入验证码")
            return
        }

        if !isAgress {
            SVProgressHUD.showInfo(withStatus: "请同意下底部协议")
            showIsNotAgree { agree in
                if agree ?? false {
                    self.loginByCode()
                }
            }
            return
        }
        SVProgressHUD.show(withStatus: "登录中")
        // 截取self.areaCodeLabel.text 从第二个字符开始
        let areaCode = String(areaCodeLabel.text?.dropFirst() ?? "")

        // 请求接口
        let params = ["iac": areaCode, "phone": accountTextField.text ?? "", "code": passwordTextField.text ?? ""] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.loginPhoneCode(params), completion: { [weak self] requestObj in
            if requestObj.status == .success {
                if let data = requestObj.data,
                   let user = data["user"] as? [String: Any],
                   let needSetPawd = user["set_password"] as? Bool
                {
                    self?.loginSuccess(requestObj: requestObj)
                }
            }
        })
    }

    // 密码登录
    func loginByPwd() {
        if (passwordVerTextField.text?.count ?? 0) == 0 {
            SVProgressHUD.showInfo(withStatus: "请输入密码")
            return
        }

        if !isAgress {
            SVProgressHUD.showInfo(withStatus: "请同意下底部协议")
            showIsNotAgree { agree in
                if agree ?? false {
                    self.loginByPwd()
                }
            }
            return
        }
        SVProgressHUD.show(withStatus: "登录中")

        // 截取self.areaCodeLabel.text 从第二个字符开始
        let areaCode = String(areaCodeLabel.text?.dropFirst() ?? "")

        let params = ["iac": areaCode, "password": passwordVerTextField.text ?? "", "phone": accountTextField.text ?? ""] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.loginPassword(params), completion: { [weak self] requestObj in
            // 登录成功过的操作
            // 成功的回调
            if requestObj.status == .success {
                self?.loginSuccess(requestObj: requestObj)
            }
        })
    }

    // 登录成功过 存下token
    func loginSuccess(requestObj: NetResultModel) {
        loginCallback?(true)
        bindPushCid()
        UserSharedManger.shared.saveUserToken(token: requestObj.data?["token"] as? String)
        UserSharedManger.shared.savaUserInfo(data: requestObj.data?["user"] as! [String: Any])
        SVProgressHUD.dismiss()
        SVProgressHUD.showSuccess(withStatus: "登录成功")
    }

    // 绑定当前的用户三方信息
    func bindPushCid() {
        // 获取当前设备的UDID
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        let registrationID = JPUSHService.registrationID
        let params = ["os": "ios", "device_id": uuid ?? "", "registration_id": registrationID] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.userDevices(params), isShowErrMsg: false, completion: { _ in
        })
    }

    /// 发送验证码
    func sendCode() {
        if (accountTextField.text?.count ?? 0) == 0 {
            SVProgressHUD.showInfo(withStatus: "请输入手机号")
            return
        }

        // 倒计时60秒 button的数字改变
        countdownButton.isEnabled = false
        // 定时器 改变button的读数
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        RunLoop.current.add(timer ?? Timer(), forMode: .common)

        // 截取self.areaCodeLabel.text 从第二个字符开始
        let areaCode = String(areaCodeLabel.text?.dropFirst() ?? "")

        let params = ["iac": areaCode, "phone": accountTextField.text ?? "", "type": "login"] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.phoneCode(params), completion: { _ in
            SVProgressHUD.showSuccess(withStatus: "发送成功")
        })
    }

    @objc func countdown() {
        countTimer = countTimer - 1
        countdownButton.setTitle("\(countTimer)秒后重试", for: .normal)
        if countTimer <= 0 {
            countdownButton.isEnabled = true
            countdownButton.setTitle("获取验证码", for: .normal)
            countTimer = 60
            timer?.invalidate()
        }
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

    // 其他方式登录 处理不同方式的登录
    func loginByOther(type: Int) {
        if type == 1 {
            print("微博登录")
        } else if type == 2 {
            print("微信登录")
        } else if type == 3 {
            print("QQ登录")
        }
    }

    // 跳转到设置密码的页面
    private func navigateToSetPwdView(requestObj: NetResultModel) {
        var setPasswordView = SetPasswordView() // 创建目标视图控制器
        setPasswordView.onPasswordSet = { success in
            if success {
                self.loginSuccess(requestObj: requestObj)
            }
        }

        let hostingController = UIHostingController(rootView: setPasswordView)
        navigationController?.pushViewController(hostingController, animated: true)
    }

    // 初始化
    func initUI() {
        view.addSubview(backImageView)
        view.addSubview(mainBackView)

        view.addSubview(bottomInfoLabel)
        view.addSubview(weiboImageView)
        view.addSubview(wechatImageView)
        view.addSubview(qqImageView)

        // 内部的按钮处理
        mainBackView.addSubview(backAccountView)
        mainBackView.addSubview(pwdView)
        mainBackView.addSubview(pwdVerView)

        mainBackView.addSubview(verButton)
        mainBackView.addSubview(pwdButton)
        mainBackView.addSubview(bottomLineView)

        backAccountView.addSubview(areaCodeLabel)
        backAccountView.addSubview(accountTextField)
        pwdView.addSubview(passwordTextField)
        pwdView.addSubview(countdownButton)
        pwdVerView.addSubview(passwordVerTextField)
        mainBackView.addSubview(loginButton)
        mainBackView.addSubview(buttonSelectView)
        mainBackView.addSubview(forgetPassword)

        backImageView.snp.makeConstraints { make in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(AdaptedWidth(w: 472 / 2))
        }

        mainBackView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(AdaptedWidth(w: 472 / 2 - 12))
        }

        // 按钮相关处理方式
        verButton.snp.makeConstraints { make in
            make.left.equalTo(self.mainBackView).offset(20)
            make.top.equalTo(self.mainBackView).offset(12)
        }

        pwdButton.snp.makeConstraints { make in
            make.left.equalTo(self.verButton.snp.right).offset(20)
            make.top.equalTo(self.verButton)
            make.centerY.equalTo(self.verButton)
        }

        bottomLineView.snp.makeConstraints { make in
            make.centerX.equalTo(self.verButton)
            make.top.equalTo(self.mainBackView).offset(35)
            make.size.equalTo(CGSize(width: 24, height: 5))
        }

        buttonSelectView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 30, height: 6))
            make.bottom.equalTo(self.verButton.snp.bottom).offset(-5)
            make.centerX.equalTo(self.pwdButton.centerX)
        }

        backAccountView.snp.makeConstraints { make in
            make.left.equalTo(self.mainBackView).offset(20)
            make.right.equalTo(self.mainBackView).offset(-20)
            make.height.equalTo(52)
            make.top.equalTo(self.verButton.snp.bottom).offset(AdaptedWidth(w: 12))
        }

        pwdView.snp.makeConstraints { make in
            make.left.equalTo(self.mainBackView).offset(20)
            make.right.equalTo(self.mainBackView).offset(-20)
            make.height.equalTo(52)
            make.top.equalTo(self.backAccountView.snp.bottom).offset(AdaptedWidth(w: 12))
        }

        pwdVerView.snp.makeConstraints { make in
            make.left.equalTo(self.mainBackView).offset(20)
            make.right.equalTo(self.mainBackView).offset(-20)
            make.height.equalTo(52)
            make.top.equalTo(self.backAccountView.snp.bottom).offset(AdaptedWidth(w: 12))
        }

        passwordVerTextField.snp.makeConstraints { make in
            make.left.equalTo(self.pwdVerView).offset(20)
            make.right.equalTo(self.pwdVerView).offset(-20)
            make.centerY.equalTo(self.pwdVerView)
        }

        areaCodeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.backAccountView)
            make.left.equalTo(self.backAccountView.snp.left).offset(12)
        }

        // 输入框
        accountTextField.snp.makeConstraints { make in
            make.left.equalTo(self.backAccountView).offset(50)
            make.right.equalTo(self.backAccountView).offset(-20)
            make.centerY.equalTo(self.backAccountView)
        }

        passwordTextField.snp.makeConstraints { make in
            make.left.equalTo(self.pwdView).offset(20)
            make.right.equalTo(self.pwdView).offset(-120)
            make.centerY.equalTo(self.pwdView)
        }

        countdownButton.snp.makeConstraints { make in
            make.right.equalTo(self.pwdView.snp.right).offset(-5)
            make.centerY.equalTo(self.pwdView)
            make.size.equalTo(CGSize(width: 100, height: 20))
        }

        forgetPassword.snp.makeConstraints { make in
            make.right.equalTo(self.pwdView.snp.right)
            make.top.equalTo(self.pwdView.snp.bottom).offset(6)
        }

        loginButton.snp.makeConstraints { make in
            make.left.right.equalTo(self.pwdView)
            make.top.equalTo(self.pwdView.snp.bottom).offset(45)
            make.height.equalTo(AdaptedWidth(w: 44))
        }

        // 底部的布局
        wechatImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-112)
        }

        weiboImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.centerY.equalTo(self.wechatImageView)
            make.right.equalTo(self.wechatImageView.snp.left).offset(-40)
        }

        qqImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.centerY.equalTo(self.wechatImageView)
            make.left.equalTo(self.wechatImageView.snp.right).offset(40)
        }

        bottomInfoLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.wechatImageView)
            make.bottom.equalTo(self.wechatImageView.snp.top).offset(-12)
        }

        view.addSubview(toggleButton)
        view.addSubview(clickableLabel)

        clickableLabel.snp.makeConstraints { make in
            make.width.equalTo(270)
            make.height.equalTo(40)
            make.centerX.equalTo(self.view)
            make.top.equalTo(qqImageView.snp.bottom).offset(24)
        }

        toggleButton.snp.makeConstraints { make in
            make.top.equalTo(qqImageView.snp.bottom).offset(24 + 9)
            make.size.equalTo(CGSizeMake(16, 16))
            make.centerX.equalTo(self.view).offset(-270 / 2 - 10)
        }

        setupClickableLabel()
    }

    private func setupClickableLabel() {
        let text = "我已阅读并同意《用户协议》和《隐私政策》"
        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.text999Color(),
                .font: UIFont.systemFont(ofSize: 13),
            ]
        )

        // 设置可点击的范围
        let userAgreementRange = (text as NSString).range(of: "《用户协议》")
        let privacyPolicyRange = (text as NSString).range(of: "《隐私政策》")

        // 添加链接属性
        attributedString.addAttribute(.link, value: "useragreement://", range: userAgreementRange)
        attributedString.addAttribute(.link, value: "privacypolicy://", range: privacyPolicyRange)

        // 设置链接的颜色
        attributedString.addAttribute(.foregroundColor, value: UIColor.mainColor(), range: userAgreementRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.mainColor(), range: privacyPolicyRange)

        // 这里设置链接的颜色
        clickableLabel.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainColor()] // 设置链接的颜色

        clickableLabel.attributedText = attributedString
        clickableLabel.isUserInteractionEnabled = true
        clickableLabel.delegate = self
    }

    @objc private func toggleButtonTapped() {
        // 切换按钮的选中状态
        toggleButton.isSelected.toggle()
        updateButtonAppearance(isSelected: toggleButton.isSelected)
    }

    private func updateButtonAppearance(isSelected: Bool) {
        if isSelected {
            isAgress = false
            toggleButton.setBackgroundImage(UIImage(named: "login_not_select"), for: .normal)
        } else {
            isAgress = true
            toggleButton.setBackgroundImage(UIImage(named: "login_select"), for: .normal)
        }
    }

    lazy var backImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "app_login_top"))
        return imageView
    }()

    // 圆角背景
    lazy var mainBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()

    // 验证码登录和 密码登录的 button
    lazy var verButton: UIButton = {
        let button = UIButton()
        button.setTitle("验证码登录", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor.text999Color(), for: .normal)
        button.setTitleColor(UIColor.text333Color(), for: .selected)
        button.isSelected = true
        return button
    }()

    lazy var pwdButton: UIButton = {
        let button = UIButton()
        button.setTitle("密码登录", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor.text999Color(), for: .normal)
        button.setTitleColor(UIColor.text333Color(), for: .selected)
        button.isSelected = false
        return button
    }()

    // 一个底部的view
    lazy var buttonSelectView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = UIColor.mainColor()
        view.isHidden = true
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

    // 其他方式登录
    lazy var bottomInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ColorHex(hexStr: "#666666")
        label.textAlignment = .center
        label.text = "其他方式登录"
        return label
    }()

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

    // 验证码的View
    lazy var pwdVerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.backColor()
        view.layer.cornerRadius = 12
        return view
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

    // 密码的验证框
    lazy var passwordVerTextField: UITextField = {
        let textField = UITextField()
        // 设置最多输入4个字符
        textField.placeholder = "请输入密码"
        textField.isSecureTextEntry = true
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.text333Color()
        return textField
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

    // 忘记密码
    lazy var forgetPassword: UIButton = {
        let button = UIButton()
        button.setTitle("忘记密码", for: .normal)
        button.setTitleColor(UIColor.text999Color(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.textColor = UIColor.text999Color()
        button.isHidden = true
        return button
    }()

    // 一个渐变的按钮 从左到右的渐变背景的按钮
    lazy var loginButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 40, height: 44))
        button.setTitle("登录", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: ""), for: .normal)
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

    private let clickableLabel: UITextView = {
        let textView = UITextView()
        textView.isEditable = false // 禁止编辑
        textView.isSelectable = true // 允许选择
        textView.dataDetectorTypes = [] // 禁用自动检测
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    lazy var weiboImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "login_weibo"))
        return imageView
    }()

    lazy var wechatImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "login_wechat"))
        imageView.isUserInteractionEnabled = true
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loginWechat))
//        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()

    lazy var qqImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "login_qq"))
        return imageView
    }()

    lazy var toggleButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "login_not_select"), for: .normal)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // 验证登录和密码登录下面的渐变色
    lazy var bottomLineView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 5))
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [Color.hex("E84C4F").cgColor, Color.hex("FF7E3F").cgColor] // 设置渐变颜色
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5) // 从左到右
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5) // 从左到右
        view.layer.cornerRadius = 2.5
        view.layer.masksToBounds = true
        // 将渐变层添加到 gradientView 的图层中
        view.layer.insertSublayer(gradientLayer, at: 0)
        return view
    }()
}

extension LoginVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        switch URL.scheme {
        case "useragreement":
            navigateToWebView(with: userAgreeUrl()) // 替换为实际链

        case "privacypolicy":
            navigateToWebView(with: privateUrl()) // 替换为实际链
        default:
            break
        }
        return false
    }

    private func navigateToWebView(with url: String) {
        guard let url = URL(string: url) else { return }
        let webView = STWebView(url: url)
        let hostingController = UIHostingController(rootView: webView)
        // 检查 navigationController 是否为 nil
        if let navigationController = navigationController {
            navigationController.pushViewController(hostingController, animated: true)
        } else {
            // 如果 navigationController 为 nil，可以选择以模态方式呈现
            let modalNavigationController = UINavigationController(rootViewController: hostingController)
            modalNavigationController.navigationBar.isHidden = true
            present(modalNavigationController, animated: true) {
                modalNavigationController.setNavigationBarHidden(true, animated: false)
            }
        }
    }
}

extension LoginVC {
    func showIsNotAgree(completion: @escaping (Bool?) -> Void) {
        let customPopupView = FWPopupView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 90, height: 130))

        let centerItemView = LoginAgreeView(itemHeight: 130, onAgree: {
            self.updateButtonAppearance(isSelected: false)
            customPopupView.hide()
            completion(true)
        })

        let hostingController = UIHostingController(rootView: centerItemView)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        customPopupView.addSubview(hostingController.view)

        hostingController.view.snp.makeConstraints { make in
            make.size.equalTo(customPopupView)
            make.top.equalTo(customPopupView.top)
        }

        hostingController.view.layer.cornerRadius = 15
        hostingController.view.backgroundColor = .clear
        customPopupView.layer.cornerRadius = 15

        let vProperty = FWPopupViewProperty()
        vProperty.popupCustomAlignment = .center
        vProperty.popupAnimationType = .scale3D
        vProperty.maskViewColor = UIColor(white: 0, alpha: 0.5)
        vProperty.touchWildToHide = "1"
        vProperty.popupViewEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        vProperty.backgroundColor = .clear
        vProperty.animationDuration = 0.25
        customPopupView.vProperty = vProperty

        customPopupView.show()
    }
}
