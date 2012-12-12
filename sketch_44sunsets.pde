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
PImage prev, cur, next;
int imgIndex = 0, 
areaHeight = 10, 
areaWidth = 10;
int[] transitionMatrix = new int[640*480];
int transitionFrame = 10;
int alpha = 0;

void setup() {
  size(640, 480);
  cur = loadImage(url[imgIndex]);
  cur = fitImage(cur);
  prev = cur;
  frameRate(10);
}

void draw() {
  noTint();
  image(cur, 0, 0);
  
  tint(255,alpha);
  image(prev, 0, 0);
  println(checkImage());
  if (frameCount % 30 == 0) {
    getImage();
    transitionFrame = 0;
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
//  cur.loadPixels();
//  next.loadPixels();
//  println(cur.pixels.length + " " + next.pixels.length);
//  for (int i = 0; i < cur.pixels.length; i++) {
//    if (transitionFrame == 0) transitionMatrix[i] = (cur.pixels[i] - next.pixels[i]) / 10;
//    cur.pixels[i] += transitionMatrix[i];
//  }
//  cur.updatePixels();
  alpha -= (255/10);
  transitionFrame++;
}
boolean getImage() {
  println(url[imgIndex]);
  imgIndex = (imgIndex+1) % url.length; 
  byte[] imgBytes = loadBytes(url[imgIndex]);
  if (imgBytes.length < 500) {
    return getImage();
  } 
  else {
    Image awtImage = Toolkit.getDefaultToolkit().createImage(imgBytes);
    next = loadImageMT(awtImage);
    next = fitImage(next);
    //  cur = loadImage(url[imgIndex]);
    return true;
  }
}

float checkImage() {
  cur.loadPixels();
  int pixCount = cur.width * cur.height;
  int startPix = (cur.width*5)+(cur.width/2) - 5;
  float totalBrightness = 0;
  for (int i = 0; i < areaHeight; i ++ ) {
    for (int j = 0; j < areaWidth; j++ ) {
      totalBrightness += brightness(cur.pixels[startPix + (j) + (i*cur.width)]);
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

