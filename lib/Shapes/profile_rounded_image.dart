// ///
// /// Created by NieBin on 2019/1/1
// /// Github: https://github.com/nb312
// /// Email: niebin312@gmail.com
// ///
// import 'dart:math';
//
// import "package:flutter/material.dart";
// import 'package:flutter_canvas/const/size_const.dart';
// import 'package:flutter_canvas/math/circle.dart';
// import 'package:flutter_canvas/math/line.dart';
//
// const BLUE_NORMAL = Color(0xff54c5f8);
// const GREEN_NORMAL = Color(0xff6bde54);
// const BLUE_DARK2 = Color(0xff01579b);
// const BLUE_DARK1 = Color(0xff29b6f6);
// const RED_DARK1 = Color(0xfff26388);
// const RED_DARK2 = Color(0xfff782a0);
// const RED_DARK3 = Color(0xfffb8ba8);
// const RED_DARK4 = Color(0xfffb89a6);
// const RED_DARK5 = Color(0xfffd86a5);
// const YELLOW_NORMAL = Color(0xfffcce89);
// const List<Point> POINT = [Point(100, 100)];
//
// SizeUtil get _sizeUtil {
//   return SizeUtil.getInstance(key: SizeKeyConst.CIRCLE_KEY);
// }
//
// class CirclePainter extends CustomPainter {
//   CirclePainter({this.startAngle});
//
//   final double startAngle;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     if (size.width > 1.0 && size.height > 1.0) {
//       print(">1.9");
//       _sizeUtil.logicSize = size;
//     }
//     var paint = Paint()
//       ..style = PaintingStyle.fill
//       ..color = BLUE_NORMAL
//       ..strokeWidth = 2.0
//       ..isAntiAlias = true;
//     paint.color = Colors.grey[900];
// //    canvas.drawCircle(
// //        Offset(_sizeUtil.getAxisX(250), _sizeUtil.getAxisY(250.0)),
// //        _sizeUtil.getAxisBoth(200.0),
// //        paint);
//     paint.color = RED_DARK1;
//     paint.strokeWidth = 20;
//     paint.style = PaintingStyle.stroke;
//     var center = Offset(
//       _sizeUtil.getAxisX(250.0),
//       _sizeUtil.getAxisY(250.0),
//     );
//     var radius = _sizeUtil.getAxisBoth(200);
//     _drawArcGroup(
//       canvas,
//       center: center,
//       radius: radius,
//       sources: [
//         1,
//         1,
//         1,
//         1,
//         1,
//         1,
//         1,
//         1,
//         1,
//       ],
//       colors: [BLUE_DARK1, RED_DARK1, BLUE_DARK2, GREEN_NORMAL, YELLOW_NORMAL],
//       paintWidth: 80.0,
//       startAngle: 1.3 * startAngle / radius,
//       hasEnd: true,
//       hasCurrent: false,
//       curPaintWidth: 45.0,
//       curIndex: 1,
//     );
//     canvas.save();
//     canvas.restore();
//   }
//
//   void _drawArcGroup(Canvas canvas,
//       {Offset center,
//       double radius,
//       List<double> sources,
//       List<Color> colors,
//       double startAngle = 0.0,
//       double paintWidth = 10.0,
//       bool hasEnd = false,
//       hasCurrent = false,
//       int curIndex = 0,
//       curPaintWidth = 12.0}) {
//     assert(sources != null && sources.length > 0);
//     assert(colors != null && colors.length > 0);
//     var paint = Paint()
//       ..style = PaintingStyle.fill
//       ..color = BLUE_NORMAL
//       ..strokeWidth = paintWidth
//       ..isAntiAlias = true;
//     double total = 0;
//     for (double d in sources) {
//       total += d;
//     }
//     assert(total > 0.0);
//     List<double> radians = List<double>();
//     for (double d in sources) {
//       double radian = d * 2 * pi / total;
//       radians.add(radian);
//     }
//     var startA = startAngle;
//     paint.style = PaintingStyle.stroke;
//     var curStartAngle = 0.0;
//     for (int i = 0; i < radians.length; i++) {
//       var rd = radians[i];
//       if (hasCurrent && curIndex == i) {
//         curStartAngle = startA;
//         startA += rd;
//         continue;
//       }
//       paint.color = colors[i % colors.length];
//       paint.strokeWidth = paintWidth;
//       _drawArcWithCenter(canvas, paint,
//           center: center, radius: radius, startRadian: startA, sweepRadian: rd);
//       startA += rd;
//     }
//     if (hasEnd) {
//       startA = startAngle;
//       paint.strokeWidth = paintWidth;
//       for (int i = 0; i < radians.length; i++) {
//         var rd = radians[i];
//         if (hasCurrent && curIndex == i) {
//           startA += rd;
//           continue;
//         }
//         paint.color = colors[i % colors.length];
//         paint.strokeWidth = paintWidth;
//         _drawArcTwoPoint(canvas, paint,
//             center: center,
//             radius: radius,
//             startRadian: startA,
//             sweepRadian: rd,
//             hasEndArc: true);
//         startA += rd;
//       }
//     }
//
//     if (hasCurrent) {
//       paint.color = colors[curIndex % colors.length];
//       paint.strokeWidth = curPaintWidth;
//       paint.style = PaintingStyle.stroke;
//       _drawArcWithCenter(canvas, paint,
//           center: center,
//           radius: radius,
//           startRadian: curStartAngle,
//           sweepRadian: radians[curIndex]);
//     }
//     if (hasCurrent && hasEnd) {
//       var rd = radians[curIndex % radians.length];
//       paint.color = colors[curIndex % colors.length];
//       paint.strokeWidth = curPaintWidth;
//       paint.style = PaintingStyle.fill;
//       _drawArcTwoPoint(canvas, paint,
//           center: center,
//           radius: radius,
//           startRadian: curStartAngle,
//           sweepRadian: rd,
//           hasEndArc: true,
//           hasStartArc: true);
//     }
//   }
//
//   void _drawArcWithCenter(
//     Canvas canvas,
//     Paint paint, {
//     Offset center,
//     double radius,
//     startRadian = 0.0,
//     sweepRadian = pi,
//   }) {
//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       startRadian,
//       sweepRadian,
//       false,
//       paint,
//     );
//   }
//
//   void _drawArcTwoPoint(Canvas canvas, Paint paint,
//       {Offset center,
//       double radius,
//       startRadian = 0.0,
//       sweepRadian = pi,
//       hasStartArc = false,
//       hasEndArc = false}) {
//     var smallR = paint.strokeWidth / 2;
//     paint.strokeWidth = smallR;
//     if (hasStartArc) {
//       var startCenter = LineCircle.radianPoint(
//           Point(center.dx, center.dy), radius, startRadian);
//       paint.style = PaintingStyle.fill;
//       canvas.drawCircle(Offset(startCenter.x, startCenter.y), smallR, paint);
//     }
//     if (hasEndArc) {
//       var endCenter = LineCircle.radianPoint(
//           Point(center.dx, center.dy), radius, startRadian + sweepRadian);
//       paint.style = PaintingStyle.fill;
//       canvas.drawCircle(Offset(endCenter.x, endCenter.y), smallR, paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }

import "dart:math";

class Line {
  ///y = kx + c
  static double normalLine(x, {k = 0, c = 0}) {
    return k * x + c;
  }

  ///Calculate the param K in y = kx +c
  static double paramK(Point p1, Point p2) {
    if (p1.x == p2.x) return 0;
    return (p2.y - p1.y) / (p2.x - p1.x);
  }

  ///Calculate the param C in y = kx +c
  static double paramC(Point p1, Point p2) {
    return p1.y - paramK(p1, p2) * p1.x;
  }
}

/// start point p1, end point p2,p2 is center of the circle,r is its radius.
class LineInterCircle {
  /// start point p1, end point p2,p2 is center of the circle,r is its radius.
  /// param a: y = kx +c intersect with circle,which has the center with point2 and radius R .
  /// when derive to x2+ ax +b = 0 equation. the param a is here.
  static double paramA(Point p1, Point p2) {
    return (2 * Line.paramK(p1, p2) * Line.paramC(p1, p2) -
            2 * Line.paramK(p1, p2) * p2.y -
            2 * p2.x) /
        (Line.paramK(p1, p2) * Line.paramK(p1, p2) + 1);
  }

  /// start point p1, end point p2,p2 is center of the circle,r is its radius.
  /// param b: y = kx +c intersect with circle,which has the center with point2 and radius R .
  /// when derive to x2+ ax +b = 0 equation. the param b is here.
  static double paramB(Point p1, Point p2, double r) {
    return (p2.x * p2.x -
            r * r +
            (Line.paramC(p1, p2) - p2.y) * (Line.paramC(p1, p2) - p2.y)) /
        (Line.paramK(p1, p2) * Line.paramK(p1, p2) + 1);
  }

  ///the circle has the intersection or not
  static bool isIntersection(Point p1, Point p2, double r) {
    var delta = sqrt(paramA(p1, p2) * paramA(p1, p2) - 4 * paramB(p1, p2, r));
    return delta >= 0.0;
  }

  ///the x coordinate whether or not is between two point we give.
  static bool _betweenPoint(x, Point p1, Point p2) {
    if (p1.x > p2.x) {
      return x > p2.x && x < p1.x;
    } else {
      return x > p1.x && x < p2.x;
    }
  }

  static Point _equalX(Point p1, Point p2, double r) {
    if (p1.y > p2.y) {
      return Point(p2.x, p2.y + r);
    } else if (p1.y < p2.y) {
      return Point(p2.x, p2.y - r);
    } else {
      return p2;
    }
  }

  static Point _equalY(Point p1, Point p2, double r) {
    if (p1.x > p2.x) {
      return Point(p2.x + r, p2.y);
    } else if (p1.x < p2.x) {
      return Point(p2.x - r, p2.y);
    } else {
      return p2;
    }
  }

  ///intersection point
  static Point intersectionPoint(Point p1, Point p2, double r) {
    if (p1.x == p2.x) return _equalX(p1, p2, r);
    if (p1.y == p2.y) return _equalY(p1, p2, r);
    var delta = sqrt(paramA(p1, p2) * paramA(p1, p2) - 4 * paramB(p1, p2, r));
    if (delta < 0.0) {
      //when no intersection, i will return the center of the circ  le.
      return p2;
    }
    var a_2 = -paramA(p1, p2) / 2.0;
    var x1 = a_2 + delta / 2;
    if (_betweenPoint(x1, p1, p2)) {
      var y1 = Line.paramK(p1, p2) * x1 + Line.paramC(p1, p2);
      return Point(x1, y1);
    }
    var x2 = a_2 - delta / 2;
    var y2 = Line.paramK(p1, p2) * x2 + Line.paramC(p1, p2);
    return Point(x2, y2);
  }
}
