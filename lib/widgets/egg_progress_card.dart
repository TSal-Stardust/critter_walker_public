import 'package:flutter/material.dart';
import '../models/evolution_stage.dart';

class EggProgressCard extends StatefulWidget {
  final int currentSteps;
  final List<EvolutionStage> stages;
  final String eggName;

  const EggProgressCard({
    super.key,
    required this.currentSteps,
    required this.stages,
    required this.eggName,
  });

  @override
  State<EggProgressCard> createState() => _EggProgressCardState();
}

class _EggProgressCardState extends State<EggProgressCard>
    with TickerProviderStateMixin {
  bool showEvolutionBanner = false;
  late EvolutionStage currentStage;
  late AnimationController _evolutionController;
  late AnimationController _popController;
  String bannerText = '';

  @override
  void initState() {
    super.initState();
    currentStage = _getCurrentStage(widget.currentSteps);

    _evolutionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void dispose() {
    _evolutionController.dispose();
    _popController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant EggProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final previousStage = _getStageForSteps(
      oldWidget.currentSteps,
      oldWidget.stages,
    );
    final newStage = _getCurrentStage(widget.currentSteps);

    if (previousStage.assetPath != newStage.assetPath) {
      final isHatch = previousStage.name == widget.eggName;

      setState(() {
        currentStage = newStage;
        bannerText = isHatch
            ? '🥚 ${widget.eggName} hatched into ${newStage.name}!'
            : '✨ It evolved into ${newStage.name}!';
        showEvolutionBanner = true;
      });

      _evolutionController.forward(from: 0);
      _popController.forward(from: 0);

      Future.delayed(const Duration(milliseconds: 1400), () {
        if (!mounted) return;
        setState(() {
          showEvolutionBanner = false;
        });
      });
    } else {
      currentStage = newStage;
    }
  }

  EvolutionStage _getCurrentStage(int steps) {
    return _getStageForSteps(steps, widget.stages);
  }

  EvolutionStage _getStageForSteps(int steps, List<EvolutionStage> stages) {
    EvolutionStage current = stages.first;

    for (final stage in stages) {
      if (steps >= stage.requiredSteps) {
        current = stage;
      } else {
        break;
      }
    }

    return current;
  }

  EvolutionStage? _getNextStage() {
    for (final stage in widget.stages) {
      if (widget.currentSteps < stage.requiredSteps) {
        return stage;
      }
    }
    return null;
  }

  double _getProgressToNextStage() {
    final nextStage = _getNextStage();

    if (nextStage == null) {
      return 1.0;
    }

    final startSteps = currentStage.requiredSteps;
    final endSteps = nextStage.requiredSteps;
    final span = endSteps - startSteps;

    if (span <= 0) {
      return 1.0;
    }

    final progressed = widget.currentSteps - startSteps;
    return (progressed / span).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final nextStage = _getNextStage();
    final progress = _getProgressToNextStage();

    final stepLabel = nextStage != null
        ? '${widget.currentSteps} / ${nextStage.requiredSteps} steps'
        : '${widget.currentSteps} steps';

    final statusLabel = nextStage != null
        ? currentStage.name
        : '${currentStage.name} (Final Form)';

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 320,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2CBCD),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _evolutionController,
                    _popController,
                  ]),
                  builder: (context, child) {
                    final t = Curves.easeOutCubic.transform(
                      _evolutionController.value,
                    );

                    final flashOpacity = (1.0 - t) * 0.55;
                    final glowScale = 0.75 + (t * 0.95);
                    final glowOpacity = (1.0 - t) * 0.45;

                    final popScale = TweenSequence<double>([
                      TweenSequenceItem(
                        tween: Tween(
                          begin: 1.0,
                          end: 1.12,
                        ).chain(CurveTween(curve: Curves.easeOut)),
                        weight: 45,
                      ),
                      TweenSequenceItem(
                        tween: Tween(
                          begin: 1.12,
                          end: 0.96,
                        ).chain(CurveTween(curve: Curves.easeInOut)),
                        weight: 25,
                      ),
                      TweenSequenceItem(
                        tween: Tween(
                          begin: 0.96,
                          end: 1.0,
                        ).chain(CurveTween(curve: Curves.easeOut)),
                        weight: 30,
                      ),
                    ]).transform(_popController.value);

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: flashOpacity,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                        ),
                        Transform.scale(
                          scale: glowScale,
                          child: Opacity(
                            opacity: glowOpacity,
                            child: Container(
                              width: 210,
                              height: 210,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        ..._buildSparkles(t),
                        Transform.scale(scale: popScale, child: child!),
                      ],
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(
                              begin: 0.85,
                              end: 1.0,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Image.asset(
                        currentStage.assetPath,
                        key: ValueKey(currentStage.assetPath),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: showEvolutionBanner ? 1.0 : 0.0,
                child: Transform.translate(
                  offset: const Offset(0, -110),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      bannerText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              statusLabel,
              key: ValueKey(statusLabel),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 350),
              builder: (context, animatedValue, child) {
                return LinearProgressIndicator(
                  value: animatedValue,
                  minHeight: 20,
                  backgroundColor: const Color(0xFFD7D7D7),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF72F06A)),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              stepLabel,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) {
              final offsetAnimation = Tween<Offset>(
                begin: const Offset(0.0, 0.15),
                end: Offset.zero,
              ).animate(animation);

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: offsetAnimation, child: child),
              );
            },
            child: Text(
              currentStage.flavorText,
              key: ValueKey(currentStage.flavorText),
              style: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
                height: 1.4,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSparkles(double t) {
    final sparkleOpacity = (1.0 - t).clamp(0.0, 1.0);
    final travel = 34.0 * t;
    final sparkleScale = 0.6 + (0.7 * (1.0 - t));

    return [
      _sparkle(
        top: 78 - travel,
        left: 58 - (travel * 0.35),
        size: 16,
        opacity: sparkleOpacity,
        scale: sparkleScale,
      ),
      _sparkle(
        top: 60 - (travel * 0.75),
        right: 72 - (travel * 0.15),
        size: 12,
        opacity: sparkleOpacity * 0.95,
        scale: sparkleScale,
      ),
      _sparkle(
        top: 126,
        left: 40 - (travel * 0.55),
        size: 10,
        opacity: sparkleOpacity * 0.85,
        scale: sparkleScale,
      ),
      _sparkle(
        top: 138,
        right: 48 - (travel * 0.45),
        size: 14,
        opacity: sparkleOpacity * 0.9,
        scale: sparkleScale,
      ),
      _sparkle(
        bottom: 58 - (travel * 0.5),
        left: 74 - (travel * 0.15),
        size: 12,
        opacity: sparkleOpacity * 0.8,
        scale: sparkleScale,
      ),
      _sparkle(
        bottom: 72 - travel,
        right: 68 - (travel * 0.3),
        size: 18,
        opacity: sparkleOpacity,
        scale: sparkleScale,
      ),
    ];
  }

  Widget _sparkle({
    double? top,
    double? left,
    double? right,
    double? bottom,
    required double size,
    required double opacity,
    required double scale,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: Icon(Icons.auto_awesome, size: size, color: Colors.white),
        ),
      ),
    );
  }
}
