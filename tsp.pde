HScrollbar bar;
float maxCities = 1000;
int sliderHeight = 20;
int prevCities = 0;
ArrayList<City> cities;
ArrayList<City> chosenCities;

float TSPDistance = 0;
float bestDist = 100000;

void setup()
{
  size(800, 800, P2D);
  bar = new HScrollbar(50, 50, 250, sliderHeight, 1, 0.1);
}

void draw()
{
  background(0);
  bar.update();
  int newCities = round(bar.getPos() * maxCities);
  if (newCities != prevCities)
  {
    prevCities = newCities;
    cities = new ArrayList<City>();
    chosenCities = new ArrayList<City>();
    for (int i = 0; i < newCities; i++)
      cities.add(new City(random(50, width - 50), random(200, height - 50)));
    bestDist = 1000000;
  }
  
  /* 
   * Inside here is the actual logic behind picking the path in each frame.
   * Everything else is drawing and analytics. Put your logic below in this 'if' statement.
   */
  if (!resetConditions(cities, chosenCities))
  {
    updateCities(cities, chosenCities);
  }
  else
  {
     delay(250);
     bestDist = min(TSPDistance, bestDist);
     cities = chosenCities;
     chosenCities = new ArrayList<City>();
  }
  
  bar.display();
  noFill();
  for (City c : cities)
    c.display();
  for (City c : chosenCities)
    c.display();
    
  if (chosenCities.size() > 0)
  {
    noFill();
    beginShape();
    for (City c : chosenCities)
      vertex(c.x, c.y);
    vertex(chosenCities.get(0).x, chosenCities.get(0).y);
    endShape();
  }
    
  TSPDistance = 0;
  for (int i = 1; i <= chosenCities.size(); i++)
    TSPDistance += chosenCities.get(i-1).distance(chosenCities.get(i % chosenCities.size()));
  
  fill(255, 255, 255);
  textSize(sliderHeight);
  text("Number of Cities:", width - 300, 50 + sliderHeight);
  text(round(bar.getPos() * maxCities), width - 100, 50 + sliderHeight);
  
  text("Current Distance:", width - 300, 50 + sliderHeight * 2 + 5);
  text(round(TSPDistance), width - 100, 50 + sliderHeight * 2 + 5);
  
  text("Best Distance:", width - 300, 50 + sliderHeight * 3 + 10);
  text(round(bestDist), width - 100, 50 + sliderHeight * 3 + 10);
}

/*
* Updates the cities and the currently set chosen cities on the next frame in the algorithm.
* Change the logic below for different algorithms, such as this inductive approach or simulated annealing.
*/
void updateCities(ArrayList<City> cities, ArrayList<City> chosenCities)
{
    float minTotalDist = 10000000;
    int index = floor(random(cities.size()));
    for (int i = 0; i < cities.size(); i++)
    {
       City c = cities.get(i);
       float minDist = 10000000;
       for (City c_ : chosenCities)
           minDist = min(c_.distance(c), minTotalDist);
       if (minDist < minTotalDist)
       {
           minTotalDist = minDist;
           index = i;
       }
    }
    City newCity = cities.get(index);
      
    int insertIndex = 0;
    float minDist = 1000000;
    for (int i = 1; i <= chosenCities.size(); i++)
    {
      float addedDist = newCity.distance(chosenCities.get(i-1)) + newCity.distance(chosenCities.get(i % chosenCities.size())) - 
        chosenCities.get(i-1).distance(chosenCities.get(i % chosenCities.size()));  
        
      if (addedDist < minDist)
      {
         minDist = addedDist;
         insertIndex = i % chosenCities.size();
      }
    }
    
    chosenCities.add(insertIndex, newCity);
    cities.remove(newCity);
}

boolean resetConditions(ArrayList<City> cities, ArrayList<City> chosenCities)
{
    return cities.size() == 0;  
}

void keyPressed()
{
  if (key == CODED)
  {
     if (keyCode == LEFT)
     {
       bar.shift(-0.5);
     }
     else if (keyCode == RIGHT)
     {
       bar.shift(0.5);
     }
     bar.update();
  }
}

class City 
{
   float x;
   float y;
   
   City (float x_, float y_) 
   {
      x = x_;
      y = y_;
   }
   
   void display()
   {
      stroke(255);
      ellipse(x, y, 5, 5);
   }
   
   float distance(City b)
   {
      return sqrt((x-b.x)*(x-b.x) + (y-b.y)*(y-b.y)); 
   }
}

class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l, float initialVal) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp;
    spos = initialVal * (swidth - sheight) + xpos;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    over = overEvent();
    
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }
  
  void shift(float x)
  {
    newspos = max(newspos + (.01 * (swidth - sheight) * x), xpos);
    newspos = min(newspos, swidth - sheight + xpos);
    spos = newspos;
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return (spos - xpos) / (swidth - sheight);
  }
}
