String patientInitial(String name) {
  if (name.trim().isEmpty) return "?";
  return name.trim()[0].toUpperCase();
}
