import 'dart:async';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTime = 25;
  int _cycleCount = 0;
  int _roundCount = 0;
  bool _isBreak = false;
  Timer? _timer;
  int _timeLeft = 0;

  @override
  void initState() {
    super.initState();
    _timeLeft = _selectedTime * 60;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resetTimer() {
    setState(() {
      _selectedTime = 25;
      _cycleCount = 0;
      _roundCount = 0;
      _isBreak = false;
      _timeLeft = _selectedTime * 60;
    });
    _startTimer();
  }

  void _incrementCycle() {
    setState(() {
      if (_isBreak) {
        _isBreak = false;
        return;
      }
      if (_cycleCount % 4 == 0) {
        if (_roundCount >= 12) {
          return;
        }
        if (_roundCount > 0) {
          _isBreak = true;
          return;
        }
        _roundCount++;
      }
      if (_roundCount >= 12) {
        return;
      }
      _cycleCount++;
      _selectedTime = 25;
      _timeLeft = _selectedTime * 60;
    });
    _startTimer();
  }

  void _startTimer() {
    if (_timer != null) {
      if (_timer!.isActive) {
        return;
      }
    }
    const oneSec = Duration(seconds: 1);
    setState(() {
      if (_timer != null) {
        if (_timer!.isActive) {
          return;
        }
      }
      if (_timeLeft > -1) {
        _timer = Timer.periodic(
          oneSec,
          (Timer timer) => setState(
            () {
              if (_timeLeft < 1) {
                timer.cancel();
                _incrementCycle();
              } else {
                _timeLeft -= oneSec.inSeconds;
              }
            },
          ),
        );
      }
    });
  }

  String getFormattedTime(int timeInSeconds) {
    final minutes = timeInSeconds ~/ 60;
    final seconds = timeInSeconds % 60;

    final formattedMinutes = minutes < 10 ? '0$minutes' : minutes.toString();
    final formattedSeconds = seconds < 10 ? '0$seconds' : seconds.toString();

    return '$formattedMinutes:$formattedSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "     POMOTIMER",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 150,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Center(
                    child: Text(
                      getFormattedTime(_timeLeft).substring(0, 2),
                      style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.w500,
                          color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  getFormattedTime(_timeLeft)[2],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 70,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: 120,
                  height: 150,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Center(
                    child: Text(
                      getFormattedTime(_timeLeft).substring(3, 5),
                      style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.w500,
                          color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [15, 20, 25, 30, 35]
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                e == _selectedTime ? Colors.red : Colors.white,
                            backgroundColor:
                                e == _selectedTime ? Colors.white : Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: Colors.white.withOpacity(0.5),
                                    width: 3)),
                            fixedSize: const Size.fromHeight(50),
                          ),
                          child: Text(
                            '$e',
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedTime = e;
                              _timeLeft = _selectedTime * 60;
                            });
                            _startTimer();
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.black.withOpacity(0.2)),
              child: IconButton(
                onPressed: _resetTimer,
                icon: const Icon(
                  Icons.pause,
                  color: Colors.white,
                  size: 45,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '$_cycleCount/4',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text('ROUND',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
                const SizedBox(
                  width: 150,
                ),
                Column(
                  children: [
                    Text(
                      '$_roundCount/12',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text('GOAL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ],
            ),
            if (_isBreak) const Text('Take a break!'),
          ],
        ),
      ),
    );
  }
}

class NotebookShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.2)
      ..lineTo(size.width * 0.8, size.height * 0.2)
      ..lineTo(size.width * 0.8, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
