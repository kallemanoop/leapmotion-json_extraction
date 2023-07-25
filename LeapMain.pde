import de.voidplus.leapmotion.*;
import processing.data.*;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
JSONObject jsonData;
JSONArray trackedData;



LeapMotion leap;
int timer, i = 0;

void setup() {
  size(800, 500);
  background(255);
  // ...
  
  leap = new LeapMotion(this);
  trackedData = new JSONArray();
}




void leapOnInit() {
  // println("Leap Motion Init");
}
void leapOnConnect() {
  // println("Leap Motion Connect");
}
void leapOnFrame() {
  // println("Leap Motion Frame");
  JSONObject frameData = new JSONObject();

  try {
    ArrayList<Hand> hands = leap.getHands(); // Get all detected hands
    if (!hands.isEmpty()) {
      Hand hand = hands.get(0); // Assuming only one hand is being tracked
      PVector handPosition = hand.getPosition();
      frameData.put("handPosX", handPosition.x);
      frameData.put("handPosY", handPosition.y);
      frameData.put("handPosZ", handPosition.z);
      frameData.put("handRoll", hand.getRoll());
      frameData.put("handPitch", hand.getPitch());
      frameData.put("handYaw", hand.getYaw());
      frameData.put("handIsLeft", hand.isLeft());
      frameData.put("handIsRight", hand.isRight());
      frameData.put("handGrab", hand.getGrabStrength());
      frameData.put("handPinch", hand.getPinchStrength());

      // Store finger data in the frameData object as a JSONArray
      try {
        ArrayList<Finger> fingers = hand.getFingers(); // Get all fingers of the hand
        JSONArray fingersData = new JSONArray();
        for (Finger finger : fingers) {
          JSONObject fingerData = new JSONObject();
          fingerData.put("fingerId", finger.getId());
          PVector fingerPosition = finger.getPosition();
          fingerData.put("fingerPosX", fingerPosition.x);
          fingerData.put("fingerPosY", fingerPosition.y);
          fingerData.put("fingerPosZ", fingerPosition.z);
          fingerData.put("fingerTime", finger.getTimeVisible());
          // Add more finger attributes if needed

          fingersData.append(fingerData);
        }
        frameData.setJSONArray("fingers", fingersData);
      } catch (Exception e) {
        // Handle the ConcurrentModificationException (if needed)
        e.printStackTrace();
      }
    }
  } catch (Exception e) {
    // Handle the ConcurrentModificationException (if needed)
    e.printStackTrace();
  }

  // Append the frameData object to the trackedData array
  trackedData.append(frameData);
  
}
void Save() {
  //if (key == 's' || key == 'S') {
    // Save the trackedData to a file named "leap_motion_tracking_data.json"
    saveJSONArray(trackedData, "leap_motion_tracking_data.json");
    println("Tracking data saved.");
//}

}
void draw() {
  background(255);
  // ...

  int fps = leap.getFrameRate();
  try{
  for (Hand hand : leap.getHands ()) {


    // ==================================================
    // 2. Hand

    int     handId             = hand.getId();
    PVector handPosition       = hand.getPosition();
    PVector handStabilized     = hand.getStabilizedPosition();
    PVector handDirection      = hand.getDirection();
    PVector handDynamics       = hand.getDynamics();
    float   handRoll           = hand.getRoll();
    float   handPitch          = hand.getPitch();
    float   handYaw            = hand.getYaw();
    boolean handIsLeft         = hand.isLeft();
    boolean handIsRight        = hand.isRight();
    float   handGrab           = hand.getGrabStrength();
    float   handPinch          = hand.getPinchStrength();
    float   handTime           = hand.getTimeVisible();
    PVector spherePosition     = hand.getSpherePosition();
    float   sphereRadius       = hand.getSphereRadius();

    // --------------------------------------------------
    // Drawing
    hand.draw();


    // ==================================================
    // 3. Arm

    if (hand.hasArm()) {
      Arm     arm              = hand.getArm();
      float   armWidth         = arm.getWidth();
      PVector armWristPos      = arm.getWristPosition();
      PVector armElbowPos      = arm.getElbowPosition();
    }


    // ==================================================
    // 4. Finger

    Finger  fingerThumb        = hand.getThumb();
    // or                        hand.getFinger("thumb");
    // or                        hand.getFinger(0);

    Finger  fingerIndex        = hand.getIndexFinger();
    // or                        hand.getFinger("index");
    // or                        hand.getFinger(1);

    Finger  fingerMiddle       = hand.getMiddleFinger();
    // or                        hand.getFinger("middle");
    // or                        hand.getFinger(2);

    Finger  fingerRing         = hand.getRingFinger();
    // or                        hand.getFinger("ring");
    // or                        hand.getFinger(3);

    Finger  fingerPink         = hand.getPinkyFinger();
    // or                        hand.getFinger("pinky");
    // or                        hand.getFinger(4);


    for (Finger finger : hand.getFingers()) {
      // or              hand.getOutstretchedFingers();
      // or              hand.getOutstretchedFingersByAngle();

      int     fingerId         = finger.getId();
      PVector fingerPosition   = finger.getPosition();
      PVector fingerStabilized = finger.getStabilizedPosition();
      PVector fingerVelocity   = finger.getVelocity();
      PVector fingerDirection  = finger.getDirection();
      float   fingerTime       = finger.getTimeVisible();

      // ------------------------------------------------
      // Drawing

      // Drawing:
      // finger.draw();  // Executes drawBones() and drawJoints()
      // finger.drawBones();
      // finger.drawJoints();

      // ------------------------------------------------
      // Selection

      switch(finger.getType()) {
      case 0:
        // System.out.println("thumb");
        break;
      case 1:
        // System.out.println("index");
        break;
      case 2:
        // System.out.println("middle");
        break;
      case 3:
        // System.out.println("ring");
        break;
      case 4:
        // System.out.println("pinky");
        break;
      }


      // ================================================
      // 5. Bones
      // --------
      // https://developer.leapmotion.com/documentation/java/devguide/Leap_Overview.html#Layer_1

      Bone    boneDistal       = finger.getDistalBone();
      // or                      finger.get("distal");
      // or                      finger.getBone(0);

      Bone    boneIntermediate = finger.getIntermediateBone();
      // or                      finger.get("intermediate");
      // or                      finger.getBone(1);

      Bone    boneProximal     = finger.getProximalBone();
      // or                      finger.get("proximal");
      // or                      finger.getBone(2);

      Bone    boneMetacarpal   = finger.getMetacarpalBone();
      // or                      finger.get("metacarpal");
      // or                      finger.getBone(3);

      // ------------------------------------------------
      // Touch emulation

      int     touchZone        = finger.getTouchZone();
      float   touchDistance    = finger.getTouchDistance();

      switch(touchZone) {
      case -1: // None
        break;
      case 0: // Hovering
        // println("Hovering (#" + fingerId + "): " + touchDistance);
        break;
      case 1: // Touching
        // println("Touching (#" + fingerId + ")");
        break;
      }
    }


    // ==================================================
    // 6. Tools

    for (Tool tool : hand.getTools()) {
      int     toolId           = tool.getId();
      PVector toolPosition     = tool.getPosition();
      PVector toolStabilized   = tool.getStabilizedPosition();
      PVector toolVelocity     = tool.getVelocity();
      PVector toolDirection    = tool.getDirection();
      float   toolTime         = tool.getTimeVisible();

      // ------------------------------------------------
      // Drawing:
      // tool.draw();

      // ------------------------------------------------
      // Touch emulation

      int     touchZone        = tool.getTouchZone();
      float   touchDistance    = tool.getTouchDistance();

      switch(touchZone) {
      case -1: // None
        break;
      case 0: // Hovering
        // println("Hovering (#" + toolId + "): " + touchDistance);
        break;
      case 1: // Touching
        // println("Touching (#" + toolId + ")");
        break;
      }
    }
  }}
  catch(Exception e){
    print("pass");
  }


  // ====================================================
  // 7. Devices

  for (Device device : leap.getDevices()) {
    float deviceHorizontalViewAngle = device.getHorizontalViewAngle();
    float deviceVericalViewAngle = device.getVerticalViewAngle();
    float deviceRange = device.getRange();
  }
  leapOnFrame();
  
  if (millis() > timer + 2){
    Save();
    timer = millis();
    i += 1;
    print(i);
  }
}
