//
//  Functions.swift
//  RemoteShutter
//
//  Created by CJ Balmaceda on 5/26/25.
//

import Foundation
import SwiftUICore

struct Response: Codable{
    let output: String?
    let error: String?
}

//load response


func getTime()-> (hour: Int, min: Int, sec: Int){
    let date = Date()
    var calendar = Calendar.current
    if let timeZone = TimeZone(identifier: "America/New_York"){
        calendar.timeZone = timeZone
    }
    let hour = calendar.component(.hour, from: date)
    let min = calendar.component(.minute, from: date)
    let sec = calendar.component(.second, from: date)
    return (hour, min, sec)
}

//func sendCommand(command: String, completion: @escaping (String) -> Void) {
//    guard let url = URL(string: "http://10.20.1.1:5000/run") else {
//        completion("Invalid URL")
//        return
//    }
//
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//    let json: [String: String] = ["command": command]
//    request.httpBody = try? JSONSerialization.data(withJSONObject: json)
//
//    Task {
//        do {
//            let (data, _) = try await URLSession.shared.data(for: request)
//            let response = try JSONDecoder().decode(Response.self, from: data)
//            DispatchQueue.main.async {
//                completion(response.output ?? "No output")
//            }
//        } catch {
//            DispatchQueue.main.async {
//                completion("Error: \(error.localizedDescription)")
//            }
//        }
//    }
//}


//creating api call
//initialize url object
//initialize request object
//initialize json encoding(payload)/decoding(response)

//return response


func sendCmdRewrite(command: String) async -> String{
    guard let url = URL(string: "http://10.20.1.1:5000/run")else{
        return ("Invalid URL")
        
    }
    //init request object
    var request = URLRequest(url:url)
    //set httpmethod
    request.httpMethod = "POST"
    //set header val
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //init json payload
    request.httpBody = try? JSONSerialization.data(withJSONObject: ["command": command])
    
    //once "command" is sent, asynchronously wait for response
    do {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
        return "Server error: \(response)"
            
        }
        if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data){
            return decodedResponse.output ?? "No output"
        }else{
            return "Decoding Error"
        }
    } catch {
        return "Error: \(error.localizedDescription)"
    }
}

    
// load all pictures
// get list of files using ls
// once list of files is acquired
// asynchronously load it in the background
// another functionality is to have separate tab specifically for the images

//func getAllImages() async -> Data?{
//    guard let url = URL(string:  "http://10.20.1.1:5000/image")else{
//        print("Invalid URL")
//        return  nil
//    }
//    
//    
//}

func separateFiles() {
    
   
}

func getPicture(filePath: String) async -> Data?{
    guard let url = URL(string: "http://10.20.1.1:5000/image")else{
        print("Invalid URL")
        return nil
    }
    
    var request = URLRequest(url:url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let json: [String:Any] = ["filepath": "\(filePath)"]
    
    
    
    do{
        request.httpBody = try JSONSerialization.data(withJSONObject: json)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Server error: \(response)")
                    return nil
                }

                return data
            } catch {
                print("Error fetching image: \(error.localizedDescription)")
                return nil
            }
}
