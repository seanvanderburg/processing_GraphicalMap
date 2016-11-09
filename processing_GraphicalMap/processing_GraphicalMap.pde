//plot Iceland earthquakes

PImage iceland;
PImage colourscale;
JSONObject json;
JSONObject data;
JSONArray jsonArray;

String timestamp;
float latitude;
float longitude;
float depth;
float size;
float quality;
String humanReadableLocation;

float x;
float y;
float sizeMap;  

float percent;
color between;

void setup() {
  //Optional: convert coordinate systems
  //dmsconvert();
  //decimalconvert();

  size (1280, 720);
  iceland = loadImage("ijsland_achtergrond.png");
  colourscale = loadImage("legenda_schaal.png");
  iceland.resize(1280, 720);
  colourscale.resize(300, 40);
}

void draw() {
  image(iceland, 0, 0);
  image(colourscale, 850, 590);
  text("Diepte in km", 920, 585);
  json = loadJSONObject("ijsland-metingen.json");
  jsonArray = json.getJSONArray("results");
  textSize(32);
  text("Aardbevingen Ijsland", 60, 60);
  textSize(20);
  text("Bron: http://en.vedur.is/earthquakes-and-volcanism/earthquakes/", 20, 700);

  processJSON();
}

//loops through the JSON array, and draws the data to the map
void processJSON() {
  for (int i = 0; i < jsonArray.size(); i++) {

    data = jsonArray.getJSONObject(i); 

    timestamp = data.getString("timestamp");
    latitude = data.getFloat("latitude");
    longitude = data.getFloat("longitude");
    depth = data.getFloat("depth");
    size = data.getFloat("size");
    quality = data.getFloat("quality");
    humanReadableLocation = data.getString("humanReadableLocation");

    x = map(longitude, -24, -14, 145, 1100); 
    y = map(latitude, 66, 64, 216, 540);
    sizeMap = map(size, -1, 1.2, 10, 50);

    percent = norm(depth, 0, 15);
    between = lerpColor(#00FF06, #B20100, percent); 
    fill(between);  
    ellipse(x, y, sizeMap, sizeMap);
    
    fill(#202020);
    if (hoverEllipse(x, y, sizeMap) == true) {
      text(humanReadableLocation, 400, 50);
      text("Magnitude:", 400, 80);      
      text(size, 550, 80);
    }
  }
}

//check for ellipse mouseover
boolean hoverEllipse(float x, float y, float sizeMap) {

  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < sizeMap/2 ) {
    return true;
  } else {
    return false;
  }
}

//convert degrees/minutes/seconds to decimals
void decimalconvert() {
  double degrees = 30;
  double minutes = 15;
  double seconds = 50;

  double decimals = degrees + (minutes/60) + (seconds/3600);
  System.out.println("\n\nDecimals:" + decimals);
}

//convert decimals to DMS
void dmsconvert() {
  double decimals = 50.34444;
  double degrees = Math.floor (decimals);
  double minfloat = (decimals-degrees)*60;
  double minutes = Math.floor(minfloat);
  double secfloat = (minfloat-minutes)*60;
  double seconds = Math.round(secfloat);
  //correct rounding
  if (seconds == 60) {
    minutes ++;
    seconds =0;
  }
  if (minutes == 60) {
    degrees ++;
    minutes =0;
  }
  System.out.println("Degrees: " + degrees + "\nMinutes: " + minutes + "\nSeconds: " + seconds);
}