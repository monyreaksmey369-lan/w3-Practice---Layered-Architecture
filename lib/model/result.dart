import 'student.dart';
import 'course.dart';

class Result {
  final Student studentId;
  final Course courseId;
  double score;

  Result(
      {required this.studentId, required this.courseId, required this.score});
}
