import 'package:flutter/material.dart' show Color;

class Course {
  final String title, description, iconSrc;
  final Color color;

  Course({
    required this.title,
    required this.description,
    this.iconSrc = "assets/icons/ios.svg",
    this.color = const Color(0xFF7553F6),
  });
}

final List<Course> courses = [
  Course(
      title: "Artificial Intelligence",
      description:
          "Dive into the foundations of AI, exploring its principles and applications in modern technology."),
  Course(
    description:
        "Learn Python from scratch, mastering its syntax and core concepts for versatile programming needs.",
    title: "Python Programming",
    iconSrc: "assets/icons/code.svg",
    color: const Color(0xFF80A4FF),
  ),
  Course(
      title: "Fundamentals of UI Design",
      description:
          "Discover the essentials of crafting user-friendly interfaces, blending creativity with functional design principles."),
  Course(
    description:
        "Explore the world of User Experience, understanding how to create intuitive and engaging digital experiences.",
    title: "UI & UX Design",
    iconSrc: "assets/icons/code.svg",
    color: const Color(0xFF80A4FF),
  ),
];

final List<Course> recentCourses = [
  Course(
    description: "",
    title: "Web Development",
    color: const Color(0xFF9CC5FF),
    iconSrc: "assets/icons/code.svg",
  ),
  Course(
    description: "",
    title: "Flutter Development",
    iconSrc: "assets/icons/code.svg",
  ),
  Course(
      title: "Machine Learning Basics",
      color: const Color(0xFF9CC5FF),
      description:
          "Explore the fundamentals of Machine Learning, diving into algorithms and their real-world applications."),
  Course(
    title: "React Development",
    description: "",
  ),
];
