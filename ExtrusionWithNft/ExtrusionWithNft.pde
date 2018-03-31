/**
 * NyARToolkit for proce55ing/3.0.5
 * (c)2008-2017 nyatla
 * airmail(at)ebony.plala.or.jp
 * 
 * 最も短いARToolKitのコードです。
 * Hiroマーカの上に立方体を表示します。
 * 全ての設定ファイルとマーカファイルはスケッチディレクトリのlibraries/nyar4psg/dataにあります。
 * 
 * This sketch is shortest sample.
 * The sketch shows cube on the marker of "patt.hiro".
 * Any pattern and configuration files are found in libraries/nyar4psg/data inside your sketchbook folder. 
*/
import processing.video.*;
import jp.nyatla.nyar4psg.*;

Capture cam;
MultiNft nya;

PImage[] a = new PImage[12];
boolean onetime = true;
int[][][] aPixels;
int[][][] values;
float angle;

void setup() {
  size(1201,901,P3D);
  colorMode(RGB, 100);
  println(MultiMarker.VERSION);
  
  cam=new Capture(this,640,480);
  nya=new MultiNft(this,640,480,"camera_para5.dat",NyAR4PsgConfig.CONFIG_PSG);
  
  for(int i=0 ; i<12; i++){
    String mark = "mark" + (i+1);
    println(mark);
    nya.addNftTarget(mark,100);//id=0~11
  }
  
  aPixels = new int[12][500][500];
  values = new int[12][500][500];
  noFill();
  angle=0;

  // Load the image into a new array
  // Extract the values and store in an array
  for(int k=0; k<12; k++){
    String imgName = "image" + (k+1) +".jpg";
    a[k] = loadImage(imgName);
    a[k].loadPixels();
    for (int i = 0; i < a[k].height; i++) {
      for (int j = 0; j < a[k].width; j++) {
        aPixels[k][j][i] = a[k].pixels[i*a[k].width + j];
        values[k][j][i] = int(blue(aPixels[k][j][i]))/2;
      }
    }
  }
  
  cam.start();
}

void draw()
{
  if (cam.available() !=true) {
      return;
  }
  cam.read();
  nya.detect(cam);
  nya.drawBackground(cam);//frustumを考慮した背景描画
  for(int k=0;k<12;k++){
    if((!nya.isExist(k))){
      continue;
    }
    nya.beginTransform(k);
    translate(-50,50,20);
    scale(0.3);
    angle += 0.08;
    rotateZ(angle);
    for (int i = 0; i < a[k].height; i += 2) {
      for (int j = 0; j < a[k].width; j += 2) {
        stroke(blue(aPixels[k][j][i])/2);
        strokeWeight(8);
        if(blue(aPixels[k][j][i])<100)
        {
          line(j-a[k].width/2, i-a[k].height/2, -values[k][j][i],j-a[k].width/2, i-a[k].height/2, -values[k][j][i]-2);
        }
      }
    }
    nya.endTransform();
  }
}