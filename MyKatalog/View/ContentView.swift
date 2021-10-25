//
//  ContentView.swift
//  MyKatalog
//
//  Created by Rani Triani Gustia on 19/10/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            KatalogList()
        }
        .onAppear{
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            AppDelegate.orientationLock = .portrait
        }.onDisappear{
            AppDelegate.orientationLock = .all
        }
    }
}

