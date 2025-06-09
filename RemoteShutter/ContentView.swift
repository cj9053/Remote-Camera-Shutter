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
    
    
    var body: some View {
        VStack {
            //ifconfig
            Buttons(title: "check ip"){
                sendCommand(command:"ifconfig"){result in
            output = result}}
            //ping the pi
            Buttons(title: "check ping"){
                sendCommand(command:"ping ceejpi.local -c 3"){result in
            output = result}}
            //check camera connection
            Buttons(title: "Check Camera"){
                sendCommand(command:"gphoto2 --auto-detect"){result in
            output = result}}
            //take flick``
            Buttons(title: "Capture Image"){
                let time = getTime()
//                debugPrint(time.hour)
                filename = "/samba/\(time.hour)-\(time.min)-\(time.sec).cr2"
//                print("filename: \(filename)")
                sendCommand(command:"sudo gphoto2 --filename '\(filename)' --capture-image-and-download"){result in
            output = result}}
            //
            Buttons(title: "Capture Image w/ Timer"){
                
                isShowingEnterVal = true
            }.alert("Timer", isPresented: $isShowingEnterVal){
                TextField("Value", text: $seconds)
                Button("Submit"){
                    let time = getTime()
                    filename = "/samba/\(time.hour)-\(time.min)-\(time.sec).cr2"
//                    sendCommand(command:"sudo gphoto2 --wait-event=" + seconds + "s --filename '/samba/\(time.hour)-\(time.min)-\(time.sec).%C' --capture-image-and-download"){result in
//                    output = result}
//                }
                sendCommand(command:"sudo gphoto2 --wait-event=" + seconds + "s --filename '\(filename)' --capture-image-and-download"){result in
                output = result}
            }
                Button("Cancel", role: .cancel){
                    
                }
            } message: {
                Text("Enter a number to set timer ")
            }
            Buttons(title: "Show Pic"){
                isShowingSheet = true
            }.sheet(isPresented: $isShowingSheet){
                VStack{
                    if let imageData = image, let uiImage = UIImage(data:imageData){
                        Image(uiImage: uiImage).resizable().scaledToFit()
                    }else{
                        Text("loading").onAppear{
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
                    }
                }
            }
            
            //self explanatory
            Buttons(title: "Shitdown device"){
                isShowingShutdown = true
            }.alert("Shutdown", isPresented: $isShowingShutdown){
                Button("Shutdown"){
                    sendCommand(command:"sudo shutdown -h now"){result in
                    output = result}
                }
                Button("Cancel", role: .cancel){
                    
                }
            }
            
            
            

            //sendCommand(command:"sudo gphoto2 --wait-event=5s --filename '/samba/%H-%M-%S.%C' --capture-image-and-download"){result in
//            output = result}
            
            ScrollView{
                Text(output)
                        .padding()
                        .foregroundColor(.gray)
            }.frame(height:200)
           
        }
        .padding()
    }



}




