import processing.serial.*;  
import java.awt.event.KeyEvent;  
import java.io.IOException;  

Serial myPort;  
String angle = "";  
String distance = "";  
String data = "";  
String noObject;  
float pixsDistance;  
int iAngle, iDistance;  
int index1 = 0;  

void setup() {  
  size(1200, 700);  // Adjust to your screen resolution  
  smooth();  
  myPort = new Serial(this, "COM4", 115200);  // Check if "COM7" is correct for your ESP32  
  myPort.bufferUntil('.');  
}  

void draw() {  
  fill(98, 245, 31);  
  noStroke();  
  fill(0, 4);  
  rect(0, 0, width, height - height * 0.065);  

  fill(98, 245, 31);  
  drawRadar();  
  drawLine();  
  drawObject();  
  drawText();  
}  

void serialEvent(Serial myPort) {  
  data = myPort.readStringUntil('.');  
  if (data != null) {  
    data = data.trim();  
    if (data.length() > 0) {  
      index1 = data.indexOf(",");  
      if (index1 > 0) {  
        angle = data.substring(0, index1);  
        distance = data.substring(index1 + 1);  

        try {  
          iAngle = int(angle);  
          iDistance = int(distance);  
        } catch (Exception e) {  
          println("Error parsing data: " + data);  
        }  
      }  
    }  
  }  
}  

void drawRadar() {  
  pushMatrix();  
  translate(width / 2, height - height * 0.074);  
  noFill();  
  strokeWeight(2);  
  stroke(98, 245, 31);  

  arc(0, 0, width - width * 0.0625, width - width * 0.0625, PI, TWO_PI);  
  arc(0, 0, width - width * 0.27, width - width * 0.27, PI, TWO_PI);  
  arc(0, 0, width - width * 0.479, width - width * 0.479, PI, TWO_PI);  
  arc(0, 0, width - width * 0.687, width - width * 0.687, PI, TWO_PI);  

  line(-width / 2, 0, width / 2, 0);  
  for (int i = 30; i <= 150; i += 30) {  
    line(0, 0, (-width / 2) * cos(radians(i)), (-width / 2) * sin(radians(i)));  
  }  
  popMatrix();  
}  

void drawObject() {  
  pushMatrix();  
  translate(width / 2, height - height * 0.074);  
  strokeWeight(9);  
  stroke(255, 10, 10);  

  pixsDistance = iDistance * ((height - height * 0.1666) * 0.025);  
  if (iDistance < 40) {  
    line(pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle)),  
         (width - width * 0.505) * cos(radians(iAngle)), -(width - width * 0.505) * sin(radians(iAngle)));  
  }  
  popMatrix();  
}  

void drawLine() {  
  pushMatrix();  
  strokeWeight(9);  
  stroke(30, 250, 60);  
  translate(width / 2, height - height * 0.074);  
  line(0, 0, (height - height * 0.12) * cos(radians(iAngle)), -(height - height * 0.12) * sin(radians(iAngle)));  
  popMatrix();  
}  

void drawText() {  
  pushMatrix();  
  noObject = (iDistance > 40) ? "Out of Range" : "In Range";  

  fill(0, 0, 0);  
  noStroke();  
  rect(0, height - height * 0.0648, width, height);  

  fill(98, 245, 31);  
  textSize(25);  
  text("10cm", width - width * 0.3854, height - height * 0.0833);  
  text("20cm", width - width * 0.281, height - height * 0.0833);  
  text("30cm", width - width * 0.177, height - height * 0.0833);  
  text("40cm", width - width * 0.0729, height - height * 0.0833);  

  textSize(40);  
  //text("N_Tech", width - width * 0.875, height - height * 0.0277);  
  text("Angle: " + iAngle, width - width * 0.48, height - height * 0.0277);  
  text("Distance:", width - width * 0.26, height - height * 0.0277);  
  if (iDistance < 40) {  
    text("                 " + iDistance + " cm", width - width * 0.225, height - height * 0.0277);  
  }  

  textSize(25);  
  fill(98, 245, 60);  

  int[] angles = {30, 60, 90, 120, 150};  
  for (int angle : angles) {  
    pushMatrix();  
    translate((width - width * 0.5) + width / 2 * cos(radians(angle)),  
              (height - height * 0.09) - width / 2 * sin(radians(angle)));  
    rotate(radians(-angle + 90));  
    text(angle, 0, 0);  
    popMatrix();  
  }  
  popMatrix();  
}
