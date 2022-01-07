class Button {

  //buttons position and size
  float scroll;
  PVector pos;
  PVector size;

  //colors
  color col, overCol, pressedCol;

  //radius of circles
  float radius;

  //boxes positions and size
  PVector box1size, box1pos, box2size, box2pos;
  PVector circle1pos, circle2pos, circle3pos, circle4pos;

  //if button is clicked
  boolean clicked;

  //text and textsize
  String Text;
  float textSize;

  //Constructor
  Button(PVector p, PVector s, float r, color col, color ocol, color pcol, String Text, float textSize) {

    this.pos = p;
    this.size = s;
    this.radius = r;
    this.col = col;
    this.overCol = ocol;
    this.pressedCol = pcol;
    this.Text = Text;
    this.textSize = textSize;


    box1pos = new PVector(pos.x, pos.y-radius/2);
    box2pos = new PVector(pos.x-radius/2, pos.y);

    box1size = new PVector(size.x, size.y+radius);
    box2size = new PVector(size.x+radius, size.y);

    circle1pos = new PVector(pos.x, pos.y);
    circle2pos = new PVector(pos.x+size.x, pos.y);
    circle3pos = new PVector(pos.x+size.x, pos.y+size.y);
    circle4pos = new PVector(pos.x, pos.y+size.y);
  }

  //check if mouse is over button
  boolean over() {
    if ((mouseX <= box1pos.x+box1size.x && mouseX >= box1pos.x && mouseY <= box1pos.y+box1size.y+scroll && mouseY >= box1pos.y+scroll) ||
      (mouseX <= box2pos.x+box2size.x && mouseX >= box2pos.x && mouseY <= box2pos.y+box2size.y+scroll && mouseY >= box2pos.y+scroll) ||
      (dist(mouseX, mouseY-scroll, circle1pos.x, circle1pos.y)<radius/2) ||
      (dist(mouseX, mouseY-scroll, circle2pos.x, circle2pos.y)<radius/2) ||
      (dist(mouseX, mouseY-scroll, circle3pos.x, circle3pos.y)<radius/2) ||
      (dist(mouseX, mouseY-scroll, circle4pos.x, circle4pos.y)<radius/2)) {
      return true;
    } else {
      return false;
    }
  }

  //check if mouse was pressed
  void pressed() {
    if (over()) {
      clicked = true;
    }
  }
  
  void released(){
    clicked = false;
  }

  //draw and run the button
  void display() {   

      noStroke();

      if (clicked) {
        fill(pressedCol);
        clicked=false;
      } else if (over()) {
        fill(overCol);
      } else {
        fill(col);
      }

      //rectangles
      rect(box1pos.x, box1pos.y, box1size.x, box1size.y);
      rect(box2pos.x, box2pos.y, box2size.x, box2size.y);

      //rounded corners
      circle(circle1pos.x, circle1pos.y, radius);
      circle(circle2pos.x, circle2pos.y, radius);
      circle(circle3pos.x, circle3pos.y, radius);
      circle(circle4pos.x, circle4pos.y, radius);

      textAlign(CENTER);
      fill(0, 0, 0);
      textSize(textSize);
      text(Text, pos.x+size.x/2, pos.y+2*textSize/3);
      textAlign(CORNER);
  }
}
