import 'package:test/test.dart';

import '../lib/service/lms_system.dart';

void main() {
  test('creates a student', () {
    final lms = LmsSystem();

    // Create a student
    lms.addStudent(studentId: 'S1', studentName: "ronan");

    expect(lms.students.first.name, 'ronan');

    // Remove the student
    lms.removeStudent(studentId: 'S1');
    expect(lms.students.length, 0);
  });

  // Task 1 Add and remove courses
  test('Create a course', () {
    final lms = LmsSystem();
    // add a course
    lms.addCourse(courseId: 'C01', courseName: 'Mobile Development');
    expect(lms.courses.first.name, 'Mobile Development');

    // reject a dubplicate course Id
    expect(() => lms.addCourse(courseId: 'C01', courseName: 'Dart programming'),
        throwsException);

    // reject removal of a nonexistent course
    expect(() => lms.removeCourse(courseId: 'C99'), throwsException);
    // here test print
    try {
      lms.removeCourse(courseId: 'C99');
    } catch (r) {
      print(r);
    }
  });

// Task 2 enroll a student in a course
  test('Enroll a student in a course', () {
    final lms = LmsSystem();

    lms.addCourse(courseId: 'C05', courseName: 'Flutter Development');
    lms.addStudent(studentId: 'S5', studentName: 'ronan1 the best');
    expect(lms.students.first.name, 'ronan1 the best');
    expect(lms.courses.first.name, 'Flutter Development');
    lms.enrollStudent(studentId: 'S5', courseId: 'C05');

    // verify enrollment is recorded.
    expect(lms.enroll.length, 1);

    // Reject enroll if the student does not exist
    lms.addCourse(courseId: 'C06', courseName: 'Mobile Development');
    expect(() => lms.enrollStudent(studentId: 'S99', courseId: 'C06'),
        throwsException);

    // Reject enroll if the course does not exist
    expect(() => lms.enrollStudent(studentId: 'S5', courseId: 'C99'),
        throwsException);

    // Reject duplicate enrollment.
    expect(() => lms.enrollStudent(studentId: 'S4', courseId: 'C04'),
        throwsException);
  });

  // Task 3 Remove a student from a course
  test('Remove a student from a course', () {
    final lms = LmsSystem();
    lms.addCourse(courseId: 'C01', courseName: 'Mobile Development');
    lms.addStudent(studentId: 'S01', studentName: 'Ronan');
    lms.enrollStudent(studentId: 'S01', courseId: 'C01');

    // remove an existing enrollment
    lms.discardStudentFromCourse(studentId: 'S01', courseId: 'C01');
    expect(lms.enroll.length, 0);
  });
}
