import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;
import processing.core.PImage;
import java.util.*;
import guru.ttslib.*;
import java.util.Timer;
import java.util.TimerTask;


String eventDataJSON1 = "ExampleData_1.json";
String eventDataJSON2 = "ExampleData_2.json";
String eventDataJSON3 = "ExampleData_3.json";
Queue<Notification> queue = new LinkedList<Notification>();
Queue<Notification> priority = new LinkedList<Notification>();
Queue<Notification> memory = new LinkedList<Notification>();
NotificationServer server;
ArrayList<Notification> notifications;
TextToSpeechMaker ttsMaker; 
Example example;
PImage bg;
boolean Call=true, Email=true, Voice=true, Text=true, Twitter=true, JoggingOn=false, PartyOn = false, LectureOn=false, TransitOn=false, memoryinfo = true, soundend = true;
boolean ttsend = true, Memories = false, ccc = true, end = true, die = true, low = true, normal = true, good = true, nbad = true, nlow = true, ngood = true;
ControlP5 p5;
SamplePlayer sp, party, lecture, jogging, transit, twitter, icon, event, activity, message, call, call2;
SamplePlayer email, voicemail, vibration, lecturing, battery_good, battery_normal, battery_low, battery_die;
SamplePlayer network_good, network_bad, network_low;
WavePlayer wp;
Gain g,b,n,first,masterGain;
Glide volumeGlide, battery, network, pitchEmail, pitchMessage, pitchVoice, pitchCall, pitchTwitter;
Toggle tpo, tjo, tlo, tto, tc, te, tv, tt, tw, mmr;
Slider nnn, bbb;
float lastcheck;
float timeinterval;
int counting = 0, count = 0, callc = 0, emailc = 0, voicec = 0, textc = 0, twitterc = 0, importantc = 0;

//runs once when the Play button above is pressed
void setup() {
  size(600, 600);
  smooth();
  bg = loadImage("bg.jpg");
  //START NotificationServer setup
  server = new NotificationServer();
  example = new Example();
  server.addListener(example);
  ac = new AudioContext();
  p5 = new ControlP5(this);

  first = new Gain(ac, 1, 1);
  network = new Glide(ac, 3, 1000); 
  n = new Gain(ac, 1, network);
  
  pitchEmail = new Glide(ac, 1.0);
  pitchMessage = new Glide(ac, 1.0);  
  pitchVoice = new Glide(ac, 1.0);
  pitchCall = new Glide(ac, 1.0);
  pitchTwitter = new Glide(ac, 1.0);
    
  masterGain = new Gain(ac, 1, 1);
  volumeGlide = new Glide(ac, 1.0, 100);
  g = new Gain(ac, 1, volumeGlide);
  battery = new Glide(ac, 5);
  
  
// create sampleplayer and pause playback
  party = getSamplePlayer("party.wav");
  jogging = getSamplePlayer("jogging.wav");
  lecture = getSamplePlayer("lecture.wav");
  lecturing = getSamplePlayer("lecturing.wav");
  transit = getSamplePlayer("transit.wav");
  twitter = getSamplePlayer("twitter.wav");
  message = getSamplePlayer("message.wav");
  voicemail = getSamplePlayer("voicemail.wav");
  call = getSamplePlayer("call.wav");
  call2 = getSamplePlayer("call2.wav");
  email = getSamplePlayer("email.wav");
  activity = getSamplePlayer("activity.wav");
  event = getSamplePlayer("event.wav");
  icon = getSamplePlayer("icon.wav");
  vibration = getSamplePlayer("vibration.wav");
  battery_good =getSamplePlayer("battery_good.wav");
  battery_normal =getSamplePlayer("battery_normal.wav");
  battery_low =getSamplePlayer("battery_bad.wav");
  battery_die = getSamplePlayer("battery_die.wav");
  network_good = getSamplePlayer("network_good.wav");
  network_low = getSamplePlayer("network_low.wav");
  network_bad = getSamplePlayer("network_bad.wav");
  
  
  email.setPitch(pitchEmail);
  message.setPitch(pitchMessage);
  voicemail.setPitch(pitchVoice);
  twitter.setPitch(pitchTwitter);
  call.setPitch(pitchCall);
  
  first.addInput(network_good);
  first.addInput(network_low);
  first.addInput(network_bad);
  first.addInput(battery_good);
  first.addInput(battery_normal);
  first.addInput(battery_low);
  first.addInput(battery_die);
  first.addInput(message);
  first.addInput(twitter);
  first.addInput(email);
  first.addInput(call);
  first.addInput(call2);
  first.addInput(voicemail);
  first.addInput(vibration);
  masterGain.addInput(activity);
  masterGain.addInput(icon);
  masterGain.addInput(event);
  masterGain.addInput(party);
  masterGain.addInput(jogging);
  masterGain.addInput(lecture);
  masterGain.addInput(lecturing);
  masterGain.addInput(transit);
  ac.out.addInput(first);
  g.addInput(masterGain);
  ttsMaker = new TextToSpeechMaker();
  
  tc = p5.addToggle("Call").setPosition(40,100)
    .setImages(loadImage("phg.png"), loadImage("ph.png"))
    .updateSize().setValue(true);
  te = p5.addToggle("Email").setPosition(110, 100)
    .setImages(loadImage("mag.png"), loadImage("ma.png"))
    .updateSize().setValue(true);
  tt = p5.addToggle("Text").setPosition(180, 100)
    .setImages(loadImage("msg.png"), loadImage("ms.png"))
    .updateSize().setValue(true);
  tv = p5.addToggle("Voice").setPosition(250, 100)
    .setImages(loadImage("vmg.png"), loadImage("vm.png"))
    .updateSize().setValue(true);
  tw = p5.addToggle("Twitter").setPosition(320, 100)
    .setImages(loadImage("twg.png"), loadImage("tw.png"))
    .updateSize().setValue(true);
    
  tto = p5.addToggle("transitOn").setPosition(40,200)
    .setImages(loadImage("gtransit.png"), loadImage("transit.png"))
    .updateSize().setValue(false);
    
  tpo = p5.addToggle("partyOn").setPosition(170, 200)
    .setImages(loadImage("gparty.png"), loadImage("party.png"))
    .updateSize().setValue(false);

  tjo = p5.addToggle("joggingOn").setPosition(40,390)
    .setImages(loadImage("gjogging.png"), loadImage("jogging.png"))
    .setValue(false).updateSize();
    
  tlo = p5.addToggle("lectureOn").setPosition(170,390)
    .setImages(loadImage("glecture.png"), loadImage("lecture.png"))
    .setValue(false).updateSize();
 
  p5.addSlider("volume")
    .setPosition(300, 200).setSize(60, 300)
    .setRange(0, 50).setValue(25)
    .setColorForeground(#e6005c)
    .setColorBackground(#ff66a3)
    .setColorActive(#ffcce0);
   
 nnn = p5.addSlider("network", 1, 3, 100, 410, 100, 130, 30)
    .setColorForeground(#e6005c)
    .setColorBackground(#ff66a3)
    .setColorActive(#ffcce0)
    .setNumberOfTickMarks(3);
 bbb = p5.addSlider("battery", 1, 4, 100, 410, 160, 130, 30)
    .setColorForeground(#e6005c)
    .setColorBackground(#ff66a3)
    .setColorActive(#ffcce0)
    .setNumberOfTickMarks(4)
    .setLabel("Battery");  
  p5.addButton("EVENT1")
    .setPosition(430, 250).setSize(80, 30)
    .setColorForeground(#e6005c)
    .setColorBackground(#ff66a3)
    .setColorActive(#ffcce0)
    .activateBy((ControlP5.RELEASE));
    
  p5.addButton("EVENT2")
    .setPosition(430, 320).setSize(80, 30)
    .setColorForeground(#e6005c)
    .setColorBackground(#ff66a3)
    .setColorActive(#ffcce0)    
    .activateBy((ControlP5.RELEASE));
    
  p5.addButton("EVENT3")
    .setPosition(430, 390).setSize(80, 30)
    .setColorForeground(#e6005c)
    .setColorBackground(#ff66a3)
    .setColorActive(#ffcce0)    
    .activateBy((ControlP5.RELEASE));
    
 mmr = p5.addToggle("Memory")
    .setColorForeground(#e6005c)
    .setColorBackground(#ff66a3)
    .setColorActive(#ffcce0)  
    .setPosition(430, 450).setSize(80, 30);
    
  network_good.setLoopType(SamplePlayer.LoopType.NO_LOOP_FORWARDS); 
  network_low.setLoopType(SamplePlayer.LoopType.NO_LOOP_FORWARDS); 
  network_bad.setLoopType(SamplePlayer.LoopType.NO_LOOP_FORWARDS); 
  battery_good.setLoopType(SamplePlayer.LoopType.NO_LOOP_FORWARDS);     
  battery_normal.setLoopType(SamplePlayer.LoopType.NO_LOOP_FORWARDS);     
  battery_die.setLoopType(SamplePlayer.LoopType.NO_LOOP_FORWARDS); 
  battery_low.setLoopType(SamplePlayer.LoopType.NO_LOOP_FORWARDS);     
  battery_die.setLoopType(SamplePlayer.LoopType.NO_LOOP_FORWARDS); 
  vibration.setLoopType(SamplePlayer.LoopType.NO_LOOP_FORWARDS); 
  twitter.setLoopType(SamplePlayer.LoopType.NO_LOOP_FORWARDS);  
  message.setLoopType(SamplePlayer.LoopType.NO_LOOP_FORWARDS);
  activity.setLoopType(SamplePlayer.LoopType.NO_LOOP_FORWARDS);
  event.setLoopType(SamplePlayer.LoopType.NO_LOOP_FORWARDS);
  icon.setLoopType(SamplePlayer.LoopType.NO_LOOP_FORWARDS);
  party.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  jogging.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  lecture.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  lecturing.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  transit.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  //network_good.pause(true);
  network_low.pause(true);
  network_bad.pause(true);
  //battery_good.pause(true);
  battery_normal.pause(true);
  battery_low.pause(true);
  battery_die.pause(true);
  vibration.pause(true);
  twitter.pause(true);
  message.pause(true);
  call.pause(true);
  call2.pause(true);
  email.pause(true);
  voicemail.pause(true);
  lecture.pause(true);
  lecturing.pause(true);
  transit.pause(true);
  activity.pause(true);
  icon.pause(true);
  event.pause(true);
  party.pause(true);
  jogging.pause(true);
  ac.out.addInput(g);
  server.stopEventStream();
  ac.start();
  
  lastcheck = millis();
  timeinterval = 4500;
}

public void Call(boolean Call) {
  icon();
  if (Call) { println("call on");} 
  else {println("call off");}
}

public void Text(boolean Text) {
  icon();
  if (Text) { println("text on");} 
  else { println("text off");}
}

public void Voice(boolean Voice) {
  icon();
  if (Voice) {println("voice mail on");} 
  else {println("voice mail off");} 
}

public void Twitter(boolean Twitter) {
  icon();
  if (Twitter) {println("twitter on");} 
  else {println("twitter off");} 
}

public void Email(boolean Email) {
  icon();
  if (Email) {println("email on");} 
  else {println("2");} 
}  


public void partyOn(boolean PartyOn) {
  println(JoggingOn + "partyOn is On Now~~~~~~"); 
  activity();
  if(PartyOn){
    p5.getController("joggingOn").setValue(0);
    p5.getController("lectureOn").setValue(0);
    p5.getController("transitOn").setValue(0); 
    party.start();
  } else {
    party.pause(true);
  }
}  

public void joggingOn(boolean JoggingOn) {
  println(JoggingOn + "joggingOn is On Now~~~~~~");  
  activity();
  if(JoggingOn){
    p5.getController("transitOn").setValue(0); 
    p5.getController("partyOn").setValue(0); 
    p5.getController("lectureOn").setValue(0);
    jogging.start();
  } else {
    println("aha");
    jogging.pause(true);
  }
}  

public void lectureOn(boolean LectureOn) {
  println(LectureOn + "Lecture is On Now~~~~~~");
  activity();
  if(LectureOn){
    p5.getController("joggingOn").setValue(0); 
    p5.getController("transitOn").setValue(0); 
    p5.getController("partyOn").setValue(0); 
    lecture.start();
    lecturing.start();
  } else {
    lecture.pause(true);
    lecturing.pause(true);
  }
}

public void transitOn(boolean TransitOn) {
  println(TransitOn + "transitOn is On Now~~~~~~");  
  activity();
  if(TransitOn){
    p5.getController("joggingOn").setValue(0); 
    p5.getController("lectureOn").setValue(0);
    p5.getController("partyOn").setValue(0); 
    transit.start();
  } else {
    transit.pause(true);
  }   
}  

public void EVENT1() {
  queue.clear();
  priority.clear();
  event();
  server.stopEventStream(); //always call this before loading a new stream
  server.loadEventStream(eventDataJSON1);
  println("**** New event stream loaded: " + eventDataJSON1 + " ****");
}

public void EVENT2() {
  priority.clear();
  queue.clear();
  event();
  server.stopEventStream(); //always call this before loading a new stream
  server.loadEventStream(eventDataJSON2);
  println("**** New event stream loaded: " + eventDataJSON2 + " ****");

} 

public void EVENT3() {
  priority.clear();
  queue.clear();
  event();
  server.stopEventStream(); //always call this before loading a new stream
  server.loadEventStream(eventDataJSON3);
  println("**** New event stream loaded: " + eventDataJSON3 + " ****");
} 

void exchange(Queue<Notification> queue) {
  if (millis() > timeinterval + lastcheck) {
    lastcheck = millis();
    ttsend = false;
  }
  if (counting > 5 && !ttsend && end && ccc && soundend) {
    ttsend = true;
    ccc = false;
    battery(bbb.getValue());
  } else if (count > 8 && !ttsend && end && ccc && soundend) {
    ttsend = true;
    ccc = false;
    network(nnn.getValue()); 
  } else if (memoryinfo && mmr.getBooleanValue() && !memory.isEmpty() && !ttsend && end && ccc && soundend) {
    ttsend = true;
    String msg = "You have received "+callc+" missed call, "+emailc+" emails, "+voicec+" voice mails, "+textc+" text messages, and " + twitterc + " twitters. " + importantc+ " of them are priority 1 as follows.";
    ttsExamplePlayback(msg);
    callc = 0;
    emailc = 0;
    voicec = 0;
    textc = 0;
    twitterc = 0;
    importantc = 0;
    memoryinfo = false;
  } else if (!memoryinfo && mmr.getBooleanValue() && !memory.isEmpty() && !ttsend&& end && ccc && soundend) {
    ttsend = true;
    Notification memoryNot = memory.remove();
    ttsExamplePlayback("Important " + memoryNot.getType() + " from "+ memoryNot.getSender() + ", " + memoryNot.getMessage());
  } else if (!priority.isEmpty() && !ttsend && mmr.getBooleanValue() == false && end == true && ccc && soundend) {
    counting++;
    count++;
    ttsend = true;
    importantc++;
    Notification not = priority.remove();
    memory.add(not);
    switch (not.getType()) {
      case Tweet:
        twitterc++;
        break;
      case Email:
        emailc++;
        break;
      case VoiceMail:
        voicec++;
        break;
      case MissedCall:
        callc++; 
        break;
      case TextMessage:
        textc++;
        break;
    }
    if ((tto.getBooleanValue() && not.getPriorityLevel() == 1) ||((tjo.getBooleanValue() && not.getPriorityLevel() == 1))) {
      String msg = "Important " + not.getType() + " from "+ not.getSender() + ", " + not.getMessage();
      ttsExamplePlayback(msg);
    } else {
      soundend = false;
      aha(not);
    }  
  } else if (!queue.isEmpty() && !ttsend && !mmr.getBooleanValue() && end && ccc && soundend) {
    counting++;
    count++;
    ttsend = true;
    soundend = false;
    Notification not = queue.remove();
    switch (not.getType()) {
      case Tweet:
        twitterc++;
        break;
      case Email:
        emailc++;
        break;
      case VoiceMail:
        voicec++;
        break;
      case MissedCall:
        callc++; 
        break;
      case TextMessage:
        textc++;
        break;  
    }
    aha(not);
  } 
  if (memory.isEmpty()) {
    mmr.setValue(false);
    memoryinfo = true;
  }
  
}

public void aha(Notification not) { //<>//
    println(not.getPriorityLevel() +"  " + not.toString()+"   Processed in aha method!!)");
    switch (not.getType()) {
      case Tweet:
        t1(not);
        break;
      case Email:
        e1(not);
        break;
      case VoiceMail:
        v1(not);
        break;
      case MissedCall:
        c1(not); 
        break;
      case TextMessage:
        x1(not);
        break;  
    }
}

public void t1(Notification not) {
  if (tw.getBooleanValue()) {
    if (tpo.getBooleanValue()) {
      if (not.getPriorityLevel() == 1) { pitchTwitter.setValue(1); twitter();}
      else {vibration();}
    } else if (tjo.getBooleanValue()) {
      if (not.getPriorityLevel() == 1) {
        String twit = "Important tweet from "+ not.getSender() + ", " + not.getMessage();
        ttsExamplePlayback(twit);
      } else if (not.getPriorityLevel() == 2) {
        pitchTwitter.setValue(1.3);
        twitter();
      } else if (not.getPriorityLevel() == 3) {
        pitchTwitter.setValue(1);
        twitter();
      } else {
        pitchTwitter.setValue(0.5);
        twitter();
      }  
    } else if (tto.getBooleanValue()){  
      if (not.getPriorityLevel() == 1) {
          String twit = "Important tweet from "+ not.getSender() + ", " + not.getMessage();
          ttsExamplePlayback(twit);
      } else if (not.getPriorityLevel() == 2) {
          String twit = "New tweet from "+ not.getSender() + ", " + not.getMessage();
          ttsExamplePlayback(twit);
      } else if (not.getPriorityLevel() == 3) {
        pitchTwitter.setValue(1);
        twitter();
      } else { pitchTwitter.setValue(0.7); twitter();}
    }         
  }
}
public void e1(Notification not) {
  if (te.getBooleanValue()) {
    if (tlo.getBooleanValue()) {
      if (not.getPriorityLevel() == 1) {
        vibration();
      }
    } else if (tpo.getBooleanValue()) {
      if (not.getPriorityLevel() == 1 || not.getPriorityLevel() == 2) { 
        if (not.getContentSummary() == 1) { pitchEmail.setValue(1.2); email();}
        else if (not.getContentSummary() == 2) {pitchEmail.setValue(1); email();}
        else {pitchEmail.setValue(.5); email();}
      }    
      else { vibration();}  
    } else if (tjo.getBooleanValue()) {
      if (not.getPriorityLevel() == 1) {
        String eml = "Important e-mail from "+ not.getSender() + ", " + not.getMessage();
        ttsExamplePlayback(eml);
      } else {
        if (not.getContentSummary() == 1) { pitchEmail.setValue(1.2); email();}
        else if (not.getContentSummary() == 2) {pitchEmail.setValue(1); email();}
        else {pitchEmail.setValue(.5); email();}
      }  
    } else if (tto.getBooleanValue()) {  
      if (not.getPriorityLevel() == 1) {
          String eml = "Important e-mail from "+ not.getSender() + ", " + not.getMessage();
          ttsExamplePlayback(eml);
      } else if (not.getPriorityLevel() == 2) {
          String eml = "New e-mail from "+ not.getSender() + ", " + not.getMessage();
          ttsExamplePlayback(eml);        
      } else {
        if (not.getContentSummary() == 1) { pitchEmail.setValue(1.2); email();}
        else if (not.getContentSummary() == 2) {pitchEmail.setValue(1); email();}
        else {pitchEmail.setValue(.5); email();}
      }
    }         
  }  
}

public void x1(Notification not) {
  if (tt.getBooleanValue()) {
    if (tlo.getBooleanValue()) {
      if (not.getPriorityLevel() == 1) {
        vibration();
      }
    } else if (tpo.getBooleanValue()) {
      if (not.getPriorityLevel() == 1 || not.getPriorityLevel() == 2) {
        if (not.getContentSummary() == 1) { pitchMessage.setValue(1.2); message();}
        else if (not.getContentSummary() == 2) {pitchMessage.setValue(1); message();}
        else {pitchMessage.setValue(.5); message();}
      } else {
        vibration();
      }  
    } else if (tjo.getBooleanValue()) {
      if (not.getPriorityLevel() == 1) {
        String msg = "Important message from "+ not.getSender() + ", " + not.getMessage();
        ttsExamplePlayback(msg);
      } else {
        if (not.getContentSummary() == 1) { pitchMessage.setValue(1.2); message();}
        else if (not.getContentSummary() == 2) {pitchMessage.setValue(1); message();}
        else {pitchMessage.setValue(.5); message();}
      }  
    } else if (tto.getBooleanValue()){  
      if (not.getPriorityLevel() == 1) {
          String msg = "Important message from "+ not.getSender() + ", " + not.getMessage();
          ttsExamplePlayback(msg);
      } else if (not.getPriorityLevel() == 2) {
        String msg = "new message from "+ not.getSender() + ", " + not.getMessage();
        ttsExamplePlayback(msg);
      } else {
        if (not.getContentSummary() == 1) { pitchMessage.setValue(1.2); message();}
        else if (not.getContentSummary() == 2) {pitchMessage.setValue(1); message();}
        else {pitchMessage.setValue(.5); message();}
      }
    }         
  }  
}
public void c1(Notification not) {
  if (tc.getBooleanValue()) {
    if (tlo.getBooleanValue()) {
      if (not.getPriorityLevel() == 1) {
        vibration();
      }
    } else if (tpo.getBooleanValue()) {
      if (not.getPriorityLevel() == 1) {
        call2();
        
      } else if (not.getPriorityLevel() == 2) {
        pitchCall.setValue(1);
        call();
      } else {  
        vibration();
      }  
    } else if (tjo.getBooleanValue()) {
      if (not.getPriorityLevel() == 1) {
        String cl = "Important call from "+ not.getSender() + ", " + not.getMessage();
        ttsExamplePlayback(cl);
      } else if (not.getPriorityLevel() == 2) {
        call2();
      } else if (not.getPriorityLevel() == 3) {
        pitchCall.setValue(1.2);
        call();
      } else {
        pitchCall.setValue(1);
        call();
      }  
    } else if (tto.getBooleanValue()){  
      if (not.getPriorityLevel() == 4) {
        pitchCall.setValue(1);
        call();
      } else if (not.getPriorityLevel() == 3) {
        call2();
      } else if (not.getPriorityLevel() == 1) {
        String msg = "Important call from "+ not.getSender() + ", " + not.getMessage();
        ttsExamplePlayback(msg);
      } else if (not.getPriorityLevel() == 2) {
        String msg = "New call from "+ not.getSender() + ", " + not.getMessage();
        ttsExamplePlayback(msg);
      }  
    }         
  }   
}
public void v1(Notification not) {
  if (tv.getBooleanValue()) {
    if (tlo.getBooleanValue()) {
      if (not.getPriorityLevel() == 1 || not.getPriorityLevel() == 2) {
        vibration();
      }
    } else if (tpo.getBooleanValue()) {
      if (not.getPriorityLevel() == 1 || not.getPriorityLevel() == 2) {
        if (not.getContentSummary() == 1) { pitchVoice.setValue(1.3); voicemail();}
        else if (not.getContentSummary() == 2) {pitchVoice.setValue(1); voicemail();}
        else {pitchVoice.setValue(.5); voicemail();}
      } else {
        vibration();
      }  
    } else if (tjo.getBooleanValue()) {
      if (not.getPriorityLevel() == 1) {
        String vml = "Important voice mail from "+ not.getSender() + ", " + not.getMessage();
        ttsExamplePlayback(vml);
      } else {
        if (not.getContentSummary() == 1) { pitchVoice.setValue(1.3); voicemail();}
        else if (not.getContentSummary() == 2) {pitchVoice.setValue(1); voicemail();}
        else {pitchVoice.setValue(.5); voicemail();}
      }  
    } else if (tto.getBooleanValue()){  
      if (not.getPriorityLevel() == 1) {
        String vml = "Important voice mail from "+ not.getSender() + ", " + not.getMessage();
        ttsExamplePlayback(vml);
      } else if (not.getPriorityLevel() == 2) {
        String vml = "New voice mail from "+ not.getSender() + ", " + not.getMessage();
          ttsExamplePlayback(vml);
      } else {
        if (not.getContentSummary() == 1) { pitchVoice.setValue(1.3); voicemail();}
        else if (not.getContentSummary() == 2) {pitchVoice.setValue(1); voicemail();}
        else {pitchVoice.setValue(.5); voicemail();}
      }
    }         
  }  
}

// volume!!
public void volume(int newgain){
  // gainGlide provides input values to the g (Gain) UGen, so changing gainGlide will change the sound volume
  volumeGlide.setValue(newgain/50.0); // remember to rescale gain to reasonable value, like between 0.0 to 1.0 to avoid audio clipping
  println("Volume moved " + volumeGlide.getValue());
} 


void ttsExamplePlayback(String inputSpeech) {
  end = false;
  String ttsFilePath = ttsMaker.createTTSWavFile(inputSpeech);
  sp = getSamplePlayer(ttsFilePath, true); 
  first.addInput(sp);
  sp.start();
  println("TTS: " + inputSpeech);
  sp.setEndListener(
    new Bead() {
    public void messageReceived(Bead message) {
      ttsMaker.cleanTTSDirectory();
      this.pause(true);
      end = true;
    }
  });
}

void activity() {
  activity.setToLoopStart();
  activity.start();
}
void icon() {
  icon.setToLoopStart();
  icon.start();
}
void event() {
  event.setToLoopStart();
  event.start();
}  

void twitter() {
  twitter.setToLoopStart();
  twitter.start();
  twitter.setEndListener(
    new Bead() {
    public void messageReceived(Bead message) {
      twitter.pause(true);
      soundend = true;
    }
  }); 
}


void call() {
  call.setToLoopStart();
  call.start();
  call.setEndListener(
    new Bead() {
    public void messageReceived(Bead message) {
      call.pause(true);
      soundend = true;
    }
  });   
}  

void call2() {
  call2.setToLoopStart();
  call2.start();
  call2.setEndListener(
    new Bead() {
    public void messageReceived(Bead message) {
      call2.pause(true);
      soundend = true;
    }
  }); 

}
void email() {
  email.setToLoopStart();
  email.start();
  email.setEndListener(
    new Bead() {
    public void messageReceived(Bead message) {
      email.pause(true);
      soundend = true;
    }
  }); 
}  

void voicemail() {
  voicemail.setToLoopStart();
  voicemail.start();
  voicemail.setEndListener(
    new Bead() {
    public void messageReceived(Bead message) {
      voicemail.pause(true);
      soundend = true;
    }
  });   
}

void vibration() {
  vibration.setToLoopStart();
  vibration.start();  
  vibration.setEndListener(
    new Bead() {
    public void messageReceived(Bead message) {
      vibration.pause(true);
      soundend = true;
    }
  }); 
}

void message() {
  message.setToLoopStart();
  message.start(); 
  message.setEndListener(
    new Bead() {
    public void messageReceived(Bead message) {
      message.pause(true);
      soundend = true;
    }
  });  
}
void network_good() {
  println("network is good");
  ngood = false;
  network_good.setToLoopStart();
  network_good.start(); 
  network_good.setEndListener(
    new Bead() {
    public void messageReceived(Bead message) {
      network_good.pause(true);
      ngood = true;
      ccc = true;
    }
  });  
}
void network_low() {
  println("network is not good");
  nlow = false;
  network_low.setToLoopStart();
  network_low.start(); 
  network_low.setEndListener(
    new Bead() {
    public void messageReceived(Bead message) {
      network_low.pause(true);
      nlow = true;
      ccc = true;
    }
  });  
}
void network_bad() {
  println("network bad");
  nbad = false;
  network_bad.setToLoopStart();
  network_bad.start(); 
  network_bad.setEndListener(
    new Bead() {
    public void messageReceived(Bead message) {
      network_bad.pause(true);
      nbad = true;
      ccc = true;
    }
  });  
}
void battery_good() {
  println("battery full");
  good = false;
  battery_good.setToLoopStart();
  battery_good.start(); 
  battery_good.setEndListener(
    new Bead() {
    public void messageReceived(Bead message) {
      battery_good.pause(true);
      good = true;
      ccc = true;
    }
  });  
}
void battery_normal() {
  println("battery is fine");
  normal = false;
  battery_normal.setToLoopStart();
  battery_normal.start(); 
  battery_normal.setEndListener(
    new Bead() {
    public void messageReceived(Bead message) {
      battery_normal.pause(true);
      normal = true;
      ccc = true;
    }
  });  
}
void battery_low() {
  println("battery low");
  low = false;
  battery_low.setToLoopStart();
  battery_low.start(); 
  battery_low.setEndListener(
    new Bead() {
    public void messageReceived(Bead message) {
      battery_low.pause(true);
      low = true;
      ccc = true;
    }
  });  
}

void battery_die() {
  println("battery is about to die");
  die = false;
  battery_die.setToLoopStart();
  battery_die.start(); 
  battery_die.setEndListener(
    new Bead() {
    public void messageReceived(Bead message) {
      battery_die.pause(true);
      die = true;
      ccc = true;
    }
  });  
}


public void battery(float value) {
  counting = 0;
  if (value == 4.0f) {
    if (good == true) {
      battery_good();
    } 
  } else if (value == 3.0f) {
    if (normal == true) {
      battery_normal();
    } 
  } else if (value == 2.0f) {
    if (low == true) {
      battery_low();
    } 
  } else { 
    if (die == true) {
      battery_die();
    }  
  }  
}  
public void network(float value) {
  count = 0;
  if (value == 3.0f){
    if (ngood) { network_good();}
  }
  else if (value == 2.0f){
    if (nlow) {network_low();}
  } else { if (nbad) {network_bad();}
  }
}  

void draw() {
  image(bg, 0, 0);
  exchange(queue);
}

class Example implements NotificationListener {
  public Example() {
  }
  public void notificationReceived(Notification notification) {
    if (notification.getPriorityLevel() == 1) {
      priority.add(notification);
    } else {
      queue.add(notification);
    }  

    //println("<Example> " + notification.getType().toString() + " received at " 
    //+ Integer.toString(notification.getTimestamp()) + "millis.");
    
    String debugOutput = "";
    switch (notification.getType()) {
      case Tweet:
        debugOutput += "New tweet from ";
        break;
      case Email:
        debugOutput += "New email from ";
        break;
      case VoiceMail:
        debugOutput += "New voicemail from ";
        break;
      case MissedCall:
        debugOutput += "Missed call from ";
        break;
      case TextMessage:
        debugOutput += "New message from ";
        break;
    }
    debugOutput += notification.getSender() + ", " + notification.getMessage();
    //println(debugOutput);
  }
}
