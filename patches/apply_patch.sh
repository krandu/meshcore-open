#!/bin/bash
set -e

# ── quick_switch_bar.dart ──────────────────────────────────────────────
FILE="lib/widgets/quick_switch_bar.dart"

# 1. Add imports after "import '../l10n/l10n.dart';"
sed -i "s|import '../l10n/l10n.dart';|import '../l10n/l10n.dart';\nimport 'package:provider/provider.dart';\nimport '../connector/meshcore_connector.dart';|" "$FILE"

# 2. Add two new NavigationDestinations after the map destination closing paren
# Find the line with nav_map label and insert after the closing ")," 
python3 - "$FILE" << 'PYEOF'
import sys
path = sys.argv[1]
with open(path, 'r') as f:
    content = f.read()

old = """                  NavigationDestination(
                    icon: const Icon(Icons.map_outlined),
                    label: context.l10n.nav_map,
                  ),
                ],"""

new = """                  NavigationDestination(
                    icon: const Icon(Icons.map_outlined),
                    label: context.l10n.nav_map,
                  ),
                  NavigationDestination(
                    icon: Consumer<MeshCoreConnector>(
                      builder: (context, connector, _) {
                        switch (connector.state) {
                          case MeshCoreConnectionState.connected:
                            return const Icon(Icons.bluetooth_connected);
                          case MeshCoreConnectionState.connecting:
                          case MeshCoreConnectionState.scanning:
                            return const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          default:
                            return const Icon(Icons.bluetooth);
                        }
                      },
                    ),
                    selectedIcon: const Icon(Icons.bluetooth_connected),
                    label: '连接',
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.settings_outlined),
                    selectedIcon: const Icon(Icons.settings),
                    label: '设置',
                  ),
                ],"""

if old not in content:
    print(f"ERROR: pattern not found in {path}")
    sys.exit(1)

content = content.replace(old, new, 1)
with open(path, 'w') as f:
    f.write(content)
print(f"OK: {path}")
PYEOF

# ── contacts_screen.dart ──────────────────────────────────────────────
FILE="lib/screens/contacts_screen.dart"

# Add import
sed -i "s|import 'discovery_screen.dart';|import 'discovery_screen.dart';\nimport 'scanner_screen.dart';|" "$FILE"

# Add case 3 and 4 to _handleQuickSwitch
python3 - "$FILE" << 'PYEOF'
import sys
path = sys.argv[1]
with open(path, 'r') as f:
    content = f.read()

old = """      case 2:
        Navigator.pushReplacement(
          context,
          buildQuickSwitchRoute(const MapScreen(hideBackButton: true)),
        );
        break;
    }
  }

  void _showRepeaterLogin"""

new = """      case 2:
        Navigator.pushReplacement(
          context,
          buildQuickSwitchRoute(const MapScreen(hideBackButton: true)),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ScannerScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
        break;
    }
  }

  void _showRepeaterLogin"""

if old not in content:
    print(f"ERROR: pattern not found in {path}")
    sys.exit(1)

content = content.replace(old, new, 1)
with open(path, 'w') as f:
    f.write(content)
print(f"OK: {path}")
PYEOF

# ── channels_screen.dart ──────────────────────────────────────────────
FILE="lib/screens/channels_screen.dart"

# Add import
sed -i "s|import '../widgets/unread_badge.dart';|import '../widgets/unread_badge.dart';\nimport 'scanner_screen.dart';|" "$FILE"

# Add case 3 and 4
python3 - "$FILE" << 'PYEOF'
import sys
path = sys.argv[1]
with open(path, 'r') as f:
    content = f.read()

old = """      case 2:
        Navigator.pushReplacement(
          context,
          buildQuickSwitchRoute(const MapScreen(hideBackButton: true)),
        );
        break;
    }
  }

  Future<void> _disconnect"""

new = """      case 2:
        Navigator.pushReplacement(
          context,
          buildQuickSwitchRoute(const MapScreen(hideBackButton: true)),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ScannerScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
        break;
    }
  }

  Future<void> _disconnect"""

if old not in content:
    print(f"ERROR: pattern not found in {path}")
    sys.exit(1)

content = content.replace(old, new, 1)
with open(path, 'w') as f:
    f.write(content)
print(f"OK: {path}")
PYEOF

# ── map_screen.dart ──────────────────────────────────────────────
FILE="lib/screens/map_screen.dart"

# Add import
sed -i "s|import 'chat_screen.dart';|import 'chat_screen.dart';\nimport 'scanner_screen.dart';|" "$FILE"

# Add case 3 and 4
python3 - "$FILE" << 'PYEOF'
import sys
path = sys.argv[1]
with open(path, 'r') as f:
    content = f.read()

old = """      case 1:
        Navigator.pushReplacement(
          context,
          buildQuickSwitchRoute(const ChannelsScreen(hideBackButton: true)),
        );
        break;
    }
  }

  Future<void> _disconnect"""

new = """      case 1:
        Navigator.pushReplacement(
          context,
          buildQuickSwitchRoute(const ChannelsScreen(hideBackButton: true)),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ScannerScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
        break;
    }
  }

  Future<void> _disconnect"""

if old not in content:
    print(f"ERROR: pattern not found in {path}")
    sys.exit(1)

content = content.replace(old, new, 1)
with open(path, 'w') as f:
    f.write(content)
print(f"OK: {path}")
PYEOF

echo "All patches applied successfully"
