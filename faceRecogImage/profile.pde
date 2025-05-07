class profile {
  Rectangle face;
  Rectangle lEye;
  Rectangle rEye;
  Rectangle nose;
  Rectangle mouth;
  String name;
  
  profile(Rectangle f, Rectangle le, Rectangle re, Rectangle n, Rectangle m) {
    face = f;
    nose = n;
    lEye = le;
    rEye = re;
    mouth = m;
    name = "Unknown";
  }
  
  Rectangle getFace() {
    return face;
  }
  
  Rectangle getLeftEye() {
    return lEye;
  }
  
  Rectangle getRightEye() {
    return rEye;
  }
  
  Rectangle getNose() {
    return nose;
  }
  
  Rectangle getMouth() {
    return mouth;
  }
  
  void setName(String n) {
    name = n;
  }
  
  String getName() {
    return name;
  }
}
