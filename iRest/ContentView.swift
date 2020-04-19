//
//  ContentView.swift
//  iRest
//
//  Created by Kaumon Aung on 19.04.20.
//  Copyright © 2020 Kaumon Aung. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = Date()
    @State private var amountOfSleep: Double = 8
    @State private var coffeeAmount = 1
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    var body: some View {
        
        NavigationView {
            Form {
                VStack(alignment: .leading) {
                        Text("When do you want to wake up?")
                        DatePicker(selection: $wakeUp, displayedComponents: .hourAndMinute) {
                            Text("When do you want to wake up?")
                        }
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Desired amount of sleep")
                            .fontWeight(.semibold)
                        Stepper(value: $amountOfSleep, in: 1...14, step: 0.25) {
                            Text("\(amountOfSleep, specifier: "%g") hours")
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Daily cofee intake")
                        .fontWeight(.semibold)
                        Stepper(value: $coffeeAmount, in: 1...20) {
                            if coffeeAmount > 1 {
                                Text("\(coffeeAmount) cups")
                            } else {
                                Text("\(coffeeAmount) cup")
                            }
                        }
                    }
            }
        .navigationBarTitle("iRest")
        .navigationBarItems(trailing: Button(action: {
            self.calculateBedtime()
            }, label: {
                Text("Calculate")
            }))
        }
        
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text("Your ideal bedtime is \(alertMessage)"), dismissButton: .default(Text("Great")))
        }
    }
    
    func calculateBedtime() {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: amountOfSleep, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Good night!"
        } catch {
            alertTitle = "Error!"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
