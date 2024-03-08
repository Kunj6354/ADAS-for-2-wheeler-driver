#include <Wire.h>
#include <SD.h>
#include <SoftwareSerial.h>
#include <MPU6050_tockn.h>
#include <TinyGPSPlus.h>

MPU6050 mpu6050(Wire);
File testfile;
long timer = 0;

void setup() {
  Serial.begin(9600);
  Wire.begin();
  mpu6050.begin();
  mpu6050.calcGyroOffsets(true);
  if (!SD.begin(5)) { // CS at D5, MOSI at D4, SCK at D13, MISO at TX0
    // Failed to initialize the SD card
    while (1);
  }

  // Open the file for writing
  testfile = SD.open("testfile.csv", FILE_WRITE);

  // Check if the file opened successfully
  if (testfile) {
    // Close the file immediately after opening it
    testfile.close();
  } else {
    // If the file failed to open, print an error message
    Serial.println("Error opening file");
  }
}

void loop() {
  mpu6050.update();
  float accelerometerData[3] = {-1, -1, -1}; // Initialize with -1 to indicate no data
  float gyroscopeData[3] = {-1, -1, -1}; 

  gyroscopeData[0] = mpu6050.getGyroAngleX();
  gyroscopeData[1] = mpu6050.getGyroAngleY();
  gyroscopeData[2] = mpu6050.getGyroAngleZ();
  accelerometerData[0] = mpu6050.getAccX();
  accelerometerData[1] = mpu6050.getAccY();
  accelerometerData[2] = mpu6050.getAccZ();

  // Reopen the file for writing in each loop iteration
  testfile = SD.open("testfile.csv", FILE_WRITE);

  // Check if the file opened successfully
  if (testfile) {
    recordData(testfile, accelerometerData, gyroscopeData);
    testfile.close(); // Close the file after writing
    Serial.println("Printed");
  } else {
    // If the file failed to open, print an error message
    Serial.println("Error opening file");
  }

  delay(1000); // Optional delay to slow down the output for better readability
}

void recordData(File& file, float accelerometerData[3], float gyroscopeData[3]) {
  file.print(millis());
  file.print(",");
  file.print(accelerometerData[0]);
  file.print(",");
  file.print(accelerometerData[1]);
  file.print(",");
  file.print(accelerometerData[2]);
  file.print(",");
  file.print(gyroscopeData[0]);
  file.print(",");
  file.print(gyroscopeData[1]);
  file.print(",");
  file.println(gyroscopeData[2]);
}
