const int switchPins[] = {7, 8, 9, 6}; // Array to store pin numbers
const int numSwitches = sizeof(switchPins) / sizeof(switchPins[0]); // Calculate the number of switches

void setup() {
  Serial.begin(9600); // Initialize serial communication
  for (int i = 0; i < numSwitches; i++) {
    pinMode(switchPins[i], INPUT_PULLUP); // Set all switch pins as INPUT_PULLUP
  }
}

void loop() {
  for (int i = 0; i < numSwitches; i++) {
    int switchState = digitalRead(switchPins[i]); // Read the state of the current switch
    if (switchState == HIGH) {
      Serial.print("Switch ");
      Serial.print(i + 1);
      Serial.print(" (Pin ");
      Serial.print(switchPins[i]);
      Serial.println(") is pressed");
    }
     // Add a small delay to debounce and avoid rapid readings
  }
  // delay(100);
}