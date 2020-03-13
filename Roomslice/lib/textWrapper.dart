import 'package:flutter/material.dart';
class TextWrapper {

String data;
Locale locale;
int maxLines;
TextOverflow overflow;
String semanticsLabel;
bool softWrap;
StrutStyle strutStyle;
TextStyle style;
TextAlign textAlign;
TextDirection textDirection;
double textScaleFactor;
InlineSpan textSpan;
TextWidthBasis textWidthBasis;




  TextWrapper( BuildContext context){
   data = null;
   locale = null;
   maxLines = null;
   overflow = null;
   semanticsLabel = null;
   softWrap = null;
   strutStyle = null;
   style = null;
   textAlign = null;
   textDirection = null;
   textScaleFactor = null;
   textSpan = null;
   textWidthBasis = null;



  }

  String getData(){
    return data;
  }
  void setData(String newData){
    data = newData;
  }
  Locale getLocale(){
    return locale;
  }
  void setLocale(Locale newLocale){

    locale = newLocale;

  }
  int getMaxLines(){
    return maxLines;
  }
void setMaxLines(int newMaxLines){
    maxLines = newMaxLines;

}

TextOverflow getOverflow(){
  return overflow;
}
void setOverflow(TextOverflow newOverflow){
    overflow = newOverflow;
}
String getSemanticsLabel(){
  return semanticsLabel;
}
void setSemanticsLabel(String newSemanticsLabel){
    semanticsLabel = newSemanticsLabel;
}
bool getSoftWrap(){
  return softWrap;
}
void setSoftWrap(bool newSoftWrap){
    softWrap = newSoftWrap;
}

StrutStyle getStrutStyle(){
  return strutStyle;
}

void setStrutStyle(StrutStyle newStrutStyle){
    strutStyle = newStrutStyle;
}

TextStyle getStyle(){
  return style;
}

void setStyle(TextStyle newStyle){
    style = newStyle;
}

TextAlign getTextAlign(){
  return textAlign;
}

void setTextAlign(TextAlign newTextAlign){
    textAlign = newTextAlign;
}

TextDirection getTextDirection(){
  return textDirection;
}

void setTextDirection(TextDirection newTextDirection){
    textDirection = newTextDirection;
}

double getTextScaleFactor(){
  return textScaleFactor;
}

void setTextScaleFactor( double newTextScaleFactor){
    textScaleFactor = newTextScaleFactor;
}

InlineSpan getTextSpan(){
  return textSpan;
}

void setTextSpan(InlineSpan newTextSpan){
    textSpan = newTextSpan;
}

TextWidthBasis getTextWidthBasis(){
  return textWidthBasis;
}

void setTextWidthBasis(TextWidthBasis newTextWidthBasis){
    textWidthBasis = newTextWidthBasis;
}


Widget constructText(){

    return Text(
      data,
      locale: locale,
      maxLines: maxLines,
      overflow: overflow,
      semanticsLabel: semanticsLabel,
      softWrap: softWrap,
      strutStyle: strutStyle,
      style: style,
      textAlign: textAlign,
      textDirection: textDirection,
      textScaleFactor: textScaleFactor,
      textWidthBasis: textWidthBasis,



    );
}


Widget constructSelectableText(){

  return SelectableText(
    data,
    maxLines: maxLines,
    strutStyle: strutStyle,
    style: style,
    textAlign: textAlign,
    textDirection: textDirection,
    textScaleFactor: textScaleFactor,
    textWidthBasis: textWidthBasis,



  );
}

}