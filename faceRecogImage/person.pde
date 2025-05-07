class person {
  String name;
  
  float veyeGap;
  float vlEyeNose;
  float vlEyeMouth;
  float vrEyeNose;
  float vrEyeMouth;
  float vnoseMouth;
  
  float heyeGap;
  float hlEyeNose;
  float hlEyeMouth;
  float hrEyeNose;
  float hrEyeMouth;
  float hnoseMouth;
  
  float lEyexPos;
  float rEyexPos;
  float nosexPos;
  float mouthxPos;
  
  float lEyeyPos;
  float rEyeyPos;
  float noseyPos;
  float mouthyPos;
  
  float lEyeWidth;
  float rEyeWidth;
  float noseWidth;
  float mouthWidth;
  
  float lEyeHeight;
  float rEyeHeight;
  float noseHeight;
  float mouthHeight;
  
  person(profile p, String in) {
    name = in;
    
    // Load in all of the features of the profile
    Rectangle face = p.getFace();
    Rectangle lEye = p.getLeftEye();
    Rectangle rEye = p.getRightEye();
    Rectangle nose = p.getNose();
    Rectangle mouth = p.getMouth();
    float h = float(face.height);
    float w = float(face.width);
    
    // Initialize the relational distances between features---Looks at the distance of the top left corner of each feature as a ratio of the total size of the head
    veyeGap = abs(lEye.y - rEye.y) / h;
    vlEyeNose = abs(lEye.y - nose.y) / h;
    vlEyeMouth = abs(lEye.y - mouth.y) / h;
    vrEyeNose = abs(rEye.y - nose.y) / h;
    vrEyeMouth = abs(rEye.y - mouth.y) / h;
    vnoseMouth = abs(nose.y - mouth.y) / h;
    
    heyeGap = abs(lEye.x - rEye.x) / w;
    hlEyeNose = abs(lEye.x - nose.x) / w;
    hlEyeMouth = abs(lEye.x - mouth.x) / w;
    hrEyeNose = abs(rEye.x - nose.x) / w;
    hrEyeMouth = abs(rEye.x - mouth.x) / w;
    hnoseMouth = abs(nose.x - mouth.x) / w;
    
    rEyeyPos = abs(rEye.y - h) / h;
    lEyeyPos = abs(lEye.y - h) / h;
    noseyPos = abs(nose.y - h) / h;
    mouthyPos = abs(mouth.y - h) / h;
    
    
    lEyexPos = abs(lEye.x - w) / w;
    rEyexPos = abs(rEye.x - w) / w;
    nosexPos = abs(nose.x - w) / w;
    mouthxPos = abs(mouth.x - w) / w;
    
    lEyeWidth = lEye.width / w;
    rEyeWidth = rEye.width / w;
    noseWidth = nose.width / w;
    mouthWidth = mouth.width / w;
    
    lEyeHeight = lEye.height / h;
    rEyeHeight = rEye.height / h;
    noseHeight = nose.height / h;
    mouthHeight = mouth.height / h;
  }
  
  float[] getVerticalDistance() {
    float[] list = {veyeGap, vlEyeNose, vlEyeMouth, vrEyeNose, vrEyeMouth, vnoseMouth};
    return list;
  }
  
  float[] getHorizontalDistance() {
    float[] list = {heyeGap, hlEyeNose, hlEyeMouth, hrEyeNose, hrEyeMouth, hnoseMouth};
    return list;
  }
  
  float[] getXPos() {
    float[] list = {lEyexPos, rEyexPos, nosexPos, mouthxPos};
    return list;
  }
  
  float[] getYPos() {
    float[] list = {lEyeyPos, rEyeyPos, noseyPos, mouthyPos};
    return list;
  }
  
  float[] getFeatureHeight() {
    float[] list = {lEyeHeight, rEyeHeight, noseHeight, mouthHeight};
    return list;
  }
  
  float[] getFeatureWidth() {
    float[] list = {lEyeWidth, rEyeWidth, noseWidth, mouthWidth};
    return list;
  }
  
  String getName() {
    return name;
  }
  
  JSONObject packageJSONObject() {          // Creates a JSONObject out of all of the variables of this object
    JSONObject data = new JSONObject();
    data.setString("name", name);
  
    data.setFloat("veyeGap", veyeGap);
    data.setFloat("vlEyeNose", vlEyeNose);
    data.setFloat("vlEyeMouth", vlEyeMouth);
    data.setFloat("vrEyeNose", vrEyeNose);
    data.setFloat("vrEyeMouth", vrEyeMouth);
    data.setFloat("vnoseMouth", vnoseMouth);
    
    data.setFloat("heyeGap", heyeGap);
    data.setFloat("hlEyeNose", hlEyeNose);
    data.setFloat("hlEyeMouth", hlEyeMouth);
    data.setFloat("hrEyeNose", hrEyeNose);
    data.setFloat("hrEyeMouth", hrEyeMouth);
    data.setFloat("hnoseMouth", hnoseMouth);
    
    data.setFloat("lEyexPos", lEyexPos);
    data.setFloat("rEyexPos", rEyexPos);
    data.setFloat("nosexPos", nosexPos);
    data.setFloat("mouthxPos", mouthxPos);
    
    data.setFloat("lEyeyPos", lEyeyPos);
    data.setFloat("rEyeyPos", rEyeyPos);
    data.setFloat("noseyPos", noseyPos);
    data.setFloat("mouthyPos", mouthyPos);
    
    data.setFloat("lEyeWidth", lEyeWidth);
    data.setFloat("rEyeWidth", rEyeWidth);
    data.setFloat("noseWidth", noseWidth);
    data.setFloat("mouthWidth", mouthWidth);
    
    data.setFloat("lEyeHeight", lEyeHeight);
    data.setFloat("rEyeHeight", rEyeHeight);
    data.setFloat("noseHeight", noseHeight);
    data.setFloat("mouthHeight", mouthHeight);
    
    return data;
  }
  
  person(JSONObject data) {                // Creates a person using a JSONObject (above function)
  
    name = data.getString("name");
  
    veyeGap = data.getFloat("veyeGap");
    vlEyeNose = data.getFloat("vlEyeNose");
    vlEyeMouth = data.getFloat("vlEyeMouth");
    vrEyeNose = data.getFloat("vrEyeNose");
    vrEyeMouth = data.getFloat("vrEyeMouth");
    vnoseMouth = data.getFloat("vnoseMouth");
    
    heyeGap = data.getFloat("heyeGap");
    hlEyeNose = data.getFloat("hlEyeNose");
    hlEyeMouth = data.getFloat("hlEyeMouth");
    hrEyeNose = data.getFloat("hrEyeNose");
    hrEyeMouth = data.getFloat("hrEyeMouth");
    hnoseMouth = data.getFloat("hnoseMouth");
    
    lEyexPos = data.getFloat("lEyexPos");
    rEyexPos = data.getFloat("rEyexPos");
    nosexPos = data.getFloat("nosexPos");
    mouthxPos = data.getFloat("mouthxPos");
    
    lEyeyPos = data.getFloat("lEyeyPos");
    rEyeyPos = data.getFloat("rEyeyPos");
    noseyPos = data.getFloat("noseyPos");
    mouthyPos = data.getFloat("mouthyPos");
    
    lEyeWidth = data.getFloat("lEyeWidth");
    rEyeWidth = data.getFloat("rEyeWidth");
    noseWidth = data.getFloat("noseWidth");
    mouthWidth = data.getFloat("mouthWidth");
    
    lEyeHeight = data.getFloat("lEyeHeight");
    rEyeHeight = data.getFloat("rEyeHeight");
    noseHeight = data.getFloat("noseHeight");
    mouthHeight = data.getFloat("mouthHeight");
  }
}
