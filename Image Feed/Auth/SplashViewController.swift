import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    
    private let showAuthentificationScreenSegueIdentification = "showAuthentificationScreen"
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = OAuth2TokenStorage().token {
            switchTapBarController()
        } else {
            performSegue(withIdentifier: showAuthentificationScreenSegueIdentification, sender: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func switchTapBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid to switch TapBarController")
            return
        }
        let tapBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tapBarController
    }
}
extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthentificationScreenSegueIdentification {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure(("Failed to prepare \(showAuthentificationScreenSegueIdentification)"))
                return
            }
            viewController.delegate = self
        } else {
            prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegateProtocol {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else {return}
            self.fetchOAuthToken(code)
        }
    }
    private func fetchOAuthToken(_ code: String) {
        OAuth2Service.shared.fetchAuthToken(didAuthenticateWithCode: code) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success:
                UIBlockingProgressHUD.dismiss()
                self.switchTapBarController()
                
            case .failure:
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
}
