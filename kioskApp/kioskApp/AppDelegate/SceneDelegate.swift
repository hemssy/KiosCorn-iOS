import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // UIWindow 객체 생성.
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        // #9. 스플래시 화면 담당 뷰 컨트롤러
        let splashVC = SplashViewController()
        
        // window 에게 루트(가장 밑에깔리는) 뷰 지정.
        // #9. splash화면으로 변경함
        window.rootViewController = splashVC
        
         // 이 메서드를 반드시 작성해줘야 윈도우가 활성화 됨.
        window.makeKeyAndVisible()
        
        self.window = window //방금 만든 윈도우를 여기 넣어줌
        
        let rootVC = ViewController()
        
        // #9. 1.0초 후에 메인화면으로 변경됨
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let navigationController = UINavigationController(rootViewController: rootVC)
            // #9.트랜지션 추가
            UIView.transition(
                with: window, duration: 0.3, options: .transitionCrossDissolve,
                animations: {
                    self.window?.rootViewController = navigationController
                },
                completion: nil
            )

        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

