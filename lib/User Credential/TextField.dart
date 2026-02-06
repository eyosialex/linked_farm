import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Services/voice_guide_service.dart';

class Mytextfield extends StatefulWidget {
  final TextEditingController con;
  final String HintText;
  final bool valid;
  final String? voiceLabel;
  final IconData? icon;

  const Mytextfield({
    super.key,
    required this.con,
    required this.HintText,
    required this.valid,
    this.voiceLabel,
    this.icon,
  });
  @override
  State<Mytextfield> createState() => _MytextfieldState();
}

class _MytextfieldState extends State<Mytextfield> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      final service = Provider.of<VoiceGuideService>(context, listen: false);
      if (service.isAccessibilityModeEnabled) {
        service.speakQueue([widget.voiceLabel ?? widget.HintText], Localizations.localeOf(context));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Semantics(
        label: widget.HintText,
        textField: true,
        child: TextField(
          controller: widget.con,
          focusNode: _focusNode,
          obscureText: widget.valid,
          decoration: InputDecoration(
            hintText: widget.HintText,
            prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
