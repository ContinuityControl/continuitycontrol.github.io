/* 
 * Hiyo! Need help? Ask Dan.
 * Is he not around? Try http://processing.org/reference. (Sorry for the RTFM.)
 * Remember: this is a sketch book, a malleable, moldable form,
 * not a rigid, fixed work of engineering. (Mostly.) 
 */

void setup() {
  size(600, 600);
}

void draw() {
  background(255);

  drawGears(width*0.5, height*0.5, 9 /*mouseY*/, 200);

  shapeMode(CENTER);
  PShape logo = loadLogo();
  shape(logo, 226, 226, logo.width, logo.height);
  
  //noLoop();
}

void drawGears(float x, float y, int numTeeth, int radius) {
  color darkBlue = #00263C; // <- the new blue. the old blue: #002545;
  color green = #33cc00; //#4CBD38;
  fill(green);
  noStroke();

  pushMatrix();
  translate(x, y);
  ellipse(0, 0, radius * 2, radius * 2);
  
  float theta = TWO_PI / numTeeth;
  float toothWidth = TWO_PI * radius / numTeeth / 2.0;
  //println("tooth width: " + toothWidth + " (" + (toothWidth * 0.5) + ")");
  
  for (int i = 0; i < numTeeth; i++) {
    /*
    rect(-(toothWidth * 0.5), radius - toothWidth,
         -(toothWidth * 0.5), radius,
          (toothWidth * 0.5), radius,
          (toothWidth * 0.5), radius - toothWidth);*/
    
    //rect(radius - toothWidth * 0.35, -(toothWidth * 0.5), toothWidth, toothWidth);
    
    quad(radius - toothWidth * 0.35, -(toothWidth * 0.6),
         radius + toothWidth * 0.65, -(toothWidth * 0.4),
         radius + toothWidth * 0.65, (toothWidth * 0.4),
         radius - toothWidth * 0.35, (toothWidth * 0.6));

    rotate(theta);
  }
  
  float hue = hue(darkBlue);
  float sat = saturation(darkBlue);
  float brightness = brightness(darkBlue);
  colorMode(HSB);
  fill(hue, sat * 0.75, brightness * 3);
//  fill(25 5);
//  ellipse(0, 0, radius * 2 - toothWidth * 2, radius * 2 - toothWidth * 2);
//  fill(255);
//  ellipse(0, 0, radius * 2 - toothWidth * 5, radius * 2 - toothWidth * 5);
  
  popMatrix();
}

PShape loadLogo() {
//  PShape logo = loadShape("green-nu.svg");
  PShape logo = loadShape("white-nu.svg");
  logo.scale(2.5);
//  logo.translate(-logo.width*0.5, -logo.height*0.5);
//  logo.translate(width/2, height/2); //mouseX-450, mouseY);
  return logo;
}

void keyPressed() {
  println(mouseX + ", " + mouseY);
  save("nu-gears-green-" + mouseY + ".png");
}

void mouseClicked() {
  println(hex(get(mouseX, mouseY)));
}
