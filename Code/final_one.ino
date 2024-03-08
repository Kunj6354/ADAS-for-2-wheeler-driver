#include <Wire.h>
#include <SD.h>
#include <MPU6050_tockn.h>

MPU6050 mpu6050(Wire);

File mainFile;
File pointerFile;

int fileNumber = 0; // Variable to store the file number

const int buttonD7 = 7;
const int buttonD8 = 8;
const int buttonD9 = 9;
const int buttonD10 = 6;

const char normalDriving[] PROGMEM = "normal_driving";
const char rashDriving[] PROGMEM = "rash_driving";
const char normalTurn[] PROGMEM = "normal_turn";
const char rashTurn[] PROGMEM = "rash_turn";
const char nanString[] PROGMEM = "NAN";

uint32_t tsLastReport = 0;

void setup() {
  Serial.begin(9600);
  Wire.begin();
  mpu6050.begin();
  mpu6050.calcGyroOffsets(true);
  // pinMode(buttonD10, INPUT_PULLDOWN);

  if (!initializeSDCard()) {
    Serial.println(F("Failed to initialize SD card. Please check connections and restart."));
    while (1);
  }

  initializeFileNumber();
  createNewFile();
}

void loop() {
  mpu6050.update();
  float accelerometerData[3] = {mpu6050.getAccX(), mpu6050.getAccY(), mpu6050.getAccZ()};
  float gyroscopeData[3] = {mpu6050.getGyroAngleX(), mpu6050.getGyroAngleY(), mpu6050.getGyroAngleZ()};

  String annotation = getAnnotation();

  mainFile = SD.open("main" + String(fileNumber) + ".csv", FILE_WRITE | O_APPEND);

  if (mainFile) {
    recordData(mainFile, accelerometerData, gyroscopeData, annotation); // Set heartRate and spo2 to 0
    mainFile.close();
    Serial.println(F("MPU6050 Data recorded"));
  } else {
    Serial.println(F("Error opening main file"));
  }

  delay(5);
}

bool initializeSDCard() {
  return SD.begin(5); // CS at D5, MOSI at D4, SCK at D13, MISO at TX0
}

void initializeFileNumber() {
  pointerFile = SD.open("pointer.txt", FILE_READ);

  if (pointerFile) {
    fileNumber = pointerFile.parseInt();
    pointerFile.close();
    Serial.print(F("File number initialized: "));
    Serial.println(fileNumber);
  } else {
    Serial.println(F("Error opening pointer file"));
  }
}

void createNewFile() {
  mainFile = SD.open("main" + String(fileNumber) + ".csv", FILE_WRITE);
  
  if (mainFile) {
    mainFile.println(F("Timestamp,AccX,AccY,AccZ,GyroX,GyroY,GyroZ,Annotation"));
    mainFile.close();
    Serial.print(F("New file created: main"));
    Serial.print(fileNumber);
    Serial.println(F(".csv"));

    fileNumber++;
    if (SD.exists("pointer.txt")) {
    SD.remove("pointer.txt");
    Serial.println(F("Existing pointer.txt deleted"));
  }
    pointerFile = SD.open("pointer.txt", FILE_WRITE);
    if (pointerFile) {
      pointerFile.print(fileNumber);
      pointerFile.close();
    } else {
      Serial.println(F("Error opening pointer file for writing"));
    }
  } else {
    Serial.println(F("Error creating new main file"));
  }
}

void recordData(File& file, float accelerometerData[3], float gyroscopeData[3], String annotation) {
  file.print(millis());
  file.print(',');
  file.print(accelerometerData[0]);
  file.print(',');
  file.print(accelerometerData[1]);
  file.print(',');
  file.print(accelerometerData[2]);
  file.print(',');
  file.print(gyroscopeData[0]);
  file.print(',');
  file.print(gyroscopeData[1]);
  file.print(',');
  file.print(gyroscopeData[2]);
  // file.print(',');
  // file.print(heartRate);
  // file.print(',');
  // file.print(spo2);
  file.print(',');
  file.println(annotation);
}

String getAnnotation() {
  delay(5);  // Add a small delay for button debouncing
  if (digitalRead(buttonD7) == HIGH) {
    return F("normal_driving");
  } else if (digitalRead(buttonD8) == HIGH) {
    return F("rash_driving");
  } else if (digitalRead(buttonD9) == HIGH) {
    return F("normal_turn");
  } else if (digitalRead(buttonD10) == HIGH) {
    // delay(50);  // Add an additional delay for button debouncing
    if (digitalRead(buttonD10) == HIGH) {
      Serial.println("rash_turn");
      return F("rash_turn");
    }
  }
  return F("NAN");
}