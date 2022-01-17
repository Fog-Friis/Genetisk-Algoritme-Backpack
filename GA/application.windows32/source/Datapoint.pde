class Datapoint{
  int x,y;
  Datapoint(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  void display(){
    circle(x,y,3);
  }
}
