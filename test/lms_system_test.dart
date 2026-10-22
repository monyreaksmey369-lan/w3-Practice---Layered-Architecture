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

    // verify the studnet and course still exist after removal
    expect(lms.students.any((s) => s.id == 'S01'), isTrue);
    expect(lms.courses.any((c) => c.id == 'C01'), isTrue);

    // Reject removal of a nonexistent enrollment
    expect(
        () => lms.discardStudentFromCourse(studentId: 'S01', courseId: 'C07'),
        throwsException);

    // Remove a student who has enrollments in multiple courses
    lms.addCourse(courseId: 'C02', courseName: 'Flutter Development');
    lms.addCourse(courseId: 'C03', courseName: 'Dart Programming');
    lms.addStudent(studentId: 'S02', studentName: 'Ronan the best');

    for (final c in ['C01', 'C02', 'C03']) {
      lms.enrollStudent(studentId: 'S02', courseId: c);
    }
    lms.removeStudent(studentId: 'S02');
    expect(lms.students.length, 1);
  });

  // Task 4 add a result to a course
  test('Add a result to a course', () {
    final lms = LmsSystem();
    lms.addCourse(courseId: 'C02', courseName: 'Mobile Development');
    lms.addCourse(courseId: 'C03', courseName: 'Dart Programming');
    lms.addStudent(studentId: 'S02', studentName: 'Ronan the best');
    lms.enrollStudent(studentId: 'S02', courseId: 'C02');

    // add a valid result
    lms.addResult(studentId: 'S02', courseId: 'C02', score: 99);
    expect(lms.result.length, 1);
    expect(lms.result.first.score, 99);

    // reject a result for a nonexistent student or course
    expect(() => lms.addResult(studentId: 'S02', courseId: 'C99', score: 90),
        throwsException);

    // reject a result for a student who is not enrolled, if enrollment is required
    expect(() => lms.addResult(studentId: 'S01', courseId: 'C02', score: 80),
        throwsException);

    // reject an invalid score
    expect(() => lms.addResult(studentId: 'S01', courseId: 'S01', score: -1),
        throwsException);

    // test the chosen policy for duplicate result
    lms.addResult(studentId: 'S02', courseId: 'C02', score: 95);
    lms.addResult(studentId: 'S02', courseId: 'C02', score: 99);
    expect(lms.result.length, 3); // no duplicate
    expect(lms.result.first.score, 99); // score updated
  });

  // Task 5 remove a student result
test('Remove a student result', () {
  final lms = LmsSystem();
  lms.addCourse(courseId: 'C01', courseName: 'Mobile Development');
  lms.addCourse(courseId: 'C02', courseName: 'Flutter Development');
  lms.addStudent(studentId: 'S01', studentName: 'Ronan');
  lms.addStudent(studentId: 'S02', studentName: 'Other');
  lms.enrollStudent(studentId: 'S01', courseId: 'C01');
  lms.enrollStudent(studentId: 'S01', courseId: 'C02');
  lms.enrollStudent(studentId: 'S02', courseId: 'C01');
  lms.addResult(studentId: 'S01', courseId: 'C01', score: 90);
  lms.addResult(studentId: 'S01', courseId: 'C02', score: 80);
  lms.addResult(studentId: 'S02', courseId: 'C01', score: 70);

  // remove an existing result
  lms.removeResult(studentId: 'S01', courseId: 'C01');
  expect(lms.result.length, 2);

  // reject removal of a nonexistent result
  // (S02 is not in C02, so there is no such result)
  expect(
    () => lms.removeResult(studentId: 'S02', courseId: 'C02'),
    throwsException,
  );
  expect(lms.result.length, 2); // nothing changed

  // verify that the removed result is no longer available
  final stillThere = lms.result.any(
    (r) => r.studentId.id == 'S01' && r.courseId.id == 'C01',
  );
  expect(stillThere, isFalse);

  // removing the same result again is rejected
  expect(
    () => lms.removeResult(studentId: 'S01', courseId: 'C01'),
    throwsException,
  );

  // student, course and enrollments are unchanged
  expect(lms.students.length, 2);
  expect(lms.courses.length, 2);
  expect(lms.students.any((s) => s.id == 'S01'), isTrue);
  expect(lms.courses.any((c) => c.id == 'C01'), isTrue);
  expect(lms.enroll.length, 3);

  // unrelated results are unchanged
  final s01c02 = lms.result.firstWhere(
    (r) => r.studentId.id == 'S01' && r.courseId.id == 'C02',
  );
  final s02c01 = lms.result.firstWhere(
    (r) => r.studentId.id == 'S02' && r.courseId.id == 'C01',
  );
  expect(s01c02.score, 80);
  expect(s02c01.score, 70);
});
}
