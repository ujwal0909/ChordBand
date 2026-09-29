import 'package:flutter/material.dart';
import 'package:chord_engine/chord_engine.dart';
import '../../../../core/theme/app_colors.dart';

class SectionJumpSheet extends StatelessWidget {
  final List<SongSection> sections;
  final Set<int> collapsedSectionIndices;
  final ValueChanged<int> onJumpToSection;
  final ValueChanged<int> onToggleCollapse;
  final bool isStageMode;

  const SectionJumpSheet({
    super.key,
    required this.sections,
    required this.collapsedSectionIndices,
    required this.onJumpToSection,
    required this.onToggleCollapse,
    this.isStageMode = false,
  });

  static Future<void> show({
    required BuildContext context,
    required List<SongSection> sections,
    required Set<int> collapsedSectionIndices,
    required ValueChanged<int> onJumpToSection,
    required ValueChanged<int> onToggleCollapse,
    bool isStageMode = false,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: isStageMode ? AppColors.stageSurface : null,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SectionJumpSheet(
        sections: sections,
        collapsedSectionIndices: collapsedSectionIndices,
        onJumpToSection: onJumpToSection,
        onToggleCollapse: onToggleCollapse,
        isStageMode: isStageMode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = isStageMode ? AppColors.stageChordAccent : AppColors.primary;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.format_list_bulleted, color: titleColor),
                const SizedBox(width: 8),
                Text(
                  'Song Sections',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: sections.length,
                separatorBuilder: (ctx, i) => const Divider(height: 1),
                itemBuilder: (ctx, index) {
                  final section = sections[index];
                  final isCollapsed = collapsedSectionIndices.contains(index);

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor: _getSectionColor(section.sectionType, isStageMode),
                      child: Text(
                        _getSectionAbbreviation(section.sectionType),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      section.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isStageMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            isCollapsed ? Icons.unfold_more : Icons.unfold_less,
                            color: isStageMode ? Colors.white70 : Colors.black54,
                          ),
                          tooltip: isCollapsed ? 'Expand Section' : 'Collapse Section',
                          onPressed: () => onToggleCollapse(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios, size: 16, color: titleColor),
                          tooltip: 'Jump to Section',
                          onPressed: () {
                            Navigator.of(context).pop();
                            onJumpToSection(index);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      onJumpToSection(index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSectionColor(SectionType type, bool isStage) {
    if (isStage) {
      switch (type) {
        case SectionType.chorus:
          return AppColors.stageSectionBadge;
        case SectionType.bridge:
          return AppColors.stageChordAccent;
        case SectionType.verse:
          return AppColors.stageChord;
        default:
          return Colors.blueGrey;
      }
    } else {
      switch (type) {
        case SectionType.chorus:
          return AppColors.secondary;
        case SectionType.bridge:
          return Colors.orange;
        case SectionType.verse:
          return AppColors.primary;
        default:
          return Colors.blueGrey;
      }
    }
  }

  String _getSectionAbbreviation(SectionType type) {
    switch (type) {
      case SectionType.chorus:
        return 'Ch';
      case SectionType.verse:
        return 'Vs';
      case SectionType.bridge:
        return 'Br';
      case SectionType.intro:
        return 'In';
      case SectionType.outro:
        return 'Out';
      case SectionType.preChorus:
        return 'Pre';
      default:
        return 'Sec';
    }
  }
}
