class TextBox {

  //position and size
  PVector position, size;
  float scroll;

  //colors
  public color Background = color(140, 140, 140);
  public color Foreground = color(0, 0, 0);
  public color BackgroundSelected = color(160, 160, 160);
  public color Border = color(30, 30, 30);

  //border
  public boolean BorderEnable = false;
  public int BorderWeight = 1;

  //text and textsize
  public int TEXTSIZE = 48;
  public String Text = "";
  public int TextLength = 0;

  //if button is clicked
  private boolean selected = false;

  TextBox() {
  }
  //constructor
  TextBox(PVector position, PVector size) {
    this.position = position;
    this.size = size;
  }

  //display and run textbox
  void display() {
    pushMatrix();
    translate(0, scroll);
    // DRAWING THE BACKGROUND
    if (selected) {
      fill(BackgroundSelected);
    } else {
      fill(Background);
    }

    //  println(Text, protectedText);

    if (BorderEnable) {
      strokeWeight(BorderWeight);
      stroke(Border);
    } else {
      noStroke();
    }

    rectMode(CORNER);

    rect(position.x, position.y, size.x, size.y);

    // DRAWING THE TEXT ITSELF
    fill(Foreground);
    textSize(TEXTSIZE);

    text(Text, position.x + (textWidth("a") / 2), position.y + TEXTSIZE);
  }

  //check if key has been typed
  boolean keyWasTyped(char KEY, int KEYCODE) {

    if (selected) {
      if (KEYCODE == (int)BACKSPACE) {
        backSpace();
      } else if (KEYCODE == 32) { 
        addText(' ');
      } else if (KEYCODE == (int)ENTER) {
        return true;
      } else {
        // CHECK IF THE KEY IS A LETTER OR A NUMBER
        boolean isKeyCapitalLetter = (KEY >= 'A' && KEY <= 'Ø');
        boolean isKeySmallLetter = (KEY >= 'a' && KEY <= 'ø');
        boolean isKeyNumber = (KEY >= '0' && KEY <= '9');
        boolean isKeySign = (KEY >= 30 && KEY <= 200);


        if (isKeyCapitalLetter || isKeySmallLetter || isKeyNumber || isKeySign) {

          addText(KEY);
        }
      }
    }
    return false;
  }

  //add text to textbox
  private void addText(char text) {    
    while (textWidth(Text+text)*TEXTSIZE/48*size.x/400 > size.x-15) {
      TEXTSIZE--;
    }

    if (textWidth(Text+text)*TEXTSIZE/48*size.x/400 < size.x-15) {
      Text += text;
      TextLength++;
    }
  }

  //remove text if backspace is pressed
  private void backSpace() {

    if (TextLength - 1 >= 0) {
      Text = Text.substring(0, TextLength - 1);
      TextLength--;
      if (textWidth(Text)*TEXTSIZE/48*size.x/400 < size.x-15*size.x/400*size.x/400 && TEXTSIZE <= 48) {
        TEXTSIZE++;
      }
    }
  }

  //check if mouse is over box
  private boolean overBox(int x, int y) {
    if (x >= position.x && x <= position.x + size.x) {
      if (y >= position.y + scroll && y <= position.y + size.y + scroll) {
        return true;
      }
    }

    return false;
  }

  //check if mouse has been pressed
  void pressed(int x, int y) {
    if (overBox(x, y)) {
      selected = true;
    } else {
      selected = false;
    }
  }

  //remove all text
  void clearText() {
    TextLength = 0;
    Text = "";
  }
}
