class SearchLocationResult {
  late List<Predictions> predictions;

  SearchLocationResult({required this.predictions});

  SearchLocationResult.fromJson(json) {
    if (json['predictions'] != null) {
      predictions = <Predictions>[];
      json['predictions'].forEach((v) {
        predictions.add(Predictions.fromJson(v as Map<String, dynamic>));
      });
    }
  }
}

class Predictions {
  late String description;
  late String placeId;
  late StructuredFormatting structuredFormatting;

  Predictions({
    required this.description,
    required this.placeId,
    required this.structuredFormatting,
  });

  Predictions.fromJson(Map<String, dynamic> json) {
    description = json['description'] as String;
    placeId = json['place_id'] as String;

    if (json['structured_formatting'] != null) {
      structuredFormatting = StructuredFormatting.fromJson(
          json['structured_formatting'] as Map<String, dynamic>);
    }
  }
}

class StructuredFormatting {
  late String mainText;

  StructuredFormatting({required this.mainText});

  StructuredFormatting.fromJson(Map<String, dynamic> json) {
    mainText = json['main_text'] as String;
  }
}
