import '../../model/quality.dart';
import 'map_item.dart';

class CellDescriptor {
  MapItem? content;
  Quality quality;

  CellDescriptor.empty() : this(content: null, quality: Quality.UNKNOWN);

  CellDescriptor({
    required this.content,
    required this.quality,
  });

  Map<String, dynamic> toJson() =>
      {'quality': quality.name, ...content?.toJson() ?? {}};
}
