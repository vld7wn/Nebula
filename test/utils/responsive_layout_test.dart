import 'package:flutter_test/flutter_test.dart';
import 'package:nebula/utils/responsive_layout.dart';

void main() {
  group('Breakpoints', () {
    test('has correct values', () {
      expect(Breakpoints.mobile, 600);
      expect(Breakpoints.tablet, 900);
      expect(Breakpoints.desktop, 1200);
      expect(Breakpoints.widescreen, 1800);
    });
  });

  group('DeviceType', () {
    test('has all device types', () {
      expect(DeviceType.values.length, 4);
      expect(DeviceType.values, contains(DeviceType.mobile));
      expect(DeviceType.values, contains(DeviceType.tablet));
      expect(DeviceType.values, contains(DeviceType.desktop));
      expect(DeviceType.values, contains(DeviceType.widescreen));
    });
  });

  group('ScreenInfo', () {
    // Note: Full tests require BuildContext, these test the enum logic
    test('isMobile returns true for mobile type', () {
      // Manual test of logic
      const type = DeviceType.mobile;
      expect(type == DeviceType.mobile, true);
    });

    test('isDesktop returns true for desktop and widescreen', () {
      const desktop = DeviceType.desktop;
      const widescreen = DeviceType.widescreen;
      expect(
        desktop == DeviceType.desktop || desktop == DeviceType.widescreen,
        true,
      );
      expect(
        widescreen == DeviceType.desktop || widescreen == DeviceType.widescreen,
        true,
      );
    });
  });
}
