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
PImage cur;
int imgIndex = 0, 
areaHeight = 10, 
areaWidth = 10;

void setup() {
  size(600, 600);
  cur = loadImage(url[imgIndex]);
  frameRate(10);
}

void draw() {
  image(cur, 0, 0);
  println(checkImage());
  if (frameCount % 15 == 0) {
    getImage();
  }
}

boolean getImage() {
  println(url[imgIndex]);
  imgIndex = (imgIndex+1) % url.length; 
  cur = loadImage(url[imgIndex]);
  if (cur == null) return getImage();
  else return true;
}
public float checkImage() {
  cur.loadPixels();
  int imgW = cur.width;
  int imgH = cur.height;
  int pixCount = imgW * imgH;
  int startPix = (pixCount / 2) - (5*imgW) - 5;
  float totalBrightness = 0;
  for (int i = 0; i < areaHeight; i ++ ) {
    for (int j = 0; j < areaWidth; j++ ) {
      totalBrightness += brightness(cur.pixels[startPix + (j) + (i*imgW)]);
    }
  }  
  return totalBrightness/(areaHeight*areaWidth);
}

