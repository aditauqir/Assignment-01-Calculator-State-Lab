import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcons {
  static const String historySvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256">
  <rect width="256" height="256" fill="none"/>
  <polyline points="128 80 128 128 168 152" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
  <polyline points="72 104 32 104 32 64" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
  <path d="M67.6,192A88,88,0,1,0,65.77,65.77C54,77.69,44.28,88.93,32,104" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
</svg>
''';

  static const String lightModeSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256">
  <rect width="256" height="256" fill="none"/>
  <line x1="128" y1="40" x2="128" y2="16" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
  <circle cx="128" cy="128" r="56" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
  <line x1="64" y1="64" x2="48" y2="48" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
  <line x1="64" y1="192" x2="48" y2="208" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
  <line x1="192" y1="64" x2="208" y2="48" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
  <line x1="192" y1="192" x2="208" y2="208" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
  <line x1="40" y1="128" x2="16" y2="128" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
  <line x1="128" y1="216" x2="128" y2="240" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
  <line x1="216" y1="128" x2="240" y2="128" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
</svg>
''';

  static const String darkModeSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256">
  <rect width="256" height="256" fill="none"/>
  <line x1="208" y1="120" x2="208" y2="72" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
  <line x1="232" y1="96" x2="184" y2="96" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
  <line x1="160" y1="32" x2="160" y2="64" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
  <line x1="176" y1="48" x2="144" y2="48" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
  <path d="M210.69,158.18A96.78,96.78,0,0,1,192,160,96.08,96.08,0,0,1,97.82,45.31,88,88,0,1,0,210.69,158.18Z" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
</svg>
''';

  static Widget history({required Color color, double size = 22}) {
    return SvgPicture.string(
      historySvg,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  static Widget lightMode({required Color color, double size = 22}) {
    return SvgPicture.string(
      lightModeSvg,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  static Widget darkMode({required Color color, double size = 22}) {
    return SvgPicture.string(
      darkModeSvg,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
