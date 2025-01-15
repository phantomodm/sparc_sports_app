enum FilterLayout {
  bottomSheet,
  fullScreen,
}

class FormControlConfig {
  final String formControlName;
  final String label;
  final String? color;
  final String element; // Use String instead of union type
  final int? min;
  final int? max;
  final int? step;
  final List<dynamic>? options;
  final List<dynamic>? control;
  final bool? multiple;
  final String? placeholder;

  FormControlConfig({
    required this.formControlName,
    required this.label,
    this.color,
    required this.element,
    this.min,
    this.max,
    this.step,
    this.options,
    this.control,
    this.multiple,
    this.placeholder,
  });
}