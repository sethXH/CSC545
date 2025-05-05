import gab.opencv.*;
import processing.video.*;
import java.awt.*;

String[] fname = {"face1.jpg",          // Black man;    1380 x 920
                  "face2.jpg",          // White woman;  1000 x 714
                  "face3.jpg",          // Mustache man; 1000 x 714
                  "face4.jpg"           // Celeberties;  1920 x 1094
                 };
PImage img1, img2;
Rectangle[] faces1, eyes1, noses1, mouths1, faces2, eyes2, noses2, mouths2;
OpenCV opencvFace, opencvEye, opencvNose, opencvMouth;
ArrayList<profile> profileList1 = new ArrayList<>();
ArrayList<profile> profileList2 = new ArrayList<>();
boolean displayUnplaced;
float dist;

void setup() {
  size(1920, 1094);
  img1 = loadImage(fname[0]);
  img2 = loadImage(fname[2]);
  windowResize(img1.width + img2.width, img1.height + img2.height);
  
  // Load the OpenCV objects and detect all facial features in the image
  opencvFace = new OpenCV(this, img1);
  opencvFace.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  faces1 = faceRecognition(opencvFace, img1);
  
  opencvEye = new OpenCV(this, img1);
  opencvEye.loadCascade(OpenCV.CASCADE_EYE);
  eyes1 = featureRecognition(opencvEye, img1);
  
  opencvNose = new OpenCV(this, img1);
  opencvNose.loadCascade(OpenCV.CASCADE_NOSE);
  noses1 = featureRecognition(opencvNose, img1);
  
  opencvMouth = new OpenCV(this, img1);
  opencvMouth.loadCascade(OpenCV.CASCADE_MOUTH);
  mouths1 = featureRecognition(opencvMouth, img1);
  
  opencvFace = new OpenCV(this, img2);
  opencvFace.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  faces2 = faceRecognition(opencvFace, img2);
  
  opencvEye = new OpenCV(this, img2);
  opencvEye.loadCascade(OpenCV.CASCADE_EYE);
  eyes2 = featureRecognition(opencvEye, img2);
  
  opencvNose = new OpenCV(this, img2);
  opencvNose.loadCascade(OpenCV.CASCADE_NOSE);
  noses2 = featureRecognition(opencvNose, img2);
  
  opencvMouth = new OpenCV(this, img2);
  opencvMouth.loadCascade(OpenCV.CASCADE_MOUTH);
  mouths2 = featureRecognition(opencvMouth, img2);
  
  for (int i = 0; i < faces1.length; i++) {
    profileList1.add(createProfile(faces1[i], eyes1, noses1, mouths1));
  }
  
  for (int i = 0; i < faces2.length; i++) {
    profileList2.add(createProfile(faces2[i], eyes2, noses2, mouths2));
  }

  
  if (profileList1.size() > 0) {
    profile prof = profileList1.get(0);
    println("Face 1 Profile:");
    println("Head: " + prof.getFace());
    println("Left Eye: " + prof.getLeftEye());
    println("Right Eye: " + prof.getRightEye());
    println("Nose: " + prof.getNose());
    println("Mouth: " + prof.getMouth());
  } else {
    println("No face detected");
  }
  
  if (profileList2.size() > 0) {
    profile prof = profileList2.get(0);
    println("Face 2 Profile:");
    println("Head: " + prof.getFace());
    println("Left Eye: " + prof.getLeftEye());
    println("Right Eye: " + prof.getRightEye());
    println("Nose: " + prof.getNose());
    println("Mouth: " + prof.getMouth());
  } else {
    println("No face detected");
  }
  
  compareImages();
}


void compareImages() {
  if (profileList1.size() > 0 && profileList2.size() > 0) {
    profile p1 = profileList1.get(0);
    profile p2 = profileList2.get(0);
    
    dist = compareProfiles(p1, p2, img1, img2);
    println("Euclidean distance between faces: " + dist);
  } else {
    println("One or both profile lists are empty.");
  }
}



void draw() {
  image(img1, 0, 0);
  for (int i = 0; i < profileList1.size(); i++) {
    drawProfile(profileList1.get(i));
  }
  
  image(img2, img1.width, 0);
  for (int i = 0; i < profileList2.size(); i++) {
    drawProfileOffset(profileList2.get(i), img1.width);  // Shift right by img1's width
  }
  
  fill(255, 0, 0);
  textSize(20);
  text("Euclidean distance between faces: " + dist, width/2, height/4);
  if (dist <= 250) {
    text("Almost certainly same person", width/2, height/4 + 25);
  } else if (dist <= 400) {
    text("Possibly the same person", width/2, height/4 + 25);
  } else {
    text("Different people", width/2, height/4 + 25);
  }
}

void drawProfile(profile prof) {
  drawFeatures(prof, 0);
}

void drawProfileOffset(profile prof, int xOffset) {
  drawFeatures(prof, xOffset);
}

void drawFeatures(profile prof, int offsetX) {
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle head = prof.getFace();
  rect(head.x + offsetX, head.y, head.width, head.height);
  
  stroke(0, 255, 255);
  strokeWeight(2);
  rect(prof.getLeftEye().x + offsetX, prof.getLeftEye().y, prof.getLeftEye().width, prof.getLeftEye().height);
  rect(prof.getRightEye().x + offsetX, prof.getRightEye().y, prof.getRightEye().width, prof.getRightEye().height);
  
  stroke(255, 0, 255);
  Rectangle nose = prof.getNose();
  rect(nose.x + offsetX, nose.y, nose.width, nose.height);
  
  stroke(255, 255, 0);
  Rectangle mouth = prof.getMouth();
  rect(mouth.x + offsetX, mouth.y, mouth.width, mouth.height);
  
    if (displayUnplaced) {      // Displays all of the features that were filtered out of the profiles
    for (int i = 0; i < eyes1.length; i++) {
      stroke(0, 255, 255, 150);
      strokeWeight(2);
      rect(eyes1[i].x, eyes1[i].y, eyes1[i].width, eyes1[i].height);
    }
    
    for (int i = 0; i < noses1.length; i++) {
      stroke(255, 0, 255, 150);
      strokeWeight(2);
      rect(noses1[i].x, noses1[i].y, noses1[i].width, noses1[i].height);
    }
    
    for (int i = 0; i < mouths1.length; i++) {
      stroke(255, 255, 0, 150);
      strokeWeight(2);
      rect(mouths1[i].x, mouths1[i].y, mouths1[i].width, mouths1[i].height);
    }
    
    for (int i = 0; i < eyes2.length; i++) {
      stroke(0, 255, 255, 150);
      strokeWeight(2);
      rect(eyes2[i].x, eyes2[i].y, eyes2[i].width, eyes2[i].height);
    }
    
    for (int i = 0; i < noses2.length; i++) {
      stroke(255, 0, 255, 150);
      strokeWeight(2);
      rect(noses2[i].x, noses2[i].y, noses2[i].width, noses2[i].height);
    }
    
    for (int i = 0; i < mouths2.length; i++) {
      stroke(255, 255, 0, 150);
      strokeWeight(2);
      rect(mouths2[i].x, mouths2[i].y, mouths2[i].width, mouths2[i].height);
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

color averageColor(PImage img, Rectangle r) { // Compute the average color for all features in profile
  img.loadPixels();
  int count = 0;
  float sumR = 0, sumG = 0, sumB = 0;
  
  for (int i = r.x; i < r.x + r.width; i++) {
    for (int j = r.y; j < r.y + r.height; j++) {
      if (i >= 0 && j >= 0 && i < img.width && j < img.height) {
        color c = img.get(i, j);
        sumR += red(c);
        sumG += green(c);
        sumB += blue(c);
        count++;
      }
    }
  }
  if (count == 0) return color(0);  // Avoid divide by zero
  return color(sumR / count, sumG / count, sumB / count);
}


float cdist(color c1, color c2) { // calculate Euclidean distance between c1 and c2
  float d = 0;  //Distance
  float r1 = red(c1), g1 = green(c1), b1 = blue(c1);
  float r2 = red(c2), g2 = green(c2), b2 = blue(c2);
  d = sqrt(sq(r2 - r1) + sq(g2 - g1) + sq(b2 - b1));
  return d;
}

float compareProfiles(profile p1, profile p2, PImage img1, PImage img2) { // Compare two profiles
  float d = 0;
  d += cdist(averageColor(img1, p1.getLeftEye()), averageColor(img2, p2.getLeftEye()));
  d += cdist(averageColor(img1, p1.getRightEye()), averageColor(img2, p2.getRightEye()));
  d += cdist(averageColor(img1, p1.getNose()), averageColor(img2, p2.getNose()));
  d += cdist(averageColor(img1, p1.getMouth()), averageColor(img2, p2.getMouth()));
  d += cdist(averageColor(img1, p1.getFace()), averageColor(img2, p2.getFace()));
  return d;
}

void keyPressed() {
  if (key == 't') displayUnplaced = !displayUnplaced;    // Displays the features that were filtered out
}
