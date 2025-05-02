import gab.opencv.*;
import processing.video.*;
import java.awt.*;

String[] fname = {"face1.jpg",          // Black man;    1380 x 920
                  "face2.jpg",          // White woman;  1000 x 714
                  "face3.jpg",          // Mustache man; 1000 x 714
                  "face4.jpg"           // Celeberties;  1920 x 1094
                 };
PImage img;
Rectangle[] faces, eyes, noses, mouths;
OpenCV opencvFace, opencvEye, opencvNose, opencvMouth;
ArrayList<profile> profileList = new ArrayList<>();
boolean displayUnplaced;

void setup() {
  size(1920, 1094);
  img = loadImage(fname[3]);
  
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
  
  for (int i = 0; i < faces.length; i++) {      // Classifies all of the features detected into profiles for each individual on screen
    profileList.add(createProfile(faces[i], eyes, noses, mouths));
  }
  
  profile prof = profileList.get(0);
  println("Head: " + prof.getFace());
  println("Left Eye: " + prof.getLeftEye());
  println("Right Eye: " + prof.getRightEye());
  println("Nose: " + prof.getNose());
  println("Mouth: " + prof.getMouth());
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

  if (displayUnplaced) {      // Displays all of the features that were filtered out of the profiles
    for (int i = 0; i < eyes.length; i++) {
      stroke(0, 255, 255, 150);
      strokeWeight(2);
      rect(eyes[i].x, eyes[i].y, eyes[i].width, eyes[i].height);
    }
    
    for (int i = 0; i < noses.length; i++) {
      stroke(255, 0, 255, 150);
      strokeWeight(2);
      rect(noses[i].x, noses[i].y, noses[i].width, noses[i].height);
    }
    
    for (int i = 0; i < mouths.length; i++) {
      stroke(255, 255, 0, 150);
      strokeWeight(2);
      rect(mouths[i].x, mouths[i].y, mouths[i].width, mouths[i].height);
    }
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
  for (int i = 0; i < n.length; i++) {         // Adds a nose located within the bottom 2/3rds of the face box to InteriorEyes
    if (f.contains(n[i]) & n[i].y > f.y + f.height*0.33) interiorNose = n[i];
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


void keyPressed() {
  if (key == 't') displayUnplaced = !displayUnplaced;    // Displays the features that were filtered out
}
