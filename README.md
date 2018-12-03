# 20181202-ErickManrique-NYCSchools

App Services
GooglePlaces to get an image from a given address
link - https://developers.google.com/places/ios-api/photos#attributions
GoogleGeocodingAPI to get placeId which is needed fot by the GooglePlaces to get the image
link - https://developers.google.com/maps/documentation/geocoding/intro
Alomofire to make network request to School api and Google Geocoding API
link - https://github.com/Alamofire/Alamofire

Note

GooglePhotoPicker does not return results for the addresses of the schools provided by the API
it only works with the google headquarters address for now. 
To test if image works with googles address then don't pass an address to the
getFirstPhotoForPlace function in SchoolsViewController
