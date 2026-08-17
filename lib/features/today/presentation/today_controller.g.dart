// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TodayController)
final todayControllerProvider = TodayControllerProvider._();

final class TodayControllerProvider
    extends $StreamNotifierProvider<TodayController, TodayState> {
  TodayControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todayControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todayControllerHash();

  @$internal
  @override
  TodayController create() => TodayController();
}

String _$todayControllerHash() => r'5571a4fb19aefadd8e54e9ca34b4d2a45c2bf254';

abstract class _$TodayController extends $StreamNotifier<TodayState> {
  Stream<TodayState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<TodayState>, TodayState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<TodayState>, TodayState>,
        AsyncValue<TodayState>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
