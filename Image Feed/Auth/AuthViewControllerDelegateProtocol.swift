import Foundation

protocol AuthViewControllerDelegateProtocol: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
