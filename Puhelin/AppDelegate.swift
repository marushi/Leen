//
//  AppDelegate.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/11.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import StoreKit
import Firebase
import GoogleMobileAds
import FBSDKLoginKit
import FirebaseMessaging
import UserNotifications
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PurchaseManagerDelegate{

    var window: UIWindow?
    var didBecomeActiveBool:Bool = false
    
    //--------select,down,good,footユーザーデータ用変数------------//
    var selectUserData:[FootUsers] = []
    var downUserData:[FootUsers] = []
    var goodUserData:[FootUsers] = []
    var FootUserData:[FootUsers] = []
    //string文字列
    var selectIdArray:[String] = []
    var downIdArray:[String] = []
    var goodIdArray:[String] = []
    var footIdArray:[String] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //---------------------------------------
        // アプリ内課金設定
        //---------------------------------------
        // デリゲート設定
        PurchaseManager.sharedManager().delegate = self
        // オブザーバー登録
        SKPaymentQueue.default().add(PurchaseManager.sharedManager())
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //---------------------------------------
        //通知設定
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        IQKeyboardManager.shared.enable = true
        return true
    }
    
    //FBログイン
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled:Bool = ApplicationDelegate.shared.application(app, open: url, options: options)
        return handled
    }
    
    //FBログイン
    func applicationDidBecomeActive(_ application: UIApplication) {
        //通知を０に
        UIApplication.shared.applicationIconBadgeNumber = 0
        var DB:String!
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            DB = Const.MalePath
        }else{
            DB = Const.FemalePath
        }
        let dataDict:[String:Any] = ["newMesNum":0]
        let FIRref = Firestore.firestore().collection(DB).document(Auth.auth().currentUser!.uid)
        FIRref.setData(dataDict,merge: true)
        
        AppEvents.activateApp()
    }
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    //
    //課金処理
    //
    // 課金終了(前回アプリ起動時課金処理が中断されていた場合呼ばれる)
    func purchaseManager(_ purchaseManager: PurchaseManager!, didFinishUntreatedPurchaseWithTransaction transaction: SKPaymentTransaction!, decisionHandler: ((_ complete: Bool) -> Void)!) {
        print("#### didFinishUntreatedPurchaseWithTransaction ####")
        // TODO: コンテンツ解放処理
        //コンテンツ解放が終了したら、この処理を実行(true: 課金処理全部完了, false 課金処理中断)
        decisionHandler(true)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //////////////// ▼▼ 追加 ▼▼ ////////////////
        // オブザーバー登録解除
        SKPaymentQueue.default().remove(PurchaseManager.sharedManager());
        //////////////// ▲▲ 追加 ▲▲ ////////////////
    }
    
    //-------------------------
    //通知処理
    // クラス内の他のdelegateメソッドと同じ階層に追記
    //優先される
     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // Print message ID.
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Print message ID.
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }
}

//----------------------------
//通知処理
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
   func userNotificationCenter(_ center: UNUserNotificationCenter,
                               willPresent notification: UNNotification,
                               withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       let userInfo = notification.request.content.userInfo

       if let messageID = userInfo["gcm.message_id"] {
           print("Message ID: \(messageID)")
       }

       print(userInfo)

       completionHandler([])
   }

   func userNotificationCenter(_ center: UNUserNotificationCenter,
                               didReceive response: UNNotificationResponse,
                               withCompletionHandler completionHandler: @escaping () -> Void) {
       let userInfo = response.notification.request.content.userInfo
       if let messageID = userInfo["gcm.message_id"] {
           print("Message ID: \(messageID)")
       }

       print(userInfo)

       completionHandler()
   }
}

//通知トークンの処理
extension AppDelegate:MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let uid = Auth.auth().currentUser?.uid
        if uid == nil {
            return
        }else{
            let dataDict:[String: String] = ["token": fcmToken]
            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
            UserDefaults.standard.set(fcmToken, forKey: "token")
        }
    }

}
