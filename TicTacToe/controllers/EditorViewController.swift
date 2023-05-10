//
//  EditorViewController.swift
//  TicTacToe
//
//  Created by Cell on 08.05.2023.
//

import UIKit;
import AVFoundation;

class EditorViewController: UIViewController {
    
    @IBOutlet weak var _ViewGraphWaves: UIGraphWavesView!;
    
    private let TAG = "EditorViewController:";
    
    private let _HTTPS_URL_WAV_FILE = "https://www2.cs.uic.edu/~i101/SoundFiles/StarWars60.wav";
    private var _INFO_DATA: Data!;
    
    private var _AudioPlayer: AVAudioPlayer!;
    
    /*private let _HTTPS_URL_WAV_FILE = "https://file-examples.com/storage/fe0b859904645a822993054/2017/11/file_example_WAV_2MG.wav";*/
        
    private func configureGraphWave(_ data: Data) {
        
        let arr = ([UInt8])(data);
        
        _INFO_DATA = data.subdata(in: 0..<44);
        
        let dataSize = UInt32.from(([UInt8]) (arr[40...43]));
        print(self.TAG, "UINT8:",data, arr[40...43], dataSize);
        let upper = 44+dataSize;
        self._ViewGraphWaves.audioData = data.subdata(in: 44..<Int(upper));
        do {
            let audioInstance = AVAudioSession.sharedInstance();
            try audioInstance.setCategory(.playback);
            try audioInstance.setActive(true, options: .notifyOthersOnDeactivation);
            
            _AudioPlayer = try AVAudioPlayer(data: data, fileTypeHint: AVFileType.wav.rawValue);
            
            _AudioPlayer.play();
            
        } catch {
            print(TAG, "ERROR IS OCCURED WHILE LOADING AUDIO:",error.localizedDescription);
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        _ViewGraphWaves.delegate = self;
        
        let fileManager = FileManager.default;
        let cacheURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("sound.wav");
        
        
        // Checking an existing .wav file for editing
        print(TAG,"CHECKING URL PATH:",cacheURL.path);
        if fileManager.fileExists(atPath: cacheURL.path) {
            guard let data = fileManager.contents(atPath: cacheURL.path) else {
                return;
            };
            configureGraphWave(data);
            return;
        }
        
        // Downloading a file
        
        guard let url = URL(string: _HTTPS_URL_WAV_FILE) else {
            print(TAG,"INVALID URL");
            return;
        }
        
        print(TAG, "PREPARE TO DOWNLOAD...");
        
        URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: {
            data, response, error in
        
            print(self.TAG, "COMPLETING DOWNLOAD...");
            
            print(self.TAG,response);
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                print("RESPONE ERROR:");
                return;
            }
            
            guard let data = data, error == nil else {
                print(self.TAG, "THROWN AN ERROR:", error.debugDescription);
                return;
            }
            
            print(self.TAG,"DATA:",data);
            
            DispatchQueue.main.async {
                let arr = ([UInt8])(data);
                
                guard let dataTag = "data".data(using: .ascii) else {
                    return;
                }
                
                
                // Save file to the user's storage
                
                print("URL TO SAVE:",cacheURL);
                do {
                    try? data.write(to: cacheURL);
                } catch {
                    print(self.TAG, "THROWN AN EXCEPTION WHEN WRITING DATA TO A FILE:", error.localizedDescription);
                }
                
                let fileSize = UInt32.from(([UInt8])(arr[4..<8]));
                
                // Reading format chunk
                
                let channels = UInt16.from(([UInt8])(arr[22..<24]));
                let sampleRate = UInt32.from(([UInt8])(arr[24..<28]));
                let bitRate = UInt32.from(([UInt8])(arr[28..<32]));
                let blockAlign = UInt16.from(([UInt8])(arr[32..<34]));
                let bitDepth = UInt16.from(([UInt8])(arr[34..<36]));

                print("\nFILE INFO:");
                print("FILE SIZE:",fileSize);
                print("CHANNELS:", channels);
                print("SAMPLE RATE:", sampleRate);
                print("BIT RATE:", bitRate);
                print("BLOCK ALIGN:",blockAlign);
                print("BIT DEPTH:",bitDepth,"\n");
                
                self.configureGraphWave(data);
            }
            
        }).resume();
        
    }
}

extension EditorViewController: UIGraphWavesDelegate {
    
    func onClippedAudio(_ clippedData: Data) {
        print(TAG, "onClippedAudio():", clippedData);
        
        _AudioPlayer.stop();
        do {
            _AudioPlayer = try AVAudioPlayer(data: clippedData, fileTypeHint: AVFileType.wav.rawValue);
            _AudioPlayer.play();
        } catch {
            print("ERROR WHILE CONFIGURING AVAudioPlayer:",error.localizedDescription);
        }
        
    }
    
}

extension UInt32 {
    
    static func from(_ data: [UInt8]) -> UInt32 { // For big-endian order
        return UInt32(data[0]) |
        (UInt32(data[1]) << 8) |
        (UInt32(data[2]) << 16) |
        (UInt32(data[3]) << 24);
    }
}

extension UInt16 {
    
    static func from(_ data: [UInt8]) -> UInt16 {
        return UInt16(data[0]) | (UInt16(data[1]) << 8);
    }
}
