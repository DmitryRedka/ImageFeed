import UIKit

final class AuthViewController: UIViewController {

    private let segueWebViewIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegateProtocol?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueWebViewIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                assertionFailure("Failed to prepare for \(segueWebViewIdentifier)")
                return
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

}

extension AuthViewController: WebViewViewControllerDelegateProtocol {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
