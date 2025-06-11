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
    
    var body: some View {
        VStack {
            allButtons(output: $output, isShowingEnterVal: $isShowingEnterVal, isShowingShutdown: $isShowingShutdown, seconds: $seconds, isShowingSheet: $isShowingSheet, filename: $filename, image: $image, fileList: $fileList)
//            Buttons(title: "asdasddas"){
//                Task{
//                    let fileList = await separateFiles()
//                    print(fileList)
//                }
//            }
//            
//            //test button
//            Buttons(title: "test button"){
//                Task{
//                    output = await sendCmdRewrite(command:"ls /samba")
//                    print(output)
//                }}
//            Buttons(title: "check ip"){
//                Task{
//                    output = await sendCmdRewrite(command:"ifconfig")
//                    
//                }}
//            //ping the pi
//            Buttons(title: "check ping"){
//                Task{
//                    output = await sendCmdRewrite(command:"ping ceejpi.local -c 3")
//                }}
//            //check camera connection
//            Buttons(title: "Check Camera"){
//                Task{
//                    output = await sendCmdRewrite(command:"gphoto2 --auto-detect")
//                }}            //take flick``
//            Buttons(title: "Capture Image"){
//                let time = getTime()
//                //                debugPrint(time.hour)
//                filename = "/samba/\(time.hour)-\(time.min)-\(time.sec).cr2"
//                Task{
//                    output = await sendCmdRewrite(command:"sudo gphoto2 --filename '\(filename)' --capture-image-and-download")
//                }}
//            //
//            Buttons(title: "Capture Image w/ Timer"){
//                
//                isShowingEnterVal = true
//            }.alert("Timer", isPresented: $isShowingEnterVal){
//                TextField("Value", text: $seconds)
//                Button("Submit"){
//                    let time = getTime()
//                    filename = "/samba/\(time.hour)-\(time.min)-\(time.sec).cr2"
//                    Task{
//                        output = await sendCmdRewrite(command:"sudo gphoto2 --wait-event=" + seconds + "s --filename '\(filename)' --capture-image-and-download")
//                    }}
//                Button("Cancel", role: .cancel){}
//            } message: {
//                Text("Enter a number to set timer ")
//            }
//            Buttons(title: "Show Pic"){
//                isShowingSheet = true
//            }.sheet(isPresented: $isShowingSheet){
//                VStack{
//                    if let imageData = image, let uiImage = UIImage(data:imageData){
//                        Image(uiImage: uiImage).resizable().scaledToFit()
//                    }else{
//                        Text("loading").onAppear{
//                            Task {
//                                print("fetching image")
//                                image = await getPicture(filePath: filename)
//                                
//                                if let image = image {
//                                    print("image loaded: \(image.count) bytes")
//                                } else {
//                                    print("image failed to load :(")
//                                }
//                            }
//                        }
//                    }
//                }.onAppear{
//                    image = nil
//                }
//            }
//            
//            //self explanatory
//            Buttons(title: "Shitdown device"){
//                isShowingShutdown = true
//            }.alert("Shutdown", isPresented: $isShowingShutdown){
//                Button("Shutdown"){
//                    Task{
//                        output = await sendCmdRewrite(command:"sudo shutdown -h now")
//                    }
//                }
//                Button("Cancel", role: .cancel){
//                    
//                }
//            }

            ScrollView{
                Text(output)
                    .padding()
                    .foregroundColor(.gray)
            }.frame(height:200)
            
        }
        .padding()
    }
    
    
    
}


