import '../model/enrollment.dart';

import '../model/student.dart';
import '../model/course.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<Enrollment> enroll = [];

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
