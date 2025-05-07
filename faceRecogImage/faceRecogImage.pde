import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import java.util.Arrays;

String[] fname = {"face1.jpg",          // Black man;       1380 x 920
                  "face2.jpg",          // White woman;     1000 x 714
                  "face3.jpg",          // Mustache man;    1000 x 714
                  "face4.jpg",          // Celeberties;     1920 x 1094
                  "face5.jpg",          // Chalamet 1;      193 x 261
                  "face6.jpg",          // Chalamet 2;      1000 x 755
                  "face7.jpg",          // Matt Frewer;     1000 x 1000
                  "face8.jpg",          // Max Headroom;    480 x 360
                  "face9.jpg",          // Eminem Headroom; 600 x 600
                  "face10.jpg",         // Eminem;          1080 x 600  
                 };
PImage img;
Rectangle[] faces, eyes, noses, mouths;
OpenCV opencvFace, opencvEye, opencvNose, opencvMouth;
ArrayList<profile> profileList = new ArrayList<>();
ArrayList<person> personList = new ArrayList<>();
ArrayList<person> storedProfileList = new ArrayList<>();
JSONArray persons;
String jname = "persons.json";
int countThreshold = 19;
float delta = 0.25;

void setup() {
  size(1920, 1094);
  img = loadImage(fname[5]);
  windowResize(img.width, img.height);
  
  PFont font = createFont("Arial", 24);
  textFont(font);
  
  // Load the OpenCV objects and detect all facial features in the image
  opencvFace = new OpenCV(this, width, height);
  opencvFace.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  faces = faceRecognition(opencvFace, img);
  
  opencvEye = new OpenCV(this, width, height);
  opencvEye.loadCascade(OpenCV.CASCADE_EYE);
  eyes = featureRecognition(opencvEye, img);
  
  opencvNose = new OpenCV(this, width, height);
  opencvNose.loadCascade(OpenCV.CASCADE_NOSE);
  noses = featureRecognition(opencvNose, img);
  
  opencvMouth = new OpenCV(this, width, height);
  opencvMouth.loadCascade(OpenCV.CASCADE_MOUTH);
  mouths = featureRecognition(opencvMouth, img);
  
  println("faces: ", faces.length);
  println("eyes: ", eyes.length);
  println("noses: ", noses.length);
  println("mouths: ", mouths.length);
  
  persons = loadJSONArray(jname);
  for (int i = 0; i < persons.size(); i++) {
    JSONObject dataPoint = persons.getJSONObject(i);
    person x = new person(dataPoint);
    personList.add(i, x);
  }
  
  for (int i = 0; i < faces.length; i++) {      // Classifies all of the features detected into profiles for each individual on screen
    profileList.add(createProfile(faces[i], eyes, noses, mouths));
  }
  
  for (int i = 0; i < profileList.size(); i++) {
    println("\nProfile ", i);
    profile prof = profileList.get(i);
    println("Head: " + prof.getFace());
    println("Left Eye: " + prof.getLeftEye());
    println("Right Eye: " + prof.getRightEye());
    println("Nose: " + prof.getNose());
    println("Mouth: " + prof.getMouth() + "\n");
    
    // Compare the face data to the face data stored in the JSON
    person x = new person(prof, "Current");
    int[] counts = new int[personList.size()];
    String[] nameList = new String[personList.size()];
    for (int ii = 0; ii < personList.size(); ii++) {
      person p = personList.get(ii);
      int count = comparePersons(x, p);
      println(p.getName(), ": ", count, "/ 28 features match\n");
      counts[ii] = count;
      nameList[ii] = p.getName() + ": " + count + "/ 28";
    }
    int max = -1;
    for (int ii = 0; ii < counts.length; ii++) {
      if (counts[ii] >= countThreshold) {
        if (max == -1) max = ii;
        else if (counts[ii] > counts[max]) max = ii;
      }
    }
    if (max != -1) prof.setName(nameList[max]);
  }
}

void draw() {
  image(img, 0, 0);
  
  for (int i = 0; i < profileList.size(); i++) {      // Iterates through all profiles and displays all of their features
    profile prof = profileList.get(i);
    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    Rectangle head = prof.getFace();
    rect(head.x, head.y, head.width, head.height);
    String name = prof.getName();
    float nameX = head.x + head.width - textWidth(name);
    float nameY = head.y + head.height - (textAscent() + textDescent());
    fill(0, 255, 0);
    rect(nameX, nameY, textWidth(name), textAscent() + textDescent());
    fill(0);
    text(name, nameX, nameY + (textAscent() + textDescent()));
    noFill();
    
    stroke(0, 255, 255);
    strokeWeight(2);
    Rectangle lEye = prof.getLeftEye();
    Rectangle rEye = prof.getRightEye();
    rect(lEye.x, lEye.y, lEye.width, lEye.height);
    rect(rEye.x, rEye.y, rEye.width, rEye.height);
    
    stroke(255, 0, 255);
    Rectangle nose = prof.getNose();
    rect(nose.x, nose.y, nose.width, nose.height);
    
    stroke(255, 255, 0);
    Rectangle mouth = prof.getMouth();
    rect(mouth.x, mouth.y, mouth.width, mouth.height);
  }
}


Rectangle[] faceRecognition(OpenCV cascade, PImage img) {        // Detects the faces within the image
  cascade.loadImage(img);
  Rectangle[] objects = cascade.detect();
  return objects;
}


Rectangle[] featureRecognition(OpenCV cascade, PImage img) {    // Detects the chosen features using a slightly modified version of OpenCV's detectMultiScale method
  cascade.loadImage(img);
  Rectangle[] objects = cascade.detect(1.1, 5, 0, int(img.width/20), int(img.width/3));
  // Rectangle[] objects = cascade.detect();
  return objects;
}


profile createProfile(Rectangle f, Rectangle[] e, Rectangle[] n, Rectangle[] m) {      // Creates a profile object for every face detected in the image; default value for features is the face box
  f.setSize(f.width, int(f.height * 1.1));    // Face detection typically cuts off the chin; this corrects that
  
  int x = 0;
  Rectangle[] interiorEyes = new Rectangle[2];
  interiorEyes[0] = f; interiorEyes[1] = f;
  for (int i = 0; i < e.length; i++) {         // Adds all eyes located within the top 1/3rd of the face box to InteriorEyes
    if (f.contains(e[i]) & e[i].y < f.y + f.height*0.33){
      interiorEyes[x] = e[i];
      x = 1;
    }
  }
  
  Rectangle interiorNose = f;
  for (int i = 0; i < n.length; i++) {         // Adds a nose located within the middle 1/3rd of the face box to InteriorEyes
    if (f.contains(n[i]) & n[i].y > f.y + f.height*0.33 & n[i].y < f.y + f.height * 0.5) interiorNose = n[i];
  }
  
  Rectangle interiorMouth = f;
  for (int i = 0; i < m.length; i++) {         // Adds a mouth located within the bottom 1/3rd of the face box to InteriorEyes
    if (f.contains(m[i]) & m[i].y > f.y +f.height*0.6) interiorMouth = m[i];
  }
  
  profile y;
  if (interiorEyes[0].x < interiorEyes[1].x) {     // 0 is left eye
    y = new profile(f, interiorEyes[0], interiorEyes[1], interiorNose, interiorMouth);
  } else  {                                        // 0 is right eye
    y = new profile(f, interiorEyes[1], interiorEyes[0], interiorNose, interiorMouth);
  }
  return y;
}


int comparePersons(person p1, person p2) {
  int count = 0;
  
  float[] v1 = p1.getVerticalDistance(); 
  float[] v2 = p2.getVerticalDistance();
  println("Vertical Distance: ");
  for (int i = 0; i < v1.length; i++) {
    print(v1[i], "-", v2[i]);
    if (v1[i] != 0   &   v1[i] <= v2[i] * (1 + delta)   &   v1[i] >= v2[i] * (1 - delta)) {
      print("!");
      count += 1;
    }
  println();
  }
  
  float[] h1 = p1.getHorizontalDistance(); 
  float[] h2 = p2.getHorizontalDistance();
  println("Horizontal Distance: ");
  for (int i = 0; i < h1.length; i++) {
    print(h1[i], "-", h2[i]);
    if (h1[i] != 0   &   h1[i] <= h2[i] * (1 + delta)   &   h1[i] >= h2[i] * (1 - delta)) {
      print("!");
      count += 1;
    }
  println();
  }
  
  float[] x1 = p1.getXPos(); 
  float[] x2 = p2.getXPos();
  println("X Position: ");
  for (int i = 0; i < x1.length; i++) {
    print(x1[i], "-", x2[i]);
    if (x1[i] != 0   &   x1[i] <= x2[i] * (1 + delta)   &   x1[i] >= x2[i] * (1 - delta)) {
      print("!");
      count += 1;
    }
  println();
  }
  
  float[] y1 = p1.getYPos(); 
  float[] y2 = p2.getYPos();
  println("Y Position: ");
  for (int i = 0; i < y1.length; i++) {
    print(y1[i], "-", y2[i]);
    if (y1[i] != 0   &   y1[i] <= y2[i] * (1 + delta)   &   y1[i] >= y2[i] * (1 - delta)) {
      print("!");
      count += 1;
    }
  println();
  }
  
  float[] t1 = p1.getFeatureHeight(); 
  float[] t2 = p2.getFeatureHeight();
  println("Feature Height: ");
  for (int i = 0; i < t1.length; i++) {
    print(t1[i], "-", t2[i]);
    if (t1[i] != 0   &   t1[i] <= t2[i] * (1 + delta)   &   t1[i] >= t2[i] * (1 - delta)) {
      print("!");
      count += 1;
    }
  println();
  }
  
  float[] w1 = p1.getFeatureWidth(); 
  float[] w2 = p2.getFeatureWidth();
  println("Feature Width: ");
  for (int i = 0; i < w1.length; i++) {
    print(w1[i], "-", w2[i]);
    if (w1[i] != 0   &   w1[i] <= w2[i] * (1 + delta)   &   w1[i] >= w2[i] * (1 - delta)) {
      print("!");
      count += 1;
    }
  println();
  }
  return count;
}


void keyPressed() {
  
}
