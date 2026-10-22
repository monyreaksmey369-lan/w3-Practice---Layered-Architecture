
import '../model/enrollment.dart';
import '../model/result.dart';
import '../model/student.dart';
import '../model/course.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<Enrollment> enroll = [];
  final List<Result> result = [];

  // Task1 add and remove course
  // add course
  void addCourse({required String courseId, required String courseName}) {
    Course? course = _findCourseOrNull(courseId);
    if (course != null) {
      throw Exception('Course $courseId alredy exits');
    }
    courses.add(Course(id: courseId, name: courseName));
  }

  // remove course
  void removeCourse({
    required String courseId,
  }) {
    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }
    courses.remove(course);
  }

  // Task 2 Enroll a student in a course
  void enrollStudent({required String studentId, required String courseId}) {
    Student? student = _findStudentOrNull(studentId);
    Course? course = _findCourseOrNull(courseId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
    if (course == null) {
      throw Exception('Course $courseId not found');
    }
    final alreadyEnroll = enroll.any(
      (e) => e.courseId.id == courseId && e.studentId.id == studentId,
    );
    if (alreadyEnroll) {
      throw Exception(
          'Student $studentId is already enrolled in this course $courseId');
    }
    enroll.add(Enrollment(courseId: course, studentId: student));
  }

  // Task 3 Remove a student from a course
  void discardStudentFromCourse(
      {required String studentId, required String courseId}) {
    Student? student = _findStudentOrNull(studentId);
    Course? course = _findCourseOrNull(courseId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
    if (course == null) {
      throw Exception('Course $courseId not found');
    }
    final isEnrolled = enroll
        .any((e) => e.studentId.id == studentId && e.courseId.id == courseId);
    if (!isEnrolled) {
      throw Exception('Student $studentId is not enrolled in course $courseId');
    }
    enroll.removeWhere(
        (e) => e.studentId.id == studentId && e.courseId.id == courseId);
  }

  // Task 4 Add a result to a course
  void addResult(
      {required String studentId,
      required String courseId,
      required double score}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }
    // student be enrolled in the course ot not
    final enrolled =
        enroll.any((e) => e.courseId.id == courseId && e.studentId.id == studentId);
    if (!enrolled) {
      throw Exception('Student $studentId is not enrolled in course $courseId');
    }
    // check value is valid score range
    if (score < 0 || score > 100) {
      throw Expando('Score must between 0 and 100');
    }
    final index = result.indexWhere(
        (r) => r.courseId.id == courseId && r.studentId == studentId);
    if (index == -1) {
      result.add(Result(studentId: student, courseId: course, score: score));
    } else {
      result[index].score = score;
    }
  }

  // Task 5 Remove a student result
  void removeResult({required String studentId , required String courseId}) {
    final index = result.indexWhere(
        (r) => r.courseId.id == courseId && r.studentId.id == studentId);
    if (index == -1) {
      throw Exception(
          'Result for student $studentId in course $courseId not found');
    }
    result.removeAt(index);
  } 

  void addStudent({required String studentId, required String studentName}) {
    // ! Student shall not exist already
    Student? student = _findStudentOrNull(studentId);
    if (student != null) {
      throw Exception('Student $student already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }

  void removeStudent({required String studentId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
    // 1- Remove student from the students list
    students.removeWhere((student) => student.id == studentId);
  }

  Student? _findStudentOrNull(String studentId) {
    for (Student s in students) {
      if (s.id == studentId) {
        return s;
      }
    }
    return null; // not found
  }

  Course? _findCourseOrNull(String courseId) {
    for (Course c in courses) {
      if (c.id == courseId) {
        return c;
      }
    }
    return null; // not found
  }
}
