
//
//  File.swift
//  ssssss
//
//  Created by Hesamoddin Saeedi on 11/7/23.
//

import SwiftUI
import AVFoundation



struct ContentView5: View {
    
    
    
    // counting user's tap
    @State private var tapCount = 0
    
    // Variable for creating player to play sound of numbers
    @State private var audioPlayer: AVAudioPlayer?
    
    // pointing to the array
    @State private var pointer : Int = 0
    
    // to check if inserted number is correct or not
    @State private var isPreviousChecked = true
    
    // measuring the gesture of button for numbers 6 to 9
    @State private var offset : CGSize = .zero
    
    // if its correct screen turns green
    @State private var turnsGreen = false
    
    @State private var offsetToColor : CGSize?
    
    // the width and the height of the phone
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    // main array of numbers
    @State var value : [Int] = [0,0,0,0,0,0]
    
    var body: some View {
        ZStack{
            VStack {
                
                // display of the array
                Group {
                    HStack(spacing:10) {
                        Text("\(value[0])")
                            .font(.system(size:30))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(20)
                        
                        
                        
                        Text("\(value[1])")
                            .font(.system(size:30))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(20)
                        
                        
                        Text("\(value[2])")
                            .font(.system(size:30))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(20)
                        
                        
                        Text("\(value[3])")
                            .font(.system(size:30))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(20)
                        
                        
                        Text("\(value[4])")
                            .font(.system(size:30))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(20)
                        
                        
                        Text("\(value[5])")
                            .font(.system(size:30))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(20)
                        
                    }
                }
           
                Spacer()
                    .frame(height:100)
                
                
                Circle()
                    .frame(width:200,height: 200)
                    .offset(offset)
                    .opacity(pointer<=5 ? 1 : 0)
                
                
                    // different kind of gestures to input number
                    .gesture(
                        
                        // long press for zero
                        LongPressGesture(minimumDuration: 2.0)
                                  .onEnded { _ in
                                      
                                      tapCount = 0
                                      updateNumber()
                                      
                                  }
                            .simultaneously(with:
                                                
                                                
                        // one tap for 1
                            TapGesture(count: 1)
                            .onEnded { _ in
                                    tapCount = 1
                                    updateNumber()
                            })
                            .simultaneously (with :
                                                
                                                
                            // two tap for 2

                        TapGesture(count: 2)
                            .onEnded { _ in
                                tapCount = 2
                                updateNumber()
                            })
                  
                            // three taps for 3

                            .simultaneously (with :
                        TapGesture(count: 3)
                            .onEnded { _ in
                                tapCount = 3
                                updateNumber()
                            })
                        
                            .simultaneously (with :
                                                
                           // for taps for 4

                        TapGesture(count: 4)
                            .onEnded { _ in
                                tapCount = 4
                                updateNumber()
                            })
                        
                            .simultaneously (with :
                                                
                          // 5 taps for 5
                        TapGesture(count: 5)
                            .onEnded { _ in
                                tapCount = 5
                                updateNumber()
                            })
                        
                     
                        
                                .exclusively (before :
                                                
                        // Drag gestures to input the rest of the numbers from 6 to 9
                        DragGesture()
                            // tracking the amount of dragging to decide which number is chosen
                            .onChanged { amount in
                                withAnimation(.spring()) {
                                    withAnimation(.spring()) {
                                        // Detecting Axis of drag gesture
                                        offset = amount.translation
                                        
                                        if offset.height < -20 && offset.height > -120 && offset.width < 30 &&  offset.width > -30 {
                                            
                                                offset = amount.translation
                                                tapCount = 6
                                            
                                        }else if  offset.width < -20 && offset.width > -120 && offset.height < 30 && offset.height > -30 {
                                            
                                                offset = amount.translation
                                                tapCount = 7
                                            
                                        }else if offset.width < 30 &&  offset.width > -30 && offset.height > 120 && offset.height < 320 {
                                                offset = amount.translation
                                                tapCount = 8
                                            
                                        }else if  offset.height < 30 && offset.height > -30 && offset.width > 120 && offset.width < 320 {
                                                offset = amount.translation
                                                tapCount = 9
                                        }else{}
                                                }
                                            }
                                    }
                            .onEnded { value in
                                withAnimation(.spring()) {
                                    // when the dragging is done the offset amount must be returned to zero because if not the circle stays at where it was dragged
                                        offset = .zero
                                    // switch selects the number and updates the array
                                   updateNumber()
                                    }
                            }
                    )
            )}
            
            
            // this pops up when user inserts a number to play the sound and ask if it is the correct number or not
            ZStack {
                Rectangle()
                    .opacity(isPreviousChecked ? 0 : 1)
                    .frame(width:width,height: height)
                    .foregroundColor(turnsGreen ? .green : .red)
                   
                Text("\(tapCount)")
                    .font(.system(size:600))
                    .opacity(isPreviousChecked ? 0 : 1)
                    .gesture(
                        // two taps to undo the imported number
                        TapGesture(count: 2)
                            
                        .onEnded{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isPreviousChecked = true
                                
                                // the pointer returns to the previous item of array
                                pointer -= 1
                                
                                // the array's item gets cleaned
                                value[pointer] = 0
                                
                                // wrong sound plays to keep the user aware of the process
                                playSound("wrong")
                            }
                        }
                            .exclusively(before:
                                            // one tap means the imported number is correct
                                            TapGesture(count: 1)
                                            .onEnded{
                                                turnsGreen = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    isPreviousChecked = true
                                                    turnsGreen = false
                                                    playSound("correct")
                                                }
                                            }))
                         }
        }
            
            
                      
                                     
    }
    
    
        // the most simple function to play a sound in Swiftui
 
    func playSound(_ num : String) {
            if let soundURL = Bundle.main.url(forResource: "\(num)", withExtension: "m4a") {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    audioPlayer?.play()
                } catch {
                    print("Error playing the sound: \(error.localizedDescription)")
                }
            }
        }
    
    
    // function including switch from 0 to 9 plus default
    
    func updateNumber() {
        switch tapCount {
        case 0:
            updateField(0)
            break
        case 1:
            updateField(1)
            break
        case 2:
            updateField(2)
        case 3:
            updateField(3)
        case 4:
            updateField(4)
        case 5:
            updateField(5)
        case 6:
            updateField(6)
        case 7:
            updateField(7)
        case 8:
            updateField(8)
        case 9:
            updateField(9)
        default:
            updateField(10)
            break
        }
    }
    
    // the main function to import the number into the array
    
    func updateField(_ num:Int) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print(tapCount)
            
            
            if tapCount == num {
                value[pointer] = num
                if pointer > 5 {
                    return
                }
                else {
                    pointer += 1
                    self.playSound("\(num)")
                    isPreviousChecked = false
                }
            }

        }
    }
    
}



@available(iOS 16.0, *)
struct ContentView5_Previews: PreviewProvider {
    static var previews: some View {
        ContentView5()
       

    }
}




