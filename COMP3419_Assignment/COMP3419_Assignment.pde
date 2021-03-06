// COMP3419 Assignment
// @Author: Joshua Vernon 

// Java packages
import java.util.*;

// Processing packages
import processing.video.*; 
Movie m;

import processing.sound.*;
SoundFile scream;
SoundFile explosionSound;
SoundFile theme;

// K must be odd
int K = 35;
int radius = 1;
int x_adjust = 180;
int y_adjust = 160;

// Background
PImage background;
PImage cloud_left;
PImage cloud_right;
float cloud_left_x;
float cloud_right_x;

// Goku
PImage left_arm;
PImage right_arm;
PImage left_leg;
PImage right_leg;
PImage body;
PImage energy;
boolean goku_energized;
int goku_left_margin;
int goku_right_margin;

// Allies
PImage chiaotzu;
int[] chiaotzu_coordinates;
PImage puar;
int[] puar_coordinates;

// Mercenary Tao
PImage tao_left;
PImage tao_right;
PImage blast;
PImage explosion;
boolean tao_left_bool = false;
boolean tao_right_bool = false;

// Villains
PImage villain_1;
PImage villain_2;
PImage villain_3;
PImage villain_4;
PImage villain_5;
PImage villain_6;
boolean[] villains;
int[][] villain_coordinates;

PImage current_frame;

int phase = 2;
int framenumber = 0;
int m_frames = 0;

public class Score<S, X, Y> { 
  public final S s;
  public final X x; 
  public final Y y; 
  public Score(S s, X x, Y y) { 
    this.s = s;
    this.x = x; 
    this.y = y;
  }
  
  public int compareTo(Score score) {
    return (int) this.s - (int) score.s;
  }
}

ArrayList<Score<Integer, Integer, Integer>> curr_top_block_scores = new ArrayList<Score<Integer, Integer, Integer>>(5);

ArrayList<Score<Integer, Integer, Integer>> curr_arms = new ArrayList<Score<Integer, Integer, Integer>>(2);
ArrayList<Score<Integer, Integer, Integer>> curr_legs = new ArrayList<Score<Integer, Integer, Integer>>(2);
Score<Integer, Integer, Integer> curr_body = null;

ArrayList<int[]> blasts = new ArrayList<int[]>();
ArrayList<int[]> explosions = new ArrayList<int[]>();

void setup() { 
  // Just large enough to see what is happening
  size(1024, 576);
  
  // Background
  background = loadImage("./img/background.png");
  cloud_left = loadImage("./img/cloud-left.png");
  cloud_right = loadImage("./img/cloud-right.png");
  cloud_left_x = 0;
  cloud_right_x = width;
  
  // Theme
  theme = new SoundFile(this, sketchPath("./sounds/theme.mp3"));
  theme.play();

  // Goku
  left_arm = loadImage("./img/left-arm.png");
  right_arm = loadImage("./img/right-arm.png");
  left_leg = loadImage("./img/left-leg.png");
  right_leg = loadImage("./img/right-leg.png");
  body = loadImage("./img/body.png");
  energy = loadImage("./img/energy.png");
  scream = new SoundFile(this, sketchPath("./sounds/scream.wav"));
  scream.amp(0.4);
  
  // Allies
  chiaotzu = loadImage("./img/chiaotzu.png");
  puar = loadImage("./img/puar.png");
  chiaotzu_coordinates = new int[] {100, 80};
  puar_coordinates = new int[] {700, 200};
  
  // Mercenary Tao
  tao_left = loadImage("./img/tao-left.png");
  tao_right = loadImage("./img/tao-right.png");
  blast = loadImage("./img/blast.png");
  explosion = loadImage("./img/explosion.png");
  explosionSound = new SoundFile(this, sketchPath("./sounds/explosion.wav"));
  
  // Villains
  villain_1 = loadImage("./img/villain-1.png");
  villain_2 = loadImage("./img/villain-2.png");
  villain_3 = loadImage("./img/villain-3.png");
  villain_4 = loadImage("./img/villain-4.png");
  villain_5 = loadImage("./img/villain-5.png");
  villain_6 = loadImage("./img/villain-6.png");
  villains = new boolean[] {false, false, false, false, false, false};
  villain_coordinates = new int[6][2];

  // Fill colour
  fill(161, 233, 91);
  stroke(161, 233, 91);
  // Create a Movie object. 
  m = new Movie(this, sketchPath("../videos/monkey.mov")); 
  // slow down framerate
  m.frameRate(30);
  // Play the movie one time, no looping
  m.play();
} 


void drawBackground() {
  image(background, 0, 0, 1024, 576);
  cloud_left_x += 1.5;
  cloud_right_x -= 1.5;
  for (int i = 0; i < 2; i++) {
    image(cloud_left, cloud_left_x + (i * 400) - 600, 40 + (i * 180), cloud_left.width / 2, cloud_left.height / 2);
    image(cloud_right, cloud_right_x + (i * 400), 120 + (i * 180), cloud_right.width * 0.7, cloud_right.height * 0.7);
  }
}


boolean pixel_within_range(color px) {
  if (red(px) > 180 && green(px) < 140) {
    return true;
  }
  return false;
}


boolean pixel_is_white(color px) {
  if (red(px) == 255 && green(px) == 255 && blue(px) == 255) {
    return true;
  }
  return false;
}


int block_score(color[] block) {
  int score = 0;
  for (color px : block) {
    if (pixel_is_white(px)) {
      score++;
    }
  }
  return score;
}

void binariseImage() {
  loadPixels();
  for (int i = 0; i < current_frame.width * current_frame.height; i++) {
    if (pixel_within_range(current_frame.pixels[i])) {
      current_frame.pixels[i] = color(255, 255, 255);
    } else {
      current_frame.pixels[i] = color(0, 0, 0);
    }
  }
  updatePixels();
}
      

void draw() {
  float time = m.time();
  float duration = m.duration();
  
  //// Handle phase events
  //if (phase == 1 && time >= duration) {
  //  m.jump(0);
  //  phase = 2;
  //  m_frames = framenumber - 1;
  //  framenumber = 0;
  //} else if (phase == 2 && framenumber >= m_frames) {
  //  exit();
  //}
  
  if (m.available()) {
    if (phase == 1) {
      m.read();
      m.save(sketchPath("") + "BG/" + nf(framenumber, 4) + ".tif");
      image(m, 0, 0);
      textSize(20);
      text(String.format("Phase %d: %.2f%%", phase, 100 * time / duration), 50, 50);
    } else {
      current_frame = loadImage(sketchPath("") + "BG/"+nf(framenumber, 4) + ".tif");
      
      binariseImage();
      
      drawBackground();
      
      ArrayList<Score<Integer, Integer, Integer>> block_scores = new ArrayList<Score<Integer, Integer, Integer>>();
      
      // Loop through current_frame
      for (int fx = 0; fx < current_frame.width; fx += K) {
        for (int fy = 0; fy < current_frame.height; fy += K) {
          
          //// Get the colours in the current block
          color[] b_current = get_block(current_frame, fx, fy);
          
          //// Store the score, x-coordinate and y-coordinate
          block_scores.add(new Score<Integer, Integer, Integer>(block_score(b_current), fx, fy));
          
        }
      } // End loop through current_frame
        
      // Loop through the block scores
      Collections.sort(block_scores, new Comparator<Score>() {
        @Override
        public int compare(Score score2, Score score1) {
          return score1.compareTo(score2);
        }
      });
      
      curr_top_block_scores.clear();
      for (int i = 0; i < 5; i++) {
        curr_top_block_scores.add(block_scores.get(i));
      }
      
      // find arms
      curr_arms.clear();
      curr_arms.add(curr_top_block_scores.get(0));
      curr_arms.add(curr_top_block_scores.get(1));
      int[] arms_indexes = new int[2];
      arms_indexes[0] = 0;
      arms_indexes[1] = 1;
      for (int i = 2; i < 5; i++) {
        if (curr_top_block_scores.get(i).y < curr_arms.get(0).y || curr_top_block_scores.get(i).y < curr_arms.get(1).y) {
          if (curr_arms.get(0).y > curr_arms.get(1).y) {
            curr_arms.set(0, curr_top_block_scores.get(i));
            arms_indexes[0] = i;
          } else {
            curr_arms.set(1, curr_top_block_scores.get(i));
            arms_indexes[1] = i;
          }
        }
      }
      if (arms_indexes[0] > arms_indexes[1]) {
        curr_top_block_scores.remove(arms_indexes[0]);
        curr_top_block_scores.remove(arms_indexes[1]);
      } else {
        curr_top_block_scores.remove(arms_indexes[1]);
        curr_top_block_scores.remove(arms_indexes[0]);
      }
      
      // find legs
      curr_legs.clear();
      curr_legs.add(curr_top_block_scores.get(0));
      curr_legs.add(curr_top_block_scores.get(1));
      int[] legs_indexes = new int[2];
      legs_indexes[0] = 0;
      legs_indexes[1] = 1;
      for (int i = 2; i < 3; i++) {
        if (curr_top_block_scores.get(i).y > curr_legs.get(0).y || curr_top_block_scores.get(i).y > curr_legs.get(1).y) {
          if (curr_legs.get(0).y < curr_legs.get(1).y) {
            curr_legs.set(0, curr_top_block_scores.get(i));
            legs_indexes[0] = i;
          } else {
            curr_legs.set(1, curr_top_block_scores.get(i));
            legs_indexes[1] = i;
          }
        }
      }
      if (legs_indexes[0] > legs_indexes[1]) {
        curr_top_block_scores.remove(legs_indexes[0]);
        curr_top_block_scores.remove(legs_indexes[1]);
      } else {
        curr_top_block_scores.remove(legs_indexes[1]);
        curr_top_block_scores.remove(legs_indexes[0]);
      }
      
      drawAllies();
      checkAllyCollision();
      drawTao();
      drawGoku();
      drawBlasts();
      drawExplosions();
      
      m.read();
    }
    
    framenumber++;
    
  }
}


void drawGoku() {  
  //delay(10);
  // draw legs
  if (curr_legs.get(0).x < curr_legs.get(1).x) {
    image(left_leg, ((int)curr_legs.get(0).x + x_adjust + (int)curr_top_block_scores.get(0).x + 50 + x_adjust) / 2, (int)curr_legs.get(0).y + y_adjust, left_leg.width * 0.5, left_leg.height * 0.5);
    image(right_leg, (((int)curr_legs.get(1).x + x_adjust + (int)curr_top_block_scores.get(0).x + x_adjust) / 2) + 100, (int)curr_legs.get(1).y + y_adjust, right_leg.width * 0.5, right_leg.height * 0.5);
  } else {
    image(left_leg, ((int)curr_legs.get(1).x + x_adjust + (int)curr_top_block_scores.get(0).x + 50 + x_adjust) / 2, (int)curr_legs.get(1).y + y_adjust, left_leg.width * 0.5, left_leg.height * 0.5);
    image(right_leg, (((int)curr_legs.get(0).x + x_adjust + (int)curr_top_block_scores.get(0).x + x_adjust) / 2) + 100, (int)curr_legs.get(0).y + y_adjust, right_leg.width * 0.5, right_leg.height * 0.5);
  }
  
  // Draw arms
  if (curr_arms.get(0).x < curr_arms.get(1).x) {
    goku_left_margin = ((int)curr_arms.get(0).x + x_adjust + (int)curr_top_block_scores.get(0).x + 80 + x_adjust) / 2;
    goku_right_margin = (((int)curr_arms.get(1).x + x_adjust + (int)curr_top_block_scores.get(0).x + 40 + x_adjust) / 2) + 100;
    image(left_arm, goku_left_margin, (int)curr_arms.get(0).y + (left_arm.height * 0.6) + y_adjust, left_arm.width * 0.5, left_arm.height * 0.5);
    image(right_arm, goku_right_margin, (int)curr_arms.get(1).y + (right_arm.height * 0.6) + y_adjust, right_arm.width * 0.5, right_arm.height * 0.5);
  } else {
    goku_left_margin = ((int)curr_arms.get(1).x + x_adjust + (int)curr_top_block_scores.get(0).x + 80 + x_adjust) / 2;
    goku_right_margin = (((int)curr_arms.get(0).x + x_adjust + (int)curr_top_block_scores.get(0).x + 40 + x_adjust) / 2) + 100;
    image(left_arm, goku_left_margin, (int)curr_arms.get(1).y + (left_arm.height * 0.6) + y_adjust, left_arm.width * 0.5, left_arm.height * 0.5);
    image(right_arm, goku_right_margin, (int)curr_arms.get(0).y + (right_arm.height * 0.6) + y_adjust, right_arm.width * 0.5, right_arm.height * 0.5);
  }
  
  if (goku_energized) {
    image(energy, goku_left_margin - 110, (int)curr_top_block_scores.get(0).y - (body.height * 0.25) + y_adjust, energy.width, energy.height);
  }
  // draw body
  image(body, (int)curr_top_block_scores.get(0).x + x_adjust, (int)curr_top_block_scores.get(0).y - (body.height * 0.25) + y_adjust, body.width * 0.5, body.height * 0.5);
}


void drawGrid() {
  noFill();
  stroke(255, 255, 255);
  pushMatrix();
  for (int r = 0; r < 100; r++) {
    for (int c = 0; c < 100; c++) {
      
      rect(r*K, c*K, K, K); // draw it!
    }
  }
  popMatrix();
  fill(161, 233, 91);
  stroke(161, 233, 91);
}


// Loop through block and return an array of the pixel's colors
color[] get_block(PImage frame, int x, int y) {
  color[] block = new color[K * K];
  
  // Loop through block
  int idx = 0;
  for (int bx = x; bx < x + K; bx++) {
    for (int by = y; by < y + K; by++) {
      // Find the colour of the pixel, store it in the array index
      int loc = loc(bx, by);
      if (loc >= 0) {
        // Location is valid
        color c = frame.pixels[loc];
        block[idx] = c;
      }
      idx++;
    }
  } // End loop through block
  
  return block;
}


// Called every time a new frame is available to read 
void movieEvent(Movie m) {
  // Pass
}


// Check if coordinate is valid and if it is return it, else return -1
int loc(int x, int y) {
  if (x >= 0 && x < current_frame.width && y >= 0 && y < current_frame.height) {
    // Valid coordinate
    return x + (y * current_frame.width);
  } else {
    return -1;
  }
}


// Draw a dot in the middle of the block
void drawDot(int x, int y, int n) {
  color[] colors = new color[5];
  colors[0] = color(221, 35, 29); // red
  colors[1] = color(67, 175, 248); // blue
  colors[2] = color(67, 148, 70); // green
  colors[3] = color(255, 217, 84); // yellow
  colors[4] = color(227, 33, 111); // pink
  int loc = loc(x, y);
  if (loc >= 0) {
    fill(colors[n]);
    stroke(colors[n]);
    ellipse(x, y, K, K);
    stroke(161, 233, 91);
    fill(161, 233, 91);
  }
}


void drawExplosions() {
  ArrayList<Integer> blast_indexes_to_remove = new ArrayList<Integer>();
  for (int i = 0; i < blasts.size(); i++) {
    // update blasts coordinates
    blasts.get(i)[0] += blasts.get(i)[2];
    // check if blast has hit goku
    if (blasts.get(i)[0] > goku_left_margin && blasts.get(i)[0] < goku_right_margin) {
      blast_indexes_to_remove.add(i);
      // play explosion sound
      explosionSound.play();
      int[] newExplosion = new int[] {blasts.get(i)[0], 10};
      explosions.add(newExplosion);
    }
  }
  ArrayList<Integer> explosion_indexes_to_remove = new ArrayList<Integer>();
  for (int i = 0; i < explosions.size(); i++) {
    // display explosion image
    image(explosion, explosions.get(i)[0], 400, explosion.width / 2, explosion.height / 2);
    explosions.get(i)[1] -= 1;
    if (explosions.get(i)[1] == 0) {
      explosion_indexes_to_remove.add(i);
    }
  }
  for (int i = 0; i < blast_indexes_to_remove.size(); i++) {
    blasts.remove(int(blast_indexes_to_remove.get(i)));
  }
  for (int i = 0; i < explosion_indexes_to_remove.size(); i++) {
    explosions.remove(int(explosion_indexes_to_remove.get(i)));
  }
}


void drawBlasts() {
  for (int i = 0; i < blasts.size(); i++) {
    // draw blast
    image(blast, blasts.get(i)[0], blasts.get(i)[1], blast.width * 0.4, blast.height * 0.4);
    // update blasts coordinates
    blasts.get(i)[0] += blasts.get(i)[2];
  }
}


void tao_shoot() {
  int[] blast = new int[3];
  if (tao_left_bool) {
    blast[0] = 30 + int(tao_left.width * 0.8);
    blast[2] = int(random(3, 10));
  } else {
    blast[0] = 680;
    blast[2] = int(random(-10, -3));
  }
  blast[1] = 400;
  
  blasts.add(blast);
}


void drawTao() {
  if (tao_left_bool) {
    image(tao_left, 30, 320, tao_left.width * 0.8, tao_left.height * 0.8);
  } else if (tao_right_bool) {
    image(tao_right, 680, 320, tao_right.width * 0.8, tao_right.height * 0.8);
  }
}


void drawAllies() {
  chiaotzu_coordinates[0] = (int)((chiaotzu_coordinates[0] + random(-7, 12)) % width);
  if (puar_coordinates[0] <= 0) {
    puar_coordinates[0] = width;
  }
  puar_coordinates[0] = (int)((puar_coordinates[0] + random(-12, 7)) % width);
  image(chiaotzu, chiaotzu_coordinates[0], chiaotzu_coordinates[1], chiaotzu.width, chiaotzu.height);
  image(puar, puar_coordinates[0], puar_coordinates[1], puar.width / 7, puar.height / 7);
}


void checkAllyCollision() {
  boolean just_energized = false;
  if ((chiaotzu_coordinates[0] > goku_left_margin && chiaotzu_coordinates[0] < goku_right_margin) || (puar_coordinates[0] > goku_left_margin && puar_coordinates[0] < goku_right_margin)) {
    if (!goku_energized) {
      just_energized = true;
    }
    goku_energized = true;
  } else {
    goku_energized = false;
  }
  if (just_energized) {
    scream.play();
  }
}


void drawVillains() {
  if (villains[0] == true) {
    image(villain_1, 0, 0, villain_1.width, villain_1.height);
  }
  if (villains[1] == true) {
    image(villain_2, 0, 0, villain_2.width, villain_2.height);
  }
  if (villains[2] == true) {
    image(villain_3, 0, 0, villain_3.width, villain_3.height);
  }
  if (villains[3] == true) {
    image(villain_4, 0, 0, villain_4.width, villain_4.height);
  }
  if (villains[4] == true) {
    image(villain_5, 0, 0, villain_5.width, villain_5.height);
  }
  if (villains[5] == true) {
    image(villain_6, 0, 0, villain_6.width, villain_6.height);
  }
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      if (tao_left_bool) {
        tao_right_bool = false;
        tao_left_bool = false;
      } else {
        tao_left_bool = true;
        tao_right_bool = false;
      }
    } else if (keyCode == RIGHT) {
      if (tao_right_bool) {
        tao_right_bool = false;
        tao_left_bool = false;
      } else {
        tao_right_bool = true;
        tao_left_bool = false;
      }
    } else if (keyCode == SHIFT) {
      if (tao_left_bool || tao_right_bool) {
        tao_shoot();
      }
    }
  }
}