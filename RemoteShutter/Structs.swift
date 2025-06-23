//
//  Structs.swift
//  RemoteShutter
//
//  Created by CJ Balmaceda on 6/11/25.
//

import Foundation
import SwiftUI


struct allButtons: View{
    @Binding var output: String
    @Binding var isShowingEnterVal: Bool
    @Binding var isShowingShutdown: Bool
    @Binding var seconds: String
    @Binding var isShowingSheet: Bool
    @Binding var filename: String
    @Binding var image: Data?
    @Binding var fileList: [String]
    
    var body: some View{
        Buttons(title: "asdasddas"){
            Task{
                let fileList = await separateFiles()
                print(fileList)
            }
        }
        
        //test button
        Buttons(title: "test button"){
            Task{
                output = await sendCmdRewrite(command:"ls /samba")
                print(output)
            }}
        Buttons(title: "check ip"){
            Task{
                output = await sendCmdRewrite(command:"ifconfig")
                
            }}
        //ping the pi
        Buttons(title: "check ping"){
            Task{
                output = await sendCmdRewrite(command:"ping ceejpi.local -c 3")
            }}
        //check camera connection
        Buttons(title: "Check Camera"){
            Task{
                output = await sendCmdRewrite(command:"gphoto2 --auto-detect")
            }}            //take flick``
        Buttons(title: "Capture Image"){
            let time = getTime()
            //                debugPrint(time.hour)
            filename = "/samba/\(time.hour)-\(time.min)-\(time.sec).cr2"
            Task{
                output = await sendCmdRewrite(command:"sudo gphoto2 --filename '\(filename)' --capture-image-and-download")
            }}
        //
        Buttons(title: "Capture Image w/ Timer"){
            
            isShowingEnterVal = true
        }.alert("Timer", isPresented: $isShowingEnterVal){
            TextField("Value", text: $seconds)
            Button("Submit"){
                let time = getTime()
                filename = "/samba/\(time.hour)-\(time.min)-\(time.sec).cr2"
                Task{
                    output = await sendCmdRewrite(command:"sudo gphoto2 --wait-event=" + seconds + "s --filename '\(filename)' --capture-image-and-download")
                }}
            Button("Cancel", role: .cancel){}
        } message: {
            Text("Enter a number to set timer ")
        }
        Buttons(title: "Show Pic"){
            isShowingSheet = true
        }.sheet(isPresented: $isShowingSheet){
            VStack{
                if let imageData = image, let uiImage = UIImage(data:imageData){
                    Image(uiImage: uiImage).resizable().scaledToFit()
                }else if !filename.isEmpty{
                    ProgressView().onAppear{
                        Task {
                            print("fetching image")
                            image = await getPicture(filePath: filename)
                            
                            if let image = image {
                                print("image loaded: \(image.count) bytes")
                            } else {
                                print("image failed to load :(")
                            }
                        }
                    }
                }else{
                    Text("No Image")
                }
            }.onAppear{
                image = nil
            }
        }
        
        //self explanatory
        Buttons(title: "Shitdown device"){
            isShowingShutdown = true
        }.alert("Shutdown", isPresented: $isShowingShutdown){
            Button("Shutdown"){
                Task{
                    filename = ""
                    output = await sendCmdRewrite(command:"sudo shutdown -h now")
                    
                }
            }
            Button("Cancel", role: .cancel){
                
            }
        }
    }
}

//struct cameraControls: View{
//    @Binding var currentPath = [CC]
//    var body: some view{
//        
//    }
//}

struct cameraControls: View{
    @State private var output: String = ""
    @State private var isShowingEnterVal: Bool = false
    @State private var isShowingShutdown: Bool = false
    @State private var seconds: String = ""
    @State private var isShowingSheet = false
    @State private var filename: String = ""
    @State private var image: Data? = nil
    @State private var fileList: [String] = []
    var body: some View{
        VStack{
            allButtons(output: $output, isShowingEnterVal: $isShowingEnterVal, isShowingShutdown: $isShowingShutdown, seconds: $seconds, isShowingSheet: $isShowingSheet, filename: $filename, image: $image, fileList: $fileList)
            ScrollView{
                Text(output)
                    .padding()
                    .foregroundColor(.gray)
            }.frame(height:200)
            
        }.padding()
    }
}

struct viewGallery: View{
    @Binding var fileList: [String]
    @State private var images: [String:UIImage] = [:]
    @StateObject private var imageLoader = ImageLoader()

    let columns = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    var body: some View{
        ScrollView{
            LazyVGrid(columns: columns ){
                
                ForEach(fileList, id: \.self ){fileName in
                    VStack{
                        if let image = imageLoader.images[fileName] {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                        } else {
                            ProgressView()
                                .task {
                                    await imageLoader.loadImage(filename: fileName)
                                }
                        }
                        Text(fileName)
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .padding()
        .onAppear(){
            Task{
                fileList = await separateFiles()
            }
        }
        
    }
    
}
@MainActor
class ImageLoader: ObservableObject {
    @Published var images: [String: UIImage] = [:]

    func loadImage(filename: String) async {
        if let data = await getPicture(filePath: "/samba/\(filename)"),
           let uiImage = UIImage(data: data) {
            DispatchQueue.main.async {
                self.images[filename] = uiImage
            }
        }
    }
}

