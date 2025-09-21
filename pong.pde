//import processing.sound.*;
//SoundFile walltop,wallbottom,floor,bat;

float ballX;     // Position of text along x-axis
float ballY;     // Position of text along x-axis
float brectX;
float brectY;
float ball_speedX;
float ball_speedY;
float arectX;
float arectY;
Integer tick;
Integer ball_diameter;
Integer rectW;
Integer rectH;
float ball_paddleA_dist_X;
float ball_paddleB_dist_X;
int point = 0;
float paddleA_travel=0;
float paddleB_travel=0;
int tick_batA=-1;
int tick_batB=-1;
float difficulty=0.25; //this is a value from 0 to 1
float lowSpinB = -0.5;
float highSpinB = 1.5;


void keyReleased(){
    
}



void setup()
{
    
    frameRate(60);
    size(640, 480);
    fill(255, 177, 8);
    textSize(48);

    ballX = 500;  // Initialise x coord
    ballY = 300; //Init y coord
    ball_speedX=5;
    ball_speedY=0;
    tick=0;
    ball_diameter=25;
    rectW=10;
    rectH=100;
    arectX=0;
    arectY=100;
    brectX=630;
    brectY=100;
}


void ball() {
    //Initial Checks

    //will run every X wall collision
    if (ballX<0+(ball_diameter/2) || ballX>640-(ball_diameter/2)) { //check for X wall bouncing
        if (ballX<(ball_diameter/2)) {
            ballX=(ball_diameter/2); //prevent clipping from last frame's movement
        } else {
            ballX=640-(ball_diameter/2); //clip prevent for right side
        }

        if (ballX>320) {
            point+=1;
        } else {
            point-=1;
        }

        bounceX(); //call bounce after all amendments
    }
    //will run every Y wall collision
    if (ballY<0+(ball_diameter/2) || ballY>480-(ball_diameter/2)) { //check for Y wall bouncing
        if (ballY<(ball_diameter/2)) {
            ballY=(ball_diameter/2); //prevent clipping from last frame's movement
        } else {
            ballY=480-(ball_diameter/2); //clip prevent for bottom side
        }
        bounceY();
    }


    ball_paddleA_dist_X=dist(arectX+10, 0, ballX, 0);
    if (ball_paddleA_dist_X<=12.5 && ballY+(ball_diameter/2)>arectY && ballY<arectY+100-(ball_diameter/2)) {
        ballX=22.5;//move ball out of racket, so we don't have weird clipping movement
        bounceX();
        ball_speedY+=paddleA_travel;
        if (ball_speedY>6) {
            ball_speedY=6;
        }
        if (ball_speedY<-6) {
            ball_speedY=-6;
        }
    }

    // paddle b code for collision with ball
    ball_paddleB_dist_X=dist(brectX, 0, ballX, 0); // this one doesn't need the brectX+10 as it on the left side measurement
    if (ball_paddleB_dist_X<=12.5 && ballY+(ball_diameter/2)>brectY && ballY<brectY+100-(ball_diameter/2)) {
        ballX=617.5;//move ball out of racket, so we don't have weird clipping movement
        bounceX();
        paddleB_travel+=random(lowSpinB, highSpinB);//this is the spin on the ball
        tick_batB=-1;
        ball_speedY+=paddleB_travel;
        if (ball_speedY>6) {
            ball_speedY=6;
        }
        if (ball_speedY<-6) {
            ball_speedY=-6;
        }
    }



    //after all changes, now move the ball
    ballX+=ball_speedX;
    ballY+=ball_speedY;
}

void bounceX() {
    ball_speedX = -ball_speedX;
}

void bounceY() {
    ball_speedY = -ball_speedY;
}


void keyPressed() {
    if (key=='s' && arectY<380 && keyPressed) {
        arectY+=10;
        tick_batA=tick;
    }
    if (key=='w' && arectY>0 && keyPressed) {
        arectY-=10;
        tick_batA=tick;
    }
    

    if (abs(paddleA_travel)<5) {
        if (key=='w' && arectY>0 && keyPressed) {
            paddleA_travel-=0.5;
        }
        if (key=='s' && arectY<380 && keyPressed) {
            paddleA_travel+=0.5;
        }
    }

    if (!keyPressed && tick==tick_batA) {
        paddleA_travel=0;
        tick_batA=-1;
    }
}

void CPU() {
    //if (tick%15==0){
    //    if (point>10 && tick==0){
    //    difficulty=random(0.5,1);
    //    }
    //    if (point>3 && tick==0){
    //        difficulty=random(0.1,0.5);
    //    }
    //}
    if (brectY<380 && ballY>brectY+50) {
        brectY+=10*difficulty; // multiply by difficulty
        tick_batB=tick;
    }
    if (brectY>0 && ballY<brectY+50) {
        brectY-=10*difficulty; // multiply by difficulty
        tick_batB=tick;
    }
}


void draw()
{
    
    if (tick==15) {
        tick=0;
    }
    if (point < 0 || point > 10) {
      exit();
    }
    background(25);
    text(point, 44, 44);
    circle(ballX, ballY, ball_diameter);
    rect(arectX, arectY, rectW, rectH);
    rect(brectX, brectY, rectW, rectH);
    ball();
    //box1();
    CPU();


    //Code that will run every frame after checks
    keyPressed();
    tick+=1;
}
