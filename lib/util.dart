import 'dart:math';


double generateNextRandomValue(double currentValue, int maxGap) {

  print('current $currentValue, max: $maxGap');
  final random = Random();
  double nextValue;

  int randomInt = random.nextInt(maxGap);

  if (randomInt % 2 == 0){
    nextValue = currentValue + randomInt + random.nextDouble();
  } else {
    nextValue = currentValue - randomInt + random.nextDouble();
  }

  if (nextValue < 0) {
    return 0;
  }

  if (nextValue > 100) {
    return 100;
  }

  return nextValue;

}