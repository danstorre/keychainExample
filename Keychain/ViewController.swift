//
//  ViewController.swift
//  Keychain
//
//  Created by Daniel Torres on 3/31/18.
//  Copyright © 2018 dansTeam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    let account = "asd@deezer.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        do{
            let token =  try Keychain.shared.getTokenDeezer(fromAccount: account)
            print("the token \(token)")
            
            try Keychain.shared.updateDeezerToken(token: "thenewtoken", fromAccount: account)
            let newToken =  try Keychain.shared.getTokenDeezer(fromAccount: account)
            print("the token updated \(newToken)")
        
        }catch KeychainError.noPassword {
            print("adding token..")
            addToken()
        }
        catch KeychainError.unexpectedPasswordData {
            print("unexpectedPasswordData")
        }
        catch KeychainError.unhandledError(let x) {
            print("unhandledError \(x)")
        }
        catch {
            print("weoifwe")
        }
        

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func addToken(){
        
        do{
            try Keychain.shared.addDeezerToken(token: "thepassword2", fromAccount: account)
        }catch KeychainError.noPassword {
            print("no password")
        }
        catch KeychainError.unexpectedPasswordData {
            print("unexpectedPasswordData")
        }
        catch KeychainError.unhandledError(let x) {
            print("unhandledError \(x)")
        }
        catch {
            print("weoifwe")
        }
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

