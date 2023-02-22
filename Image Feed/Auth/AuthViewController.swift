import UIKit

final class AuthViewController: UIViewController {
    private let segueWebViewIdentifier = "ShowWebView"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueWebViewIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                fatalError("Failed to prepare for \(segueWebViewIdentifier)")
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegateProtocol {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        // TODO code
        //OAuth2Service.shared.fetchAuthToken(didAuthenticateWithCode: code, completion:<#(Result<String, Error>) -> Void#>)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    
}
