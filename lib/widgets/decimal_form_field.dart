import 'package:flutter/material.dart';
import 'package:savvy_cart/formatters/formatters.dart';

class DecimalFormField extends FormField<String> {
  final TextEditingController? controller;
  final FocusNode? focusNode;

  DecimalFormField({
    Key? key,
    required int decimalPlaces,
    this.controller,
    this.focusNode,
    String? initialValue,
    InputDecoration? decoration,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    AutovalidateMode? autovalidateMode,
    bool enabled = true,
    TextInputAction? textInputAction,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
  }) : assert(decimalPlaces >= 0),
       super(
         key: key,
         initialValue: controller != null
             ? controller.text
             : (initialValue ?? ''),
         onSaved: onSaved,
         validator: validator,
         autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
         enabled: enabled,
         builder: (FormFieldState<String> field) {
           final _DecimalFormFieldState state = field as _DecimalFormFieldState;
           return TextField(
             controller: state._effectiveController,
             focusNode: (field.widget as DecimalFormField).focusNode,
             decoration: (decoration ?? const InputDecoration()).copyWith(
               errorText: field.errorText,
             ),
             keyboardType: const TextInputType.numberWithOptions(decimal: true),
             inputFormatters: [
               DecimalTextInputFormatter(decimalRange: decimalPlaces),
             ],
             onChanged: (value) {
               field.didChange(value);
               if (onChanged != null) onChanged(value);
             },
             enabled: enabled,
             textInputAction: textInputAction,
             onSubmitted: onFieldSubmitted,
           );
         },
       );

  @override
  FormFieldState<String> createState() => _DecimalFormFieldState();
}

class _DecimalFormFieldState extends FormFieldState<String> {
  TextEditingController? _controller;

  TextEditingController get _effectiveController =>
      (widget as DecimalFormField).controller ?? _controller!;

  @override
  void initState() {
    super.initState();
    final controller = (widget as DecimalFormField).controller;
    if (controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(FormField<String> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldController = (oldWidget as DecimalFormField).controller;
    final newController = (widget as DecimalFormField).controller;

    if (oldController != newController) {
      oldController?.removeListener(_handleControllerChanged);
      newController?.addListener(_handleControllerChanged);

      if (oldController == null && newController != null) {
        _controller?.dispose();
        _controller = null;
      } else if (oldController != null && newController == null) {
        _controller = TextEditingController(text: widget.initialValue);
      }
    }
    if (_effectiveController.text != value) {
      _effectiveController.text = value ?? '';
    }
  }

  void _handleControllerChanged() {
    if (_effectiveController.text != value) {
      didChange(_effectiveController.text);
    }
  }

  @override
  void dispose() {
    final controller = (widget as DecimalFormField).controller;
    controller?.removeListener(_handleControllerChanged);
    _controller?.dispose();
    super.dispose();
  }
}
