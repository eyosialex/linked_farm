import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Services/locale_provider.dart';
import '../Services/voice_guide_service.dart';

class VoiceGuideButton extends StatefulWidget {
  final List<String> messages;
  final bool isDark;

  const VoiceGuideButton({
    super.key,
    required this.messages,
    this.isDark = false,
  });

  @override
  State<VoiceGuideButton> createState() => _VoiceGuideButtonState();
}

class _VoiceGuideButtonState extends State<VoiceGuideButton> {
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _checkAutoPlay();
  }

  void _checkAutoPlay() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final service = Provider.of<VoiceGuideService>(context, listen: false);
      if (service.isAccessibilityModeEnabled) {
        _startVoice();
      }
    });
  }

  void _startVoice() async {
    final service = Provider.of<VoiceGuideService>(context, listen: false);
    if (mounted) setState(() => _isPlaying = true);
    await service.speakQueue(widget.messages, Localizations.localeOf(context));
    if (mounted) setState(() => _isPlaying = false);
  }

  void _toggleVoice() async {
    final service = Provider.of<VoiceGuideService>(context, listen: false);
    if (_isPlaying) {
      await service.stop();
      if (mounted) setState(() => _isPlaying = false);
    } else {
      _startVoice();
    }
  }

  void _cycleLanguage() {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final current = localeProvider.locale.languageCode;
    Locale nextLocale;
    String announcement;

    if (current == 'en') {
      nextLocale = const Locale('am');
      announcement = "Language changed to Amharic";
    } else if (current == 'am') {
      nextLocale = const Locale('om');
      announcement = "Language changed to Oromo";
    } else {
      nextLocale = const Locale('en');
      announcement = "Language changed to English";
    }

    localeProvider.setLocale(nextLocale);
    
    // Announce the change
    final service = Provider.of<VoiceGuideService>(context, listen: false);
    service.speakQueue([announcement], nextLocale);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isPlaying ? Icons.stop_circle_outlined : Icons.volume_up_outlined,
        color: widget.isDark ? Colors.white : Colors.green[800],
      ),
      tooltip: "Tap to Speak, Long Press to Change Language",
      onPressed: _toggleVoice,
      onLongPress: _cycleLanguage,
    );
  }
}

class VoiceGuideListener extends StatefulWidget {
  final List<String> messages;

  const VoiceGuideListener({
    super.key,
    required this.messages,
  });

  @override
  State<VoiceGuideListener> createState() => _VoiceGuideListenerState();
}

class _VoiceGuideListenerState extends State<VoiceGuideListener> {
  @override
  void initState() {
    super.initState();
    _checkAutoPlay();
  }

  void _checkAutoPlay() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final service = Provider.of<VoiceGuideService>(context, listen: false);
      if (service.isAccessibilityModeEnabled) {
        await service.speakQueue(widget.messages, Localizations.localeOf(context));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
