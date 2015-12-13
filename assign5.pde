PImage bg1Img,bg2Img;
PImage enemyImg,treasureImg,fighterImg,hpImg;
PImage start1Img,start2Img;
PImage end1Img,end2Img;
PImage shootImg;

float bgX=0;
float hpX=38.8;    //10hp=19.4, 20hp=38.8, 100hp=194
float fighterX=589, fighterY=240;
float treasureX=random(45,585),treasureY=random(45,405); 
float enemyX=0, enemyY=random(0,420);
final float spacingX=70, spacingY=40;
int shootNbr=0;
float recieve;

float [] enemyXArray = new float [8];
float [] enemyYArray = new float [8];

boolean [] enemy1Detect = new boolean [5];
boolean [] enemy2Detect = new boolean [5];
boolean [] enemy3Detect = new boolean [8];

boolean [] animation1 = new boolean [5];
boolean [] animation2 = new boolean [5];
boolean [] animation3 = new boolean [8];

boolean [] shootingDetect = new boolean [5];

float [] shootX = new float [5];
float [] shootY = new float [5];

int [] current1Frame = new int [5];
int [] current2Frame = new int [5];
int [] current3Frame = new int [8];

PImage [] images = new PImage[5];  //explode animation

boolean upPressed=false,downPressed=false,rightPressed=false,leftPressed=false, spacePressed=false;

final int GAME_START=0, GAME_RUN_LINE=1, GAME_RUN_SLASH=2, GAME_RUN_DIAMOND=3, GAME_OVER=4;
int gameState;

PFont board;
int scoreNbr=0;

void setup(){
  size(640,480);
  
  bg1Img=loadImage("img/bg1.png");
  bg2Img=loadImage("img/bg2.png");
  enemyImg=loadImage("img/enemy.png");
  treasureImg=loadImage("img/treasure.png");
  fighterImg=loadImage("img/fighter.png");
  hpImg=loadImage("img/hp.png");
  start1Img=loadImage("img/start1.png");
  start2Img=loadImage("img/start2.png");
  end1Img=loadImage("img/end1.png");
  end2Img=loadImage("img/end2.png");
  shootImg=loadImage("img/shoot.png");   //31*27
  
  for (int i=0; i<5; i++){
    images[i] = loadImage("img/flame"+(i+1)+".png");
    shootingDetect[i] = false;
  }
  
  board=createFont("Arial", 30);
  textFont(board,30);
  textAlign(LEFT); 

}

//score board
void scoreChange(int value){
  scoreNbr+=value;
}

//hit detect
boolean isHit(float ax,float ay,float aw,float ah,float bx,float by,float bw,float bh){
  if(ax>bx-aw && ax<bx+bw && ay>by-ah && ay<by+bh){
    return true;
  }
  return false;
}

void shootBoolean(){
  for(int i=0; i<5; i++){
    shootingDetect[i] = false;
  }  

}

void draw(){
   //background
   image(bg1Img,bgX,0);
   image(bg2Img,bgX-640,0);
   image(bg1Img,bgX-1280,0);
   bgX++;
   bgX%=1280;
   
   //hp
   noStroke();
   fill(255,0,0);
   rect(22,14,hpX,16);
   image(hpImg,10,10);
   
   //treasure 41*41
   image(treasureImg,treasureX,treasureY);
  
   //fighter moving
   if(upPressed){
     fighterY-=5;
   }if(fighterY<0){
      fighterY=0;
    }
   if(downPressed){
     fighterY+=5;
   }if(fighterY>height-51){
     fighterY=height-51;
    }
   if(rightPressed){
     fighterX+=5;
   }if(fighterX>width-51){
     fighterX=width-51;
    }
   if(leftPressed){
     fighterX-=5;
   }if(fighterX<0){
      fighterX=0;
   }
   image(fighterImg,fighterX,fighterY);


   //eating treasure
   if(isHit(fighterX,fighterY,fighterImg.width,fighterImg.height,treasureX,treasureY,treasureImg.width,treasureImg.height)==true){
     hpX+=19.4;
     treasureX=random(45,585);
     treasureY=random(45,405);  
   }
   
   //shooting
   for(int i=0; i<5; i++){
     if(shootingDetect[i] == true){
       image(shootImg, shootX[i], shootY[i]);
       shootX[i]-=3;
     }
     if(shootX[i]<0){
       shootingDetect[i] = false;   
     }
   }
   
   fill(255);
   text("score:"+scoreNbr,10,470);
 
   switch(gameState){
     
     case GAME_START:
     image(start2Img,0,0);
     if(mouseX>=210 && mouseX<=440 && mouseY>=380 && mouseY<=410){
       image(start1Img,0,0);
       if(mousePressed){      
         gameState=GAME_RUN_LINE;      
       }
     }
     break;
     
     case GAME_RUN_LINE:
     
     enemyX+=3;    

     for(int i=0; i<5; i++){
       if(enemy1Detect[i]==false){
         
         enemyXArray[i]=enemyX-i*spacingX;
         enemyYArray[i]=enemyY;
         
         if(isHit(fighterX,fighterY,fighterImg.width,fighterImg.height,enemyXArray[i],enemyYArray[i],enemyImg.width,enemyImg.height)==true){
           hpX-=38.8;
           enemy1Detect[i]=true;
           animation1[i]=true;         
         }
    
         for(int j=0; j<5; j++){
           if(isHit(shootX[j],shootY[j],shootImg.width,shootImg.height,enemyXArray[i],enemyYArray[i],enemyImg.width,enemyImg.height)==true){
             enemy1Detect[i]=true;
             animation1[i] = true;
             shootY[i]=2000;
             scoreChange(20);            
           }
         }  
       }

       
       if(animation1[i]==true){
         
         if(frameCount % floor((60/10)) == 0){
           current1Frame[i]++;
         }
         if(current1Frame[i]<5){
           image(images[current1Frame[i]],enemyX-i*spacingX,enemyY);
         }
       }

       if(enemy1Detect[i]==true){
         enemyXArray[i]=-100;
       }

       image(enemyImg,enemyXArray[i],enemyYArray[i]);
     } 
     
     if (enemyX-4*spacingX > width){
       gameState=GAME_RUN_SLASH;
       enemyX=0;
       enemyY=random(0,255);
       shootBoolean();
     }     
     
     break;
     
     case GAME_RUN_SLASH:

     enemyX+=3;
    
     for(int i=0; i<5; i++){

       if(enemy2Detect[i]==false){
         
         enemyXArray[i]=enemyX-i*spacingX;
         enemyYArray[i]=enemyY+i*spacingY;
         
         if(isHit(fighterX,fighterY,fighterImg.width,fighterImg.height,enemyXArray[i],enemyYArray[i],enemyImg.width,enemyImg.height)==true){
           hpX-=38.8;
           enemy2Detect[i]=true;
           animation2[i]=true;         
         }
         
         for(int j=0; j<5; j++){
           if(isHit(shootX[j],shootY[j],shootImg.width,shootImg.height,enemyXArray[i],enemyYArray[i],enemyImg.width,enemyImg.height)==true){
             enemy2Detect[i]=true;
             animation2[i] = true;
             shootY[i]=2000;
             scoreChange(20);            
           }
         }         
       }
    

       if(animation2[i]==true){
           
         if(frameCount % floor((60/10)) == 0){
           current2Frame[i]++;
         }
         if(current2Frame[i]<5){
           image(images[current2Frame[i]],enemyX-i*spacingX,enemyY+i*spacingY);
         }
       }

       if(enemy2Detect[i]==true){
         enemyXArray[i]=-100;
       }

       image(enemyImg,enemyXArray[i],enemyYArray[i]);
     } 
    
     if (enemyX-4*spacingX > width){
       gameState = GAME_RUN_DIAMOND;
       enemyX=0;
       enemyY=random(80,335); 
       shootBoolean();
     }


     break;
     
     case GAME_RUN_DIAMOND:
     
     enemyX+=3;
    
     for(int i=0; i<8; i++){

       if(enemy3Detect[i]==false){

         if(i>4){
           enemyXArray[i]=enemyX-(i-4)*spacingX;
           enemyYArray[i]=enemyY+(2-abs(i-6))*spacingY;
         }else{
            enemyXArray[i]=enemyX-i*spacingX;
            enemyYArray[i]=enemyY-(2-abs(i-2))*spacingY;
          }
          
         if(isHit(fighterX,fighterY,fighterImg.width,fighterImg.height,enemyXArray[i],enemyYArray[i],enemyImg.width,enemyImg.height)==true){
           hpX-=38.8;
           enemy3Detect[i]=true;
           animation3[i]=true;         
         } 
         
         for(int j=0; j<5; j++){
           if(isHit(shootX[j],shootY[j],shootImg.width,shootImg.height,enemyXArray[i],enemyYArray[i],enemyImg.width,enemyImg.height)==true){
             enemy3Detect[i]=true;
             animation3[i] = true;
             shootY[j]=2000;
             scoreChange(20);            
           }
         }    
       }  
    
       
       if(animation3[i]==true){
         
         if(frameCount % floor((60/10)) == 0){
           current3Frame[i]++;
         }
         if(current3Frame[i]<5){
           if(i>4){
             image(images[current3Frame[i]],enemyX-(i-4)*spacingX,enemyY+(2-abs(i-6))*spacingY);
           }else{
              image(images[current3Frame[i]],enemyX-i*spacingX,enemyY-(2-abs(i-2))*spacingY);
            }
         }
       }

       if(enemy3Detect[i]==true){
         enemyXArray[i]=-100;
       }

       image(enemyImg,enemyXArray[i],enemyYArray[i]);
     } 
     
     if (enemyX-4*spacingX > width){
       gameState = GAME_RUN_LINE;
       enemyX=0;
       enemyY=random(0,420);
       enemyXArray = new float [8];
       enemyYArray = new float [8];        
       enemy1Detect = new boolean [5];
       enemy2Detect = new boolean [5];
       enemy3Detect = new boolean [8];
       animation1 = new boolean [5];
       animation2 = new boolean [5];
       animation3 = new boolean [8];
       current1Frame = new int [5];
       current2Frame = new int [5];
       current3Frame = new int [8];
       shootingDetect = new boolean [5];
       shootNbr=0;
       shootX = new float [5];
       shootY = new float [5];
       shootBoolean();

     }     

     break;
     
     case GAME_OVER:
       image(end2Img,0,0);
         if(mouseX>=210 && mouseX<=425 && mouseY>=310 && mouseY<=345){
           image(end1Img,0,0);
           if(mousePressed){             //click
           gameState=GAME_RUN_LINE;      //change case
  
            bgX=0;
            hpX=38.8;
            fighterX=589;
            fighterY=240;
            treasureX=random(45,585);
            treasureY=random(45,405); 
            enemyX=0;
            enemyY=random(0,420);
            enemyXArray = new float [8];
            enemyYArray = new float [8]; 
            enemy1Detect = new boolean [5];
            enemy2Detect = new boolean [5];
            enemy3Detect = new boolean [8];         
            animation1 = new boolean [5];
            animation2 = new boolean [5];
            animation3 = new boolean [8];           
            current1Frame = new int [5];
            current2Frame = new int [5];
            current3Frame = new int [8];
            shootX = new float [5];
            shootY = new float [5]; 
            scoreNbr=0;
            shootBoolean();
           } 
         }
       break;
   }
   
   //hp range
   if (hpX>=194){
     hpX=194;
   }else if(hpX<1){
     gameState=GAME_OVER;  
    }
      
}

void keyPressed(){
  if(key==CODED){
    switch(keyCode){
      case UP:
        upPressed=true;
        break;
      case DOWN:
        downPressed=true;
        break;
      case RIGHT:
        rightPressed=true;
        break;
      case LEFT:
        leftPressed=true;
        break;
    }
  }
}

void keyReleased(){
  if(key==CODED){
   switch(keyCode){  
     case UP:
       upPressed=false;
       break;
     case DOWN:
       downPressed=false;
       break;
     case RIGHT:
       rightPressed=false;
       break;
     case LEFT:
       leftPressed=false;
       break;   
    }
  }
  
  if ( keyCode == ' '){
    if(gameState != GAME_START && gameState != GAME_OVER)
      if(shootingDetect[shootNbr] == false){
        shootingDetect[shootNbr]=true;
        shootX[shootNbr]=fighterX;
        shootY[shootNbr]=fighterY;
        shootNbr++; 
      }   
      if(shootNbr>4){
        shootNbr=0;
      }
      
    }

}
