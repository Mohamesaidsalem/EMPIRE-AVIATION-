String calculateDifference(String startTime, String endTime) {
  if (startTime.isEmpty ||
      endTime.isEmpty ||
      !startTime.contains(":") ||
      !endTime.contains(":")) {
    return "--:--"; // في حالة الإدخال غير المكتمل
  }

  List<String> startParts = startTime.split(":");
  List<String> endParts = endTime.split(":");

  int startHours = int.tryParse(startParts[0]) ?? 0;
  int startMinutes = int.tryParse(startParts[1]) ?? 0;
  int endHours = int.tryParse(endParts[0]) ?? 0;
  int endMinutes = int.tryParse(endParts[1]) ?? 0;

  int startTotalMinutes = (startHours * 60) + startMinutes;
  int endTotalMinutes = (endHours * 60) + endMinutes;

  int diffMinutes = (endTotalMinutes >= startTotalMinutes)
      ? (endTotalMinutes - startTotalMinutes)
      : (1440 - startTotalMinutes + endTotalMinutes);

  int hours = diffMinutes ~/ 60;
  int minutes = diffMinutes % 60;

  return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
}
