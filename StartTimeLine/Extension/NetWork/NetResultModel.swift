import UIKit
import SwiftyJSON

enum NetStatus {
    case success
    case fail
    case code_error  //code码 校验异常
    case error
    case noNetWork
}

class NetResultModel: NSObject {
    
    var status:NetStatus!
    var data:Dictionary<String, Any>?
    var code:Int = 0
    var msg:String = ""
    var jsonStr:String?
    
}

