import Foundation

public class LoginInfo {
    public let host: String
    public let username: String
    public let password: String
    
    public init(host: String, username:String, password: String) {
        self.host = host
        self.username = username
        self.password = password
    }
}