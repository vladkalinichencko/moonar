//
//  moonarApp.swift
//  moonar
//
//  Created by Владислав Калиниченко on 05.04.2022.
//

import SwiftUI

@main
struct moonarApp: App {
    var body: some Scene {
        WindowGroup {
			ContentView()
				.preferredColorScheme(.dark)
				.previewInterfaceOrientation(.portrait)
        }
    }
}

#if DEBUG
let certificate = "StoreKitTestCertificate"
#else
let certificate = "AppleIncRootCertificate"
#endif
