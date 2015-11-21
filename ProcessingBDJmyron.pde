// Stavros Kalapothas
// Blob detection using JMyron computer vision library in Processing
// Created on 12/2012

// Based on JMyron library & Daniel's Shiffman examples
// http://www.learningprocessing.com/examples/
// 9-8 & 16-11

import JMyron.*;

JMyron m; // camera object

// declare two arrays with 50 elements.
int[] xpos = new int[50]; 
int[] ypos = new int[50];

void setup(){
  size(640,480);
  m = new JMyron(); // make a new instance of the object
  m.start(width,height); // start a capture at 640x480
  m.trackColor(0,0,0,100); // R,G,B, and range of similarity  starts set to black
  m.minDensity(100); // minimum pixels in the glob required to result in a circle
  m.maxDensity(300); // maximum pixels in the glob required to result in a circle
  println("Myron " + m.version()); // print the library version
  noFill();
  // initialise the array values
  for (int i = 0; i < xpos.length; i ++) {
    xpos[i] = 0; 
    ypos[i] = 0;
  }
} 

void draw(){
  background(255);
  m.update(); // update the camera view
  drawCamera(); // draw the camera to the screen
  int[][] b = m.globBoxes(); // get the center points
  for (int i=0;i<b.length;i++) {
    // New location where the glob center is 
    xpos[xpos.length-1] = b[i][0]; // Update the last spot in the array with the mouse location.
    ypos[ypos.length-1] = b[i][1];
  }
  
  // Shift array values
  for (int i = 0; i < xpos.length-1; i ++ ) {
    // Shift all elements down one spot. 
    // xpos[0] = xpos[1], xpos[1] = xpos = [2], and so on. Stop at the second to last element.
    xpos[i] = xpos[i+1];
    ypos[i] = ypos[i+1];
  }
   
  for (int i = 0; i < xpos.length; i ++ ) {
    // Draw an ellipse for each element in the arrays. 
    // Color and size are tied to the loop's counter: i.
    noStroke();
    fill(255-i*5);
    ellipse(xpos[i],ypos[i],i,i);
  }
}

void drawCamera(){
  int[] img = m.image(); // get the normal image of the camera
  loadPixels();
  for(int i=0;i<width*height;i++){ // loop through all the pixels
    pixels[i] = img[i]; // draw each pixel to the screen
  }
  updatePixels();
}

void mousePressed(){
  // show pixel's color where the mouse is clicked
  loadPixels();
  int r,g,b;
  int loc = mouseX + mouseY*width;
  r=int(red(pixels[loc]));
  g=int(green(pixels[loc]));
  b=int(blue(pixels[loc]));
  println(red(pixels[loc]) + " " + green(pixels[loc]) + " " + blue(pixels[loc]) );
  m.trackColor(r,g,b,100); // reset tracking color to picked mouse pixel's color
}

void mouseReleased() {
  m.settings(); // click the window to get the settings
}

public void stop(){
  m.stop(); // stop the object
  super.stop();
}