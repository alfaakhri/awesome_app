import 'package:awesome_app/awesome_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parsing json search result', () {
    // arrange
    PhotosModel photosResult;
    var json = {
      "page": 1,
      "per_page": 1,
      "photos": [
        {
          "id": 10594490,
          "width": 2397,
          "height": 3578,
          "url": "https://www.pexels.com/photo/black-and-white-vinyl-record-on-brown-wooden-round-table-10594490/",
          "photographer": "Alina Kurson",
          "photographer_url": "https://www.pexels.com/@1434506",
          "photographer_id": 1434506,
          "avg_color": "#8D8171",
          "src": {
            "original": "https://images.pexels.com/photos/10594490/pexels-photo-10594490.jpeg",
            "large2x":
                "https://images.pexels.com/photos/10594490/pexels-photo-10594490.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
            "large":
                "https://images.pexels.com/photos/10594490/pexels-photo-10594490.jpeg?auto=compress&cs=tinysrgb&h=650&w=940",
            "medium":
                "https://images.pexels.com/photos/10594490/pexels-photo-10594490.jpeg?auto=compress&cs=tinysrgb&h=350",
            "small":
                "https://images.pexels.com/photos/10594490/pexels-photo-10594490.jpeg?auto=compress&cs=tinysrgb&h=130",
            "portrait":
                "https://images.pexels.com/photos/10594490/pexels-photo-10594490.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
            "landscape":
                "https://images.pexels.com/photos/10594490/pexels-photo-10594490.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200",
            "tiny":
                "https://images.pexels.com/photos/10594490/pexels-photo-10594490.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"
          },
          "liked": false,
          "alt": "Black and White Vinyl Record on Brown Wooden Round Table"
        }
      ],
      "total_results": 8000,
      "next_page": "https://api.pexels.com/v1/curated/?page=2&per_page=1"
    };
    // act
    photosResult = PhotosModel.fromJson(json);
    // assert
    expect(photosResult.photos!.isNotEmpty, true);
  });
}
