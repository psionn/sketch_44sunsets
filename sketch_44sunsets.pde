import java.awt.Image;
import java.awt.Toolkit;
String[] url = {
  "http://www.wrh.noaa.gov/images/slc/camera/latest/olympuscove.latest.jpg", 
  "http://www.wrh.noaa.gov/images/slc/camera/latest/monticello.latest.jpg", 
  "http://www2.nature.nps.gov/air/webcams/parks/grcacam/grca.jpg", 
  "http://sv.berkeley.edu/view/images/newview.jpg", 
  "http://katkam.ca/pic.aspx", 
  "http://www.avo.alaska.edu/webcam/augustine.jpg", 
  "http://mylex.cc.hirosaki-u.ac.jp/photo/hirou2c2.jpg", 
  "http://www.hko.gov.hk/wxinfo/aws/hko_mica/sk2/latest_SK2.jpg", 
  "http://www.transport.sa.gov.au/data/citycam/adelaideview.jpg"
};
PImage  prev, 
        cur,
        next,
        glitch;
int     imgIndex = 0, 
        areaHeight = 10, 
        areaWidth = 10,
        lastChecked = 0,
        transitionFrame = 10,
        alpha = 0;
int[]   transitionMatrix = new int[640*480];
float   glitchAlpha = 0;

boolean debugMode = false,
        glitching = false;

void setup() {
  size(640, 480);
  cur = loadImage(url[imgIndex]);
  cur = fitImage(cur);
  
  glitch = createImage(width, height, RGB);
  prev = cur;
}

void draw() {
  noTint();
  image(cur, 0, 0);

  tint(255, alpha);
  image(prev, 0, 0);
  if (frameCount % 30 == 0 && debugMode) {
    getImage(true);
    transitionFrame = 0;
  } 
  else {
    if (checkImage(cur) < 80) {
      getImage(true);
      transitionFrame = 0;
    } else if ( millis() - lastChecked > 10000 ) {
      lastChecked = millis();
      println(month() + "/"+ day() + " " + hour() + ":" + nf(minute(),2) + ":" + nf(second(),2) + " - Checking...");
      getImage(false);
    }
    if (glitching) {
      
      glitch(1);
      glitchAlpha = map(mouseX, 0, width, 0, 255);
      tint(255, glitchAlpha);
//      noTint();
      image(glitch, 0, 0); 
    }
  }

  transition();
}


void transition() {
  //  cur = next;
  if (transitionFrame > 9 ) return;
  if (transitionFrame == 0) {
    prev = cur;
    cur = next;
    alpha = 255;
  }

  alpha -= (255/10);
  transitionFrame++;
}
boolean getImage(boolean getNewImage) {
  if (getNewImage) {
    imgIndex = (imgIndex+1) % url.length;
    println(month() + "/"+ day() + " " + hour() + ":" + nf(minute(),2) + ":" + nf(second(),2) + " - " + url[imgIndex]);

  }
  byte[] imgBytes = loadBytes(url[imgIndex]);
  if (imgBytes.length < 500) {
    return getImage(getNewImage);
  } 
  else {
    Image awtImage = Toolkit.getDefaultToolkit().createImage(imgBytes);
    next = loadImageMT(awtImage);
    if (checkImage(next) < 80) return getImage(true);
    next = fitImage(next);
    //  cur = loadImage(url[imgIndex]);
    return true;
  }
}

float checkImage(PImage img) {
  img.loadPixels();
  int pixCount = img.width * img.height;
  int startPix = (img.width*5)+(img.width/2) - 5;
  float totalBrightness = 0;
  for (int i = 0; i < areaHeight; i ++ ) {
    for (int j = 0; j < areaWidth; j++ ) {
      totalBrightness += brightness(img.pixels[startPix + (j) + (i*img.width)]);
    }
  }  
  return totalBrightness/(areaHeight*areaWidth);
}

PImage fitImage(PImage img) {
  float wR = (float)img.width / width;
  float hR = (float)img.height/ height;
  if (hR < wR) {
    img.resize(ceil(img.width/hR), ceil(img.height/hR));
  } 
  else {
    img.resize(ceil(img.width/wR), ceil(img.height/wR));
  }
  return img;
}

void glitch(int segment) {
//  try {
//    glitch = (PImage) cur.clone();
//  } catch (Exception e) {
//    println("Clone failed");
//  }
  glitch.loadPixels();
  for (int i = 0; i < width*height; i++) {
    glitch.pixels[i] += cur.pixels[i] /10;
  }
  glitch.updatePixels();
}

void keyPressed() {
  glitching = !glitching; 
}



