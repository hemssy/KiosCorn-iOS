import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // UIWindow 객체 생성.
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        // window 에게 루트(가장 밑에깔리는) 뷰 지정.
        window.rootViewController = ViewController()
        
         // 이 메서드를 반드시 작성해줘야 윈도우가 활성화 됨.
        window.makeKeyAndVisible()
        
        self.window = window //방금 만든 윈도우를 여기 넣어줌
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

