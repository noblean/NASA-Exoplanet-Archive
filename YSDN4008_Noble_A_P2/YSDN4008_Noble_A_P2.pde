 /*
*  Angela Noble - project 2
*/

PImage i1;
PImage i2;
PImage i3;
PImage i4;

PShape svg;
PShape circ;
PShape info;

import controlP5.*; // importing the ControlP5 library

ControlP5 cp5;


boolean radialVelocity = false;
boolean transit = true;
boolean imaging = false;
boolean other = true;

float[] randoms = new float[3837]; // random numbers fo rthe angles


Range range;  // defining a variable of type Range

int min = MAX_INT; 
int max = MIN_INT; 

Table data;
int rowCount; // for calculating the # of rows in a data file
int  orbit, bright, b, radius, distance;
String number, disc, dyear, name;

int year;

float r; // radius 
float theta; // angle for the polar coodinate 
float x, y; // draw data points


float originX, originY;
float zoom = 1.0;
float rotateAngle = 0.0;
float diameter = 50;
float speed = 0.05;

int total; // for total number callout

PFont myFont;

void setup() {
    size(1200, 730);
    
    myFont=createFont("Montserrat-Medium-14.vlw", 14);
    textFont(myFont);
    
    originX = width/2;
    originY = height/2;
   
    data = loadTable("p2-edited.csv", "header");
    rowCount = data.getRowCount();
    println(rowCount);
    textAlign(CENTER);
    
    smooth();
    
    // IMG
            i1 = loadImage("p.png");  // purple
            i2 = loadImage("g.png");  // green
            i3 = loadImage("b.png");  // blue
            i4 = loadImage("o.png");  // orange
    
    // SVG
            svg = loadShape("back1.svg");
            circ = loadShape("circles.svg");
            info = loadShape("info.svg");
    
    // min max value for slider
    for(int row = 0; row < rowCount; row++) {
          int value = data.getInt(row, "discoveryYear");
          if (value > max) {max = value;}
          if (value < min) {min = value;}
    }
    
    // random
          for (int i = 0; i < randoms.length; i++) {
              randoms[i] = random(361);
          } 
    
    // ControlP5
    cp5 = new ControlP5(this); // initialize the cp5 variable
   
              // create toggle transit
              cp5.addToggle("transit")
                     .setPosition(width/2 - 190,670)
                     .setSize(20,20)
                     .setColorActive(color(#92d4ec, 255))
                     .setColorForeground(color(#92d4ec, 255))
                     .setColorBackground(color(#92d4ec, 70))
                     .setLabelVisible(false)
                     ;
                 
              // create toggle radialVelocity
              cp5.addToggle("radialVelocity")
                     .setPosition(width/2 - 60,670)
                     .setSize(20,20)
                     .setColorActive(color(#8425fd, 255))
                     .setColorForeground(color(#8425fd, 255))
                     .setColorBackground(color(#8425fd, 70))
                     // .setFont(myFont)
                     .setLabelVisible(false) 
                     ;
                 
                 
              // create toggle imaging
              cp5.addToggle("imaging")
                     .setPosition(width/2 + 60,670)
                     .setSize(20,20)
                     .setColorActive(color(#fd9f25, 255))
                     .setColorForeground(color(#fd9f25, 255))
                     .setColorBackground(color(#fd9f25, 50))
                     .setLabelVisible(false) 
                     ;
                 
              // create toggle other
              cp5.addToggle("other")
                     .setPosition(width/2 + 190,670)
                     .setSize(20,20)
                     .setColorActive(color(#b8fd25, 255))
                     .setColorForeground(color(#b8fd25, 255))
                     .setColorBackground(color(#b8fd25, 50))
                     .setLabelVisible(false) 
                     ;
                    
             
               // create the range selector
               range = cp5.addRange("year")
                         // disable broadcasting since setRange and setRangeValues will trigger an event
                         .setBroadcast(false) 
                         .setPosition(width/2 - 190, 630)
                         .setSize(400,25)
                         .setHandleSize(7)
                         .setDecimalPrecision(0)
                         .setRange(min, max)
                         .setRangeValues(min, max)
                         // after the initialization we turn broadcast back on again
                         .setBroadcast(true)
                         .setColorForeground(color(100,90))
                         .setColorBackground(color(255,40))  
                         .setFont(myFont)
                         .setCaptionLabel("") 
                         .setColorActive(#4B2155)
                         ;  
                         
                
} // close setup




void draw() {
   
     shape(svg, 0, 0); // draw background image
    
  for(int row = 0; row < rowCount; row ++) {
    
            name = data.getString(row, "name");
            disc = data.getString(row, "discoveryMethod");
            dyear = data.getString(row, "discoveryYear");
            orbit = data.getInt(row, "orbitalPeriod");
            bright = data.getInt(row, "brightnessHostStar");
            radius = data.getInt(row, "radius");
            distance = data.getInt(row, "distance");
      
            
            // Mapping 
                  distance = int(map(distance, 0, 10000, 10, 1400));
                  radius = int(map(radius, 0, 500, 5, 200));
           
            
            // No mapping for callout
                  String rad =  data.getString(row, "radius");
                  String dist = data.getString(row, "distance");
                  int number = data.getInt(row, "number");
                  year = data.getInt(row, "discoveryYear");
        
        
      if (year >= min && year <= max) {
          
           pushMatrix();   
           translate(originX, originY);
           scale(zoom);
           textFont(myFont,14);
           noFill();
           
           
                   r = distance; 
                
                   theta = randoms[row] * (2*PI / 360);  
                   
                    x = (r * cos(theta));
                    y = (r * sin(theta));
                    
                   ellipse(x, y, radius, radius);
                   
                 
            // callout filtering with discovery method buttons
            
            // Radial Velocity
            if (disc.equals("Radial Velocity") && radialVelocity)       
                  { noFill(); image(i1, x, y, radius, radius); total++;
                    float callOut = dist( x, y, mouseX - originX - 5, mouseY - originY -5);
                            if (callOut < 6) {
                                    textAlign(CENTER);
                                    fill(255);
                                    text(dyear, mouseX - originX, mouseY - originY - 15);
                                    text( disc, mouseX - originX, mouseY - originY - 32);
                                    text( "Planets in Solar System: " + number, mouseX - originX, mouseY - originY - 49);
                                    text("Radius: " + rad + "   Distance: " + dist, mouseX - originX, mouseY - originY - 66);
                                    text( name, mouseX - originX, mouseY - originY - 83);
                           }} 
                       
                           
            // Transit               
            else if (disc.equals("Transit") && transit)                 
                    { noFill(); image(i3, x, y, radius, radius);  total++;
                      float callOut = dist( x, y, mouseX - originX - 5, mouseY - originY -5);
                              if (callOut < 6) {
                                    textAlign(CENTER);
                                    fill(255);
                                    text(dyear, mouseX - originX, mouseY - originY - 15);
                                    text( disc, mouseX - originX, mouseY - originY - 32);
                                    text( "Planets in Solar System: " + number, mouseX - originX, mouseY - originY - 49);
                                    text("Radius: " + rad + "   Distance: " + dist, mouseX - originX, mouseY - originY - 66);
                                    text( name, mouseX - originX, mouseY - originY - 83);
                             } } 
               
                   
            // Imaging       
            else if (disc.equals("Imaging") && imaging) 
                  { noFill(); image(i4, x, y, radius, radius); total++;
                    float callOut = dist( x, y, mouseX - originX - 6, mouseY - originY -6);
                            if (callOut < 5) {
                                    textAlign(CENTER);
                                    fill(255);
                                    text(dyear, mouseX - originX, mouseY - originY - 15);
                                    text( disc, mouseX - originX, mouseY - originY - 32);
                                    text( "Planets in Solar System: " + number, mouseX - originX, mouseY - originY - 49);
                                    text("Radius: " + rad + "   Distance: " + dist, mouseX - originX, mouseY - originY - 66);
                                    text( name, mouseX - originX, mouseY - originY - 83);
                           }}   
            
            
            // Other 
            else if (disc.equals("Eclipse Timing Variations") && other)      
                { noFill(); image(i2, x, y, radius, radius); total++;
                  float callOut = dist( x, y, mouseX - originX - 5, mouseY - originY -5);
                          if (callOut < 6) {
                                  textAlign(CENTER);
                                  fill(255);
                                  text(dyear, mouseX - originX, mouseY - originY - 15);
                                  text( disc, mouseX - originX, mouseY - originY - 32);
                                  text( "Planets in Solar System: " + number, mouseX - originX, mouseY - originY - 49);
                                  text("Radius: " + rad + "   Distance: " + dist, mouseX - originX, mouseY - originY - 66);
                                  text( name, mouseX - originX, mouseY - originY - 83);
                         }}  
                   
            // Other       
            else if (disc.equals("Transit Timing Variations") && other)       
                  {  noFill(); image(i2, x, y, radius, radius);  total++;
                    float callOut = dist( x, y, mouseX - originX - 5, mouseY - originY -5);
                          if (callOut < 6) {
                                  textAlign(CENTER);
                                  fill(255);
                                  text(dyear, mouseX - originX, mouseY - originY - 15);
                                  text( disc, mouseX - originX, mouseY - originY - 32);
                                  text( "Planets in Solar System: " + number, mouseX - originX, mouseY - originY - 49);
                                  text("Radius: " + rad + "   Distance: " + dist, mouseX - originX, mouseY - originY - 66);
                                  text( name, mouseX - originX, mouseY - originY - 83);
                         }}  
                   
            // Other       
            else if (disc.equals("Pulsation Timing Variations") && other)    
                    {  noFill(); image(i2, x, y, radius, radius); total++;
                      float callOut = dist( x, y, mouseX - originX - 5, mouseY - originY -5);
                          if (callOut < 6) {
                                  textAlign(CENTER);
                                  fill(255);
                                  text(dyear, mouseX - originX, mouseY - originY - 15);
                                  text( disc, mouseX - originX, mouseY - originY - 32);
                                  text( "Planets in Solar System: " + number, mouseX - originX, mouseY - originY - 49);
                                  text("Radius: " + rad + "   Distance: " + dist, mouseX - originX, mouseY - originY - 66);
                                  text( name, mouseX - originX, mouseY - originY - 83);
                         }}
                         
            // Other             
            else if (disc.equals("Orbital Brightness Modulation") && other)   
                  { noFill(); image(i2, x, y, radius, radius);  total++;
                    float callOut = dist( x, y, mouseX - originX - 5, mouseY - originY -5);
                          if (callOut < 6) {
                                  textAlign(CENTER);
                                  fill(255);
                                  text(dyear, mouseX - originX, mouseY - originY - 15);
                                  text( disc, mouseX - originX, mouseY - originY - 32);
                                  text( "Planets in Solar System: " + number, mouseX - originX, mouseY - originY - 49);
                                  text("Radius: " + rad + "   Distance: " + dist, mouseX - originX, mouseY - originY - 66);
                                  text( name, mouseX - originX, mouseY - originY - 83);
                         }}  
                  
            // Other      
            else if (disc.equals("Microlensing") && other)                     
                { noFill(); image(i2, x, y, radius, radius); total++;
                  float callOut = dist( x, y, mouseX - originX - 5, mouseY - originY -5);
                          if (callOut < 6) {
                                  textAlign(CENTER);
                                  fill(255);
                                  text(dyear, mouseX - originX, mouseY - originY - 15);
                                  text( disc, mouseX - originX, mouseY - originY - 32);
                                  text( "Planets in Solar System: " + number, mouseX - originX, mouseY - originY - 49);
                                  text("Radius: " + rad + "   Distance: " + dist, mouseX - originX, mouseY - originY - 66);
                                  text( name, mouseX - originX, mouseY - originY - 83);
                         } } 
                         
            // Other             
            else if (disc.equals("Pulsar Timing") && other)                   
                    { noFill(); image(i2, x, y, radius, radius);  total++;
                      float callOut = dist( x, y, mouseX - originX - 5, mouseY - originY -5);
                          if (callOut < 6) {
                                  textAlign(CENTER);
                                  fill(255);
                                  text(dyear, mouseX - originX, mouseY - originY - 15);
                                  text( disc, mouseX - originX, mouseY - originY - 32);
                                  text( "Planets in Solar System: " + number, mouseX - originX, mouseY - originY - 49);
                                  text("Radius: " + rad + "   Distance: " + dist, mouseX - originX, mouseY - originY - 66);
                                  text( name, mouseX - originX, mouseY - originY - 83);
                         } } 
                     
            // Other         
            else if (disc.equals("Astrometry") && other)                     
                    { noFill(); image(i2, x, y, radius, radius); total++;
                      float callOut = dist( x, y, mouseX - originX - 5, mouseY - originY -5);
                          if (callOut < 6) {
                                  textAlign(CENTER);
                                  fill(255);
                                  text(dyear, mouseX - originX, mouseY - originY - 15);
                                  text( disc, mouseX - originX, mouseY - originY - 32);
                                  text( "Planets in Solar System: " + number, mouseX - originX, mouseY - originY - 49);
                                  text("Radius: " + rad + "   Distance: " + dist, mouseX - originX, mouseY - originY - 66);
                                  text( name, mouseX - originX, mouseY - originY - 83);
                         } } 
           
            else {  noFill();  noStroke(); }
               
       popMatrix();
        
            
            } // close year min max loop
        
              // draw the total value 
                  fill(0);
                  rect(width/2- 50, 65,100, 40);
                  noStroke();
                  
                  textFont(myFont,25);
                  textAlign(CENTER);
                  fill(255);
                  text(total, width/2, 95);
                  smooth();
            
     } // close rowcount loop
      
      
     // reset total value number
            total=0; 
      
      
     // info icon
            pushMatrix();   
                  translate(originX, originY);
                  scale(zoom);
                  shape(circ, 0- width/2, 0-height/2);
            popMatrix();
      
      
     // info hover
          if(dist(50, 50, mouseX, mouseY) < diameter / 2) {
           shape(info, 0, 0);
          } else {}
      
      
} // closing draw



void controlEvent(ControlEvent theControlEvent) {
      if(theControlEvent.isFrom("year")) {
            min = int(theControlEvent.getController().getArrayValue(0));
            max = int(theControlEvent.getController().getArrayValue(1));
             // println(min + "  " + max);
      } 
}

  
  void keyPressed () {
    if(key == CODED) {
        if        (keyCode == UP)   { originY = originY + 30; } 
        else if   (keyCode == DOWN) { originY = originY - 30;}
        else if   (keyCode == RIGHT){ originX = originX - 30; }
        else if   (keyCode == LEFT) { originX = originX + 30; }
    }  
    
    else if   (key == '=')      { zoom = constrain(zoom + speed, 0, 10);}
    else if   (key == '-')      { zoom = constrain(zoom - speed, 0, 10);}
    
    else if   (key == ' ')      {
      zoom = 1.0; 
      rotateAngle = 0;
      originX = width/2;
      originY = height/2;
    }
    
} // end key pressed 
