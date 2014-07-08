/**
 Visualizes the closing of over 500 banks since 2000, according to FDIC data set.
 Dropping balls based off of BouncyBubbles example
 
 @author: D. Erik Goodman
 
 */

PImage country;
Table data;
int total;

// ball data
int numBalls = 0;
float spring = 0.05;
float gravity = 0.09;
float friction = -0.9;
Ball[] balls = new Ball[numBalls];

boolean go;
int startAlpha = 1;
int year = 0;
int group = 2000;

void setup() {
  size(800, 600, P2D);

  country = loadImage("usa.png");
  data = loadTable("banklist.tsv", "header");

  //debug dataset
  for (TableRow row : data.rows ()) {
    String name = row.getString("Bank Name");
    String close = row.getString("Closing Date");
    println(name + ", " + close);
  }  

  go = false;
  noStroke();
  smooth();
  startScreen();
}

void draw() {
  //intro screen, waiting on mouse click
  if (!go) {
    delay(150);
    String startPrompt = "click to begin";
    fill(0, 102, 153, startAlpha);
    text(startPrompt, 200, 400, 750, 600);
    startAlpha++;

    // main visualizaiton
  } else {
    background(240);
    image(country, 20, 200);

    textSize(22);
    String directions = "click \"r\" for more recent years, \n\"o\" for older years";
    fill(0, 102, 153, 71);
    text(directions, 100, 100, 400, 200);

    fill(0);
    textSize(26);
    String thisYear = "This year: ";
    text(thisYear, 526, 130);
    textSize(36);
    text(numBalls, 652, 134);

    fill(0);
    textSize(80);
    String yr = Integer.toString(group + year);
    text(yr, 520, 86);

    // ball physics
    for (int i = 0; i < numBalls; i++) {
      fill(255, 0, 0, 204); 
      balls[i].collide();
      balls[i].move();
      balls[i].display();
    }

    // title and 'total bar' stay in front
    fill(0, 102, 153);
    textSize(72);
    String title = "Failed Banks";
    text(title, 20, 80);

    // fail-o-meter
    fill(170, 0, 0, 51);
    rect(width - 20, height - 528, 15, 528);
    fill(170, 0, 0);
    rect(width - 20, height - total, 15, total);
  }
}

//click to start
void mouseClicked() { 
  go = true;
  update();
}  

// change views
void keyPressed() { 
  if (key == 'r' && year < 14) {
    year++;
  } else if (key == 'o' && year > 0) {
    year--;
  } else {
    return;
  }  
  update();
}

void drawBalls() {
  this.balls = new Ball[numBalls];
  println("numBalls (drawBalls()): " + numBalls);
  fill(200, 0, 0, 204); 
  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(random(width), random(height), random(30, 70), i, balls);
  }
}  

// aka splashscreen
void startScreen() {
  background(20);
  textSize(32);
  String top = "\"You could carve out the inside of a brick and hide your money in it for safe keeping. It’s certainly safer than keeping it in the bank!\"";
  fill(0, 102, 153);
  text(top, 50, 50, 750, 600);
  String bottom = "― Nicole McKay";
  fill(0, 152, 103, 95);
  text(bottom, 350, 250, 750, 600);
}

void update() {
  // debug update
  println();
  println("update");
  println();
  println("year: " + Integer.toString(year));
  //find # balls to spawn per year
  numBalls = 0;

  // super hacky way to parse table data
  String searchYear = "";
  if (year < 10) {
    searchYear = "-0" + Integer.toString(year);
  } else { //need to add a hyphen for string formatting
    searchYear = "-" + Integer.toString(year);
  }  

  println("searchYear: " + searchYear);
  int rowNum = 0;
  for (int i = 0; i < data.getRowCount (); i++) {
    TableRow row = data.getRow(i);
    //find closed banks per year
    if (row.getString("Closing Date").contains(searchYear)) {
      if (rowNum == 0)
        // count all remaining rows after first instance to get total failed banks
        total = data.getRowCount() - i ;
      String name = row.getString("Bank Name");
      String close = row.getString("Closing Date");
      println(name + ", " + close);
      rowNum++;
      // add to ball count
      numBalls++;
    }
  }
  println("total: " + total);
  println("numBalls (update()): " + numBalls);  
  drawBalls();
}  

// below here is BouncyBubbles example code

class Ball {

  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  Ball[] others;

  Ball(float xin, float yin, float din, int idin, Ball[] oin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
  } 

  void collide() {
    for (int i = id + 1; i < numBalls; i++) {
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].diameter/2 + diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * spring;
        float ay = (targetY - others[i].y) * spring;
        vx -= ax;
        vy -= ay;
        others[i].vx += ax;
        others[i].vy += ay;
      }
    }
  }

  void move() {
    vy += gravity;
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction;
    } else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction;
    } else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }
  }

  void display() {
    ellipse(x, y, diameter, diameter);
  }
}

