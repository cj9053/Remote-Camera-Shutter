//
//  ContentView.swift
//  RemoteShutter
//
//  Created by CJ Balmaceda on 5/24/25.
//

import SwiftUI



struct Buttons: View{
    let title: String
    let action: () -> Void
    var body: some View {
        Button{
            action()
        }label: {
            Text(title)
                .frame(maxWidth: .infinity)
                .frame(height: 25)
        }
        .buttonStyle(.bordered)
        .frame(maxWidth: .infinity)
        
    }
}


struct ContentView: View {
    @State private var output: String = ""
    @State private var isShowingEnterVal: Bool = false
    @State private var isShowingShutdown: Bool = false
    @State private var seconds: String = ""
    @State private var isShowingSheet = false
    @State private var filename: String = ""
    @State private var image: Data? = nil
    @State private var fileList: [String] = []
    @State private var selection: Int = 0
    var body: some View {
        //        VStack {
        TabView(selection: $selection){
            Tab("Camera Controls", systemImage: "camera.fill",value: 0){
                cameraControls()
            }
            Tab("Gallery", systemImage: "photo",value: 1){
                viewGallery(fileList: $fileList)
            }
        }
    }
}



#Preview{
    ContentView()
}
