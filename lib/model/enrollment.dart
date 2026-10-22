import 'course.dart';
import 'student.dart';

class Enrollment {
  final Course courseId;
  final Student studentId;

  Enrollment({required this.courseId, required this.studentId});
}
